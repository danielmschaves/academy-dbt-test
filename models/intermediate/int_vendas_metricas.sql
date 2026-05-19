WITH vendas AS (
    SELECT * FROM {{ ref('int_vendas_pedidos') }}
),

metricas AS (
    SELECT
        -- identificadores
        ID_DETALHE_PEDIDO,
        ID_PEDIDO,
        ID_PRODUTO,
        ID_CLIENTE,
        ID_ENDERECO_COBRANCA,
        ID_CARTAO_CREDITO,
        -- métricas base
        PRECO_UNITARIO,
        DESCONTO_UNITARIO,
        QUANTIDADE,
        VALOR_BRUTO,
        VALOR_LIQUIDO,
        DATA_PEDIDO,
        STATUS,
        FLAG_PEDIDO_ONLINE,
        TIPO_CARTAO,

        -- número sequencial do pedido por cliente (cronológico)
        ROW_NUMBER() OVER (
            PARTITION BY ID_CLIENTE
            ORDER BY DATA_PEDIDO, ID_PEDIDO
        ) AS NUMERO_PEDIDO_CLIENTE,

        -- receita acumulada do cliente até o pedido corrente
        SUM(VALOR_BRUTO) OVER (
            PARTITION BY ID_CLIENTE
            ORDER BY DATA_PEDIDO, ID_PEDIDO
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS RECEITA_ACUMULADA_CLIENTE,

        -- data do pedido anterior do mesmo cliente
        LAG(DATA_PEDIDO) OVER (
            PARTITION BY ID_CLIENTE
            ORDER BY DATA_PEDIDO, ID_PEDIDO
        ) AS DATA_PEDIDO_ANTERIOR,

        -- dias desde o último pedido do cliente
        DATE_DIFF(
            CAST(DATA_PEDIDO AS DATE),
            CAST(
                LAG(DATA_PEDIDO) OVER (
                    PARTITION BY ID_CLIENTE
                    ORDER BY DATA_PEDIDO, ID_PEDIDO
                ) AS DATE
            ),
            DAY
        ) AS DIAS_DESDE_ULTIMO_PEDIDO,

        -- ranking do item dentro do produto por valor bruto (desc)
        RANK() OVER (
            PARTITION BY ID_PRODUTO
            ORDER BY VALOR_BRUTO DESC
        ) AS RANK_VALOR_PRODUTO

    FROM vendas
)

SELECT * FROM metricas
