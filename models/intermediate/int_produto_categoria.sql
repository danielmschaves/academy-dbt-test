with stg_produto as (
   select * from {{ ref('stg_sap__produto') }}
),
stg_categoria_produto as (
   select * from {{ ref('stg_sap__produto_categoria') }}
),
stg_categoria as (
   select * from {{ ref('stg_sap__categoria') }}
),
produto_categoria as (
   select
       p.ID_PRODUTO
       , cp.ID_CATEGORIA
       , p.ID_SUBCATEGORIA
       , p.NOME_PRODUTO
       , cp.NOME_SUBCATEGORIA
       , c.NOME_CATEGORIA
   from stg_produto p
   left join stg_categoria_produto cp 
       on p.ID_SUBCATEGORIA = cp.ID_SUBCATEGORIA
   left join stg_categoria c 
       on cp.ID_CATEGORIA = c.ID_CATEGORIA
)
select * from produto_categoria