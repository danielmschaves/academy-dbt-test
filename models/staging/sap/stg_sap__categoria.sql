with src_category as (
   select * from {{ source('sap', 'productcategory') }}
),
categoria as (
   select
       productcategoryid as ID_CATEGORIA
       , name as NOME_CATEGORIA
       , cast(modifieddate as timestamp) as DATA_MODIFICACAO
   from src_category
)
select * from categoria