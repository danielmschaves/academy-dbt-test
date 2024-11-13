with stg_pedido_motivo_venda as (
    select * from {{ ref('stg_sap__pedido_motivo_venda') }}
),
stg_motivo_venda as (
    select * from {{ ref('stg_sap__motivo_venda') }}
),
vendas_motivos as (
    select 
        pmv.ID_PEDIDO
        , string_agg(mv.NOME_MOTIVO, ', ') as MOTIVOS_VENDA
    from stg_motivo_venda as mv
    left join stg_pedido_motivo_venda as pmv
        on mv.ID_MOTIVO_VENDA = pmv.ID_MOTIVO_VENDA
    group by 
        pmv.ID_PEDIDO
)
select * from vendas_motivos