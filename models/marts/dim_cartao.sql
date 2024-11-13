with int_cartao as (
    select * from {{ ref('stg_sap__cartao_credito') }}
),
dim_cartao as (
    select 
        -- chave surrogate
        {{ dbt_utils.generate_surrogate_key([
            'c.ID_CARTAO'
        ]) }} as SK_CARTAO
        -- chaves naturais
        , c.ID_CARTAO
        -- atributos
        , c.TIPO_CARTAO
        , c.NUMERO_CARTAO
        -- metadados
        , current_timestamp() as DW_DATA_CARGA
    from int_cartao as c
)
select * from dim_cartao