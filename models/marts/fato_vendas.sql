with vendas_pedidos as (
    select * from {{ ref('int_vendas_pedidos') }}
),

dim_clientes as (
    select
        SK_CLIENTE
        , ID_CLIENTE
    from {{ ref('dim_clientes') }}
),

dim_localidade as (
    select
        SK_LOCALIDADE
        , ID_ENDERECO
    from {{ ref('dim_localidade') }}
),

dim_produto as (
    select
        SK_PRODUTO
        , ID_PRODUTO
    from {{ ref('dim_produto') }}
),

dim_cartao as (
    select
        SK_CARTAO
        , ID_CARTAO
    from {{ ref('dim_cartao') }}
),

dim_data as (
    select
        SK_DATA
        , DATA_PEDIDO
    from {{ ref('dim_data') }}
),

fato_vendas as (
    select
        {{ dbt_utils.generate_surrogate_key([
         'vp.ID_DETALHE_PEDIDO',
         'vp.ID_PEDIDO']) }} as SK_VENDA
        -- chaves naturais
        , vp.ID_DETALHE_PEDIDO
        , vp.ID_PEDIDO
        -- foreign keys
        , c.SK_CLIENTE as FK_CLIENTE
        , l.SK_LOCALIDADE as FK_LOCALIDADE
        , p.SK_PRODUTO as FK_PRODUTO
        , cc.SK_CARTAO as FK_CARTAO
        , d.SK_DATA as FK_DATA
        -- métricas
        , vp.PRECO_UNITARIO
        , vp.DESCONTO_UNITARIO
        , vp.QUANTIDADE
        , vp.VALOR_BRUTO
        , vp.VALOR_LIQUIDO
        , vp.VALOR_TOTAL
        -- flags
        , vp.FLAG_PEDIDO_ONLINE
        , vp.STATUS
    from vendas_pedidos vp
    left join dim_clientes c 
        on vp.ID_CLIENTE = c.ID_CLIENTE
    left join dim_localidade l 
        on vp.ID_ENDERECO_COBRANCA = l.ID_ENDERECO
    left join dim_produto p 
        on vp.ID_PRODUTO = p.ID_PRODUTO
    left join dim_cartao cc 
        on vp.ID_CARTAO_CREDITO = cc.ID_CARTAO
    left join dim_data d 
        on vp.DATA_PEDIDO = d.DATA_PEDIDO
)

select * from fato_vendas