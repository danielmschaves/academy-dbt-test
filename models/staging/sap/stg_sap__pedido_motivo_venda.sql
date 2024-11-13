with src_pedido_motivo_venda as (
   select * from {{ source('sap', 'salesorderheadersalesreason') }}
),
pedido_motivo_venda as (
   select
       -- chaves primárias compostas
       salesorderid as ID_PEDIDO
       , salesreasonid as ID_MOTIVO_VENDA
       -- data e timestamp
       , cast(modifieddate as timestamp) as DATA_MODIFICACAO
   from
       src_pedido_motivo_venda
)
select * from pedido_motivo_venda