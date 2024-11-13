with src_detalhe_pedido as (
    select * from {{ source('sap', 'salesorderdetail') }}
),
detalhe_pedido as (
    select
        -- chave primária
        salesorderdetailid as ID_DETALHE_PEDIDO
        -- chaves estrangeiras
        , salesorderid as ID_PEDIDO
        , productid as ID_PRODUTO
        , specialofferid as ID_OFERTA_ESPECIAL
        -- texto
        , carriertrackingnumber as CODIGO_RASTREAMENTO
        -- valores
        , unitprice as PRECO_UNITARIO
        , unitpricediscount as DESCONTO_UNITARIO
        , orderqty as QUANTIDADE
        -- data e timestamp
        , cast(modifieddate as timestamp) as DATA_MODIFICACAO
        -- chave única
        , rowguid as ID_LINHA_UNICO
    from 
        src_detalhe_pedido
)
select * from detalhe_pedido