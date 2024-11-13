with int_produto as (
   select * from {{ ref('stg_sap__produto') }}
),
dim_produto as (
   select 
       -- chave surrogate
       {{ dbt_utils.generate_surrogate_key([
           'p.ID_PRODUTO'
       ]) }} as SK_PRODUTO
       -- chaves naturais
       , p.ID_PRODUTO
       -- atributos
       , p.NOME_PRODUTO
       , p.CODIGO_PRODUTO
       , p.CUSTO_PADRAO
       , p.PRECO_LISTA
       -- metadados
       , current_timestamp() as DW_DATA_CARGA
   from int_produto as p
)
select * from dim_produto