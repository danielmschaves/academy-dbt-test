with int_cliente_pessoa as (
    select * from {{ ref('int_cliente_pessoa') }}
),
dim_cliente as (
    select 
        -- chave surrogate
        {{ dbt_utils.generate_surrogate_key([
            'cp.ID_CLIENTE',
            'cp.ID_TERRITORIO'
        ]) }} as SK_CLIENTE
        -- chaves naturais
        , cp.ID_CLIENTE
        , cp.ID_TERRITORIO
        -- atributos
        , cp.NOME
        , cp.SOBRENOME
        , cp.NOME_COMPLETO
        -- metadados
        , current_timestamp() as DW_DATA_CARGA
    from int_cliente_pessoa as cp
)
select * from dim_cliente