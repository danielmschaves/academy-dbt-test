with stg_endereco as (
    select * from {{ ref('stg_sap__endereco') }}
),
stg_estado as (
    select * from {{ ref('stg_sap__estado') }}
),
stg_pais as (
    select * from {{ ref('stg_sap__pais') }}
),
endereco_completo as (
    select 
        e.ID_ENDERECO
        , e.CIDADE
        , es.NOME_ESTADO as ESTADO
        , p.NOME_PAIS as PAIS
    from stg_endereco e
    left join stg_estado es 
        on e.ID_ESTADO = es.ID_ESTADO
    left join stg_pais p 
        on es.ID_PAIS = p.ID_PAIS
)
select * from endereco_completo