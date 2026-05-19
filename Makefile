# Makefile

PROJECT_DIR = .
PROFILE = academy_dbt_test

# ── Setup ────────────────────────────────────────────────────────────────────
.PHONY: install deps debug

install:
	uv sync

deps:
	dbt deps

debug:
	dbt debug

# ── Core dbt ─────────────────────────────────────────────────────────────────
.PHONY: seeds build test docs clean

seeds:
	dbt seed

build:
	dbt build

test:
	dbt test

docs:
	dbt docs generate
	dbt docs serve

clean:
	dbt clean
	rm -rf target/ dbt_packages/ logs/

# ── Layer targets ─────────────────────────────────────────────────────────────
.PHONY: build_stg build_int build_marts test_marts run_fact

build_stg:
	dbt build --select staging

build_int:
	dbt build --select intermediate

build_marts:
	dbt build --select marts

test_marts:
	dbt test --select marts

run_fact:
	dbt build --select fato_vendas

# ── Code quality ──────────────────────────────────────────────────────────────
.PHONY: lint fix

lint:
	sqlfluff lint models/

fix:
	sqlfluff fix models/

# ── Composite ─────────────────────────────────────────────────────────────────
.PHONY: full-build full-refresh

full-build: deps build test docs

full-refresh:
	dbt run --full-refresh
