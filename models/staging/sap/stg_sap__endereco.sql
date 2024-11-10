with src_address as (
   select * from {{ source('sap', 'address') }}
),
addresses as (
   select
       -- chave primária
       addressid as ID_ENDERECO
       -- chaves estrangeiras
       , stateprovinceid as ID_ESTADO
       -- texto
       , addressline1 as ENDERECO_1
       , addressline2 as ENDERECO_2
       , city as CIDADE
       , postalcode as CEP
       , spatiallocation as LOCALIZACAO_ESPACIAL
       -- data e timestamp
       , strptime(modifieddate, '%Y-%m-%d %H:%M:%S.%f') as DATA_MODIFICACAO
       -- chave única
       , rowguid as ID_LINHA_UNICO
   from
       src_address
)
select * from addresses