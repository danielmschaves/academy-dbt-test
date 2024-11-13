with src_motivo_venda as (
   select * from {{ source('sap', 'salesreason') }}
),
motivo_venda as (
   select
       -- chave primária
       salesreasonid as ID_MOTIVO_VENDA
       -- textos
       , name as NOME_MOTIVO
       , reasontype as TIPO_MOTIVO
       -- data e timestamp
       , cast(modifieddate as timestamp) as DATA_MODIFICACAO
   from
       src_motivo_venda
)
select * from motivo_venda