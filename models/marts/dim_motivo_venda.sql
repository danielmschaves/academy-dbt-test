with int_vendas_motivos as (
    select * from {{ ref('int_vendas_motivos') }}
),
dim_motivo_venda as (
    select 
        -- chave surrogate
        {{ dbt_utils.generate_surrogate_key([
            'ID_PEDIDO'
        ]) }} as SK_MOTIVO_VENDA
        -- chaves naturais
        , ID_PEDIDO
        -- atributos
        , MOTIVOS_VENDA
        -- metadados
        , current_timestamp() as DW_DATA_CARGA
    from int_vendas_motivos
)
select * from dim_motivo_venda