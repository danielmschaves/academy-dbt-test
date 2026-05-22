{% docs project_overview %}

# Adventure Works Analytics — dbt Project

Este projeto transforma dados brutos do SAP da **Adventure Works** em um modelo estrela
analítico, pronto para consumo em dashboards e análises de negócio.

## Arquitetura em 3 Camadas

```
Seeds (sap_adw) → Staging (views) → Intermediate (views) → Marts (tables)
```

| Camada | Schema | Materialização | Propósito |
|---|---|---|---|
| Seeds | `sap_adw` | tabelas | 64 CSVs do SAP carregados via `dbt seed` |
| Staging | `stg` | views | Renomeação e tipagem das colunas brutas |
| Intermediate | `int` | views | Joins e cálculos que preparam os marts |
| Marts | `mrt` | tables | Modelo estrela final; consumido por BI |

## Modelo Estrela

A tabela fato `fato_vendas` registra cada item de pedido e conecta às dimensões:

- **dim_clientes** — quem comprou
- **dim_produto** — o que foi comprado (com hierarquia categoria → subcategoria)
- **dim_localidade** — onde (endereço de cobrança → cidade → estado → país)
- **dim_data** — quando (spine diário 2011–2014, com atributos de semana e mês)
- **dim_cartao** — como pagou
- **dim_motivo_venda** + **bridge_motivo_venda** — por que comprou (relação N:N)

## Modelo Analítico

`mart_performance_cliente` agrega por cliente: receita total, ticket médio, frequência
e segmentação por quartil de receita (NTILE 4).

{% enddocs %}
