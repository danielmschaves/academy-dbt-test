with stg_motivo_venda as (
    select * from {{ ref('stg_sap__motivo_venda') }}
),
dim_motivo_venda as (
    select 
        -- chave surrogate
        {{ dbt_utils.generate_surrogate_key(['ID_MOTIVO_VENDA']) }} as SK_MOTIVO_VENDA
        -- chaves naturais
        , ID_MOTIVO_VENDA
        -- atributos
        , NOME_MOTIVO
        , TIPO_MOTIVO
        -- metadados
        , current_timestamp() as DW_DATA_CARGA
    from stg_motivo_venda
)
select * from dim_motivo_venda