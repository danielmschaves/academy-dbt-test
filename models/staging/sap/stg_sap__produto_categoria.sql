with src_product_category as (
   select * from {{ source('sap', 'productsubcategory') }}
),
categoria_produto as (
   select
       -- chaves
       productsubcategoryid as ID_SUBCATEGORIA
       , productcategoryid as ID_CATEGORIA
       -- atributos
       , name as NOME_SUBCATEGORIA
       -- data
       , cast(modifieddate as timestamp) as DATA_MODIFICACAO
   from
       src_product_category
)
select * from categoria_produto