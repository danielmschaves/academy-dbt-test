with int_produto as (
   select * from {{ ref('stg_sap__produto') }}
),
int_produto_categoria as (
   select * from {{ ref('int_produto_categoria') }}
),
dim_produto as (
   select 
       -- chave surrogate
       {{ dbt_utils.generate_surrogate_key([
           'p.ID_PRODUTO'
       ]) }} as SK_PRODUTO
       -- chaves naturais
       , p.ID_PRODUTO
       , pc.ID_CATEGORIA
       , pc.ID_SUBCATEGORIA
       -- atributos
       , p.NOME_PRODUTO
       , pc.NOME_CATEGORIA
       , pc.NOME_SUBCATEGORIA
       , p.CODIGO_PRODUTO
       , p.CUSTO_PADRAO
       , p.PRECO_LISTA
       , p.PESO
       -- datas
       , p.DATA_INICIO_VENDA
       , p.DATA_FIM_VENDA
       -- metadados
       , current_timestamp() as DW_DATA_CARGA
   from int_produto p
   left join int_produto_categoria pc 
       on p.ID_PRODUTO = pc.ID_PRODUTO
)
select * from dim_produto