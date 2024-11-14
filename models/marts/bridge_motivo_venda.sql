with stg_pedido_motivo_venda as (
   select * from {{ ref('stg_sap__pedido_motivo_venda') }}
),
stg_motivo_venda as (
   select * from {{ ref('stg_sap__motivo_venda') }}
),
bridge_motivo_venda as (
   select
       {{ dbt_utils.generate_surrogate_key([
         'pmv.ID_PEDIDO',
         'mv.ID_MOTIVO_VENDA'
         ]) }} as SK_BRIDGE_MOTIVO
       , pmv.ID_PEDIDO
       , mv.ID_MOTIVO_VENDA
       , mv.NOME_MOTIVO
       , mv.TIPO_MOTIVO
   from stg_pedido_motivo_venda pmv
   left join stg_motivo_venda mv 
       using (ID_MOTIVO_VENDA)
)
select * from bridge_motivo_venda