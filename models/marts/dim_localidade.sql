with int_endereco_completo as (
    select * from {{ ref('int_endereco_completo') }}
),
dim_localidade as (
    select 
        -- chave surrogate
        {{ dbt_utils.generate_surrogate_key([
            'e.ID_ENDERECO'
        ]) }} as SK_LOCALIDADE
        -- chaves naturais
        , e.ID_ENDERECO
        -- atributos
        , e.CIDADE
        , e.ESTADO
        , e.PAIS
        -- metadados
        , current_timestamp() as DW_DATA_CARGA
    from int_endereco_completo as e
)
select * from dim_localidade