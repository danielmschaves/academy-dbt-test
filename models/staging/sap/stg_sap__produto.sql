with src_product as (
    select * from {{ source('sap', 'product') }}
),
products as (
    select
        -- chave primária
        productid as ID_PRODUTO
        , productsubcategoryid as ID_SUBCATEGORIA
        -- textos
        , name as NOME_PRODUTO
        , name as NOME_SUBCATEGORIA
        , productnumber as CODIGO_PRODUTO
        -- valores
        , standardcost as CUSTO_PADRAO
        , listprice as PRECO_LISTA
        , weight as PESO
        -- datas
        , cast(sellstartdate as timestamp) as DATA_INICIO_VENDA
        , cast(sellenddate as timestamp) as DATA_FIM_VENDA
        , cast(modifieddate as timestamp) as DATA_MODIFICACAO
        -- chave única
        , rowguid as ID_LINHA_UNICO
    from
        src_product
)
select * from products