{{
    config(
        materialized = 'table',
        tags = ['marts', 'production', 'analytics']
    )
}}

WITH metricas AS (
    SELECT * FROM {{ ref('int_vendas_metricas') }}
),

clientes AS (
    SELECT
        SK_CLIENTE,
        ID_CLIENTE,
        NOME_COMPLETO
    FROM {{ ref('dim_clientes') }}
),

agregado AS (
    SELECT
        ID_CLIENTE,
        COUNT(DISTINCT ID_PEDIDO)                     AS TOTAL_PEDIDOS,
        COUNT(ID_DETALHE_PEDIDO)                      AS TOTAL_ITENS,
        SUM(VALOR_BRUTO)                              AS RECEITA_BRUTA_TOTAL,
        SUM(VALOR_LIQUIDO)                            AS RECEITA_LIQUIDA_TOTAL,
        AVG(VALOR_BRUTO)                              AS TICKET_MEDIO_ITEM,
        MIN(CAST(DATA_PEDIDO AS DATE))                AS DATA_PRIMEIRO_PEDIDO,
        MAX(CAST(DATA_PEDIDO AS DATE))                AS DATA_ULTIMO_PEDIDO,
        DATE_DIFF(
            MAX(CAST(DATA_PEDIDO AS DATE)),
            MIN(CAST(DATA_PEDIDO AS DATE)),
            DAY
        )                                              AS DIAS_COMO_CLIENTE,
        AVG(DIAS_DESDE_ULTIMO_PEDIDO)                 AS MEDIA_DIAS_ENTRE_PEDIDOS,
        COUNTIF(FLAG_PEDIDO_ONLINE)                   AS PEDIDOS_ONLINE,
        COUNTIF(NOT FLAG_PEDIDO_ONLINE)               AS PEDIDOS_PRESENCIAIS
    FROM metricas
    GROUP BY ID_CLIENTE
),

com_quartil AS (
    SELECT
        a.*,
        c.SK_CLIENTE,
        c.NOME_COMPLETO,
        -- segmentação de clientes por quartil de receita
        NTILE(4) OVER (ORDER BY a.RECEITA_BRUTA_TOTAL DESC) AS QUARTIL_RECEITA,
        -- ranking global por receita
        RANK() OVER (ORDER BY a.RECEITA_BRUTA_TOTAL DESC)   AS RANK_RECEITA_GLOBAL
    FROM agregado a
    LEFT JOIN clientes c USING (ID_CLIENTE)
)

SELECT
    SK_CLIENTE,
    ID_CLIENTE,
    NOME_COMPLETO,
    TOTAL_PEDIDOS,
    TOTAL_ITENS,
    RECEITA_BRUTA_TOTAL,
    RECEITA_LIQUIDA_TOTAL,
    TICKET_MEDIO_ITEM,
    DATA_PRIMEIRO_PEDIDO,
    DATA_ULTIMO_PEDIDO,
    DIAS_COMO_CLIENTE,
    MEDIA_DIAS_ENTRE_PEDIDOS,
    PEDIDOS_ONLINE,
    PEDIDOS_PRESENCIAIS,
    QUARTIL_RECEITA,
    RANK_RECEITA_GLOBAL,
    CURRENT_TIMESTAMP() AS DW_DATA_CARGA
FROM com_quartil
