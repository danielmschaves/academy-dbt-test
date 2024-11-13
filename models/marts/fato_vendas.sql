with int_vendas_pedidos as (
    select * from {{ ref('int_vendas_pedidos') }}
),
dim_clientes as (
    select * from {{ ref('dim_clientes') }}
),
dim_localidade as (
    select * from {{ ref('dim_localidade') }}
),
dim_produto as (
    select * from {{ ref('dim_produto') }}
),
dim_data as (
    select * from {{ ref('dim_data') }}
),
dim_cartao as (
    select * from {{ ref('dim_cartao') }}
),
dim_motivo_venda as (
    select * from {{ ref('dim_motivo_venda') }}
),
vendas_join as (
    select
        -- chaves naturais
        vp.ID_DETALHE_PEDIDO
        , vp.ID_PEDIDO
        -- foreign keys
        , c.SK_CLIENTE as FK_CLIENTE
        , l.SK_LOCALIDADE as FK_LOCALIDADE
        , p.SK_PRODUTO as FK_PRODUTO
        , cc.SK_CARTAO as FK_CARTAO
        , t.SK_DATA as FK_DATA
        , m.SK_MOTIVO_VENDA as FK_MOTIVO_VENDA
        , case
            when m.MOTIVOS_VENDA is null then 'Unknown'
            else m.MOTIVOS_VENDA
        end as MOTIVO_VENDA_AGG
        -- atributos adicionais
        , vp.ID_OFERTA_ESPECIAL
        , vp.ID_CARTAO_CREDITO
        , vp.TIPO_CARTAO
        , c.NOME_COMPLETO as CLIENTE
        , vp.DATA_PEDIDO
        , l.CIDADE
        , l.ESTADO
        , l.PAIS
        , p.NOME_PRODUTO
        , p.CODIGO_PRODUTO
        -- métricas
        , vp.PRECO_UNITARIO
        , vp.DESCONTO_UNITARIO
        , vp.QUANTIDADE
        , vp.FRETE
        , vp.SUBTOTAL
        , vp.VALOR_IMPOSTO
        , vp.VALOR_TOTAL
        , vp.VALOR_BRUTO
        , vp.VALOR_LIQUIDO
        -- flags
        , vp.FLAG_PEDIDO_ONLINE
        , vp.STATUS
    from int_vendas_pedidos as vp
    left join dim_clientes as c on vp.ID_CLIENTE = c.ID_CLIENTE
    left join dim_localidade as l on vp.ID_ENDERECO_COBRANCA = l.ID_ENDERECO
    left join dim_produto as p on vp.ID_PRODUTO = p.ID_PRODUTO
    left join dim_cartao as cc on vp.ID_CARTAO_CREDITO = cc.ID_CARTAO
    left join dim_data as t on vp.DATA_PEDIDO = t.DATA_PEDIDO
    left join dim_motivo_venda as m on vp.ID_PEDIDO = m.ID_PEDIDO
),
fato_vendas as (
    select
        {{ dbt_utils.generate_surrogate_key(['ID_DETALHE_PEDIDO', 'ID_PEDIDO']) }} as SK_VENDA,
        *
    from vendas_join
)
select * from fato_vendas