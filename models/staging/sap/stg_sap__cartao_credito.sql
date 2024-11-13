with src_cartao_credito as (
   select * from {{ source('sap', 'creditcard') }}
),
cartao_credito as (
   select
       -- chave primária
       creditcardid as ID_CARTAO
       -- textos
       , cardtype as TIPO_CARTAO
       -- valores
       , cardnumber as NUMERO_CARTAO
       , expmonth as MES_EXPIRACAO
       , expyear as ANO_EXPIRACAO
       -- data e timestamp
       , cast(modifieddate as timestamp) as DATA_MODIFICACAO
   from
       src_cartao_credito
)
select * from cartao_credito