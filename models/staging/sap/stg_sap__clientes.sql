with src_customer as (
   select * from {{ source('sap', 'customer') }}
),
customers as (
   select
       -- chave primária
       customerid as ID_CLIENTE
       -- chaves estrangeiras
       , personid as ID_PESSOA
       , storeid as ID_LOJA
       , territoryid as ID_TERRITORIO
       -- data e timestamp
       , cast(modifieddate as timestamp) as DATA_MODIFICACAO
       -- chave única
       , rowguid as ID_LINHA_UNICO
   from
       src_customer
)
select * from customers