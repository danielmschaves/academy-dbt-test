# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

dbt Core project transforming SAP Adventure Works data into a star-schema mart on BigQuery.
Package manager: **uv**. SQL linter: **SQLFluff**. Warehouse: **BigQuery**.
dbt package: `dbt_utils` 1.0.0 (`generate_surrogate_key`, `date_spine`).

## Environment Setup

```bash
uv sync                # install all deps into .venv
source .venv/bin/activate   # or .venv\Scripts\activate on Windows
```

BigQuery credentials go in `temp/<keyfile>.json`. `profiles.yml` in the project root
(not `~/.dbt/`) references that keyfile. Verify connectivity:

```bash
make debug
```

## Key Commands

```bash
make install        # uv sync (first-time setup)
make deps           # dbt deps (run after cloning or package changes)
make seeds          # load 64 seed CSVs into sap_adw schema
make build          # dbt build (all models)
make test           # dbt test (all models)
make docs           # generate + serve docs at http://localhost:8080
make full-build     # deps → build → test → docs

# Layer-specific
make build_stg      # staging only
make build_int      # intermediate only
make build_marts    # marts only
make run_fact       # fato_vendas only

# SQL quality
make lint           # sqlfluff lint models/
make fix            # sqlfluff fix models/

make full-refresh   # dbt run --full-refresh
make clean          # remove target/, dbt_packages/, logs/
```

Single model:
```bash
dbt build --select <model_name>
dbt test  --select <model_name>
```

> `dbt seed` may hang after loading all 64 tables — restart the terminal if needed.

## Data Architecture

Three-layer pipeline with BigQuery schemas `stg` → `int` → `mrt`.

### Staging (`models/staging/sap/`, schema: `stg`, views)
One model per source table, named `stg_sap__<table>` (double underscore = source separator).
Responsibilities: rename columns to uppercase Portuguese (`salesorderid → ID_PEDIDO`),
cast dates to `timestamp`, no business logic. Every model has a companion `.yml` file.

### Intermediate (`models/intermediate/`, schema: `int`, views)
Five models that join and transform staging output:

| Model | What it does |
|---|---|
| `int_cliente_pessoa` | Joins customers + person data; produces `NOME_COMPLETO` |
| `int_endereco_completo` | Resolves address → state → country hierarchy |
| `int_produto_categoria` | Joins product + subcategory + category hierarchy |
| `int_vendas_pedidos` | Core sales grain: order header + detail + credit card; computes `VALOR_BRUTO`/`VALOR_LIQUIDO`; decodes STATUS |
| `int_vendas_metricas` | Extends `int_vendas_pedidos` with window functions (purchase sequence, cumulative revenue, days between orders, product rank) |

### Marts (`models/marts/`, schema: `mrt`, tables)
Star schema centered on `fato_vendas` plus one analytical mart:

| Model | Type | Key fact |
|---|---|---|
| `fato_vendas` | Fact | One row per order line item |
| `dim_clientes` | Dimension | Customer + territory |
| `dim_produto` | Dimension | Product + subcategory + category |
| `dim_localidade` | Dimension | Address → city → state → country |
| `dim_data` | Dimension | Date spine 2011–2014 with week/month flags |
| `dim_cartao` | Dimension | Credit card type |
| `dim_motivo_venda` | Dimension | Sales reason lookup |
| `bridge_motivo_venda` | Bridge | N:N between orders and sales reasons |
| `mart_performance_cliente` | Analytical | Customer aggregates + NTILE revenue quartiles |

### Conventions
- Surrogate keys: `SK_` prefix via `dbt_utils.generate_surrogate_key([...])`.
- Foreign keys in fact: `FK_` prefix.
- All mart columns: uppercase (`SK_VENDA`, `VALOR_BRUTO`).
- Natural/business keys: `ID_` prefix (set in staging, carried through).
- `DW_DATA_CARGA = CURRENT_TIMESTAMP()` on every mart model.
- Tags: `staging+sap`, `intermediate`, `marts+production` (set in `dbt_project.yml`).

### Seeds (`seeds/sap_adventure_works/`)
64 CSVs in `human_resources/`, `person/`, `production/`, `purchasing/`, `sales/`.
All load into `sap_adw` schema. Column type overrides in `seeds/sap_adventure_works/seed_schema.yml`.

## SQL Linting

SQLFluff is configured in `.sqlfluff` with `dialect = bigquery`, `templater = dbt`.
Rules enforce uppercase keywords and identifiers, 4-space indent, max 100-char lines.
Pre-commit hooks run `sqlfluff-lint` automatically on staged SQL files.
