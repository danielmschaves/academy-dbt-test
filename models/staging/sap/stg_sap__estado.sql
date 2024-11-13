with src_estado as (
   select * from {{ source('sap', 'stateprovince') }}
),
estado as (
   select
       -- chave primária
       stateprovinceid as ID_ESTADO
       -- chaves estrangeiras
       , territoryid as ID_TERRITORIO
       , countryregioncode as ID_PAIS
       -- textos
       , stateprovincecode as CODIGO_ESTADO
       , name as NOME_ESTADO
       -- booleano
       , isonlystateprovinceflag as FLAG_APENAS_ESTADO
       -- data e timestamp
       , cast(modifieddate as timestamp) as DATA_MODIFICACAO
       -- chave única
       , rowguid as ID_LINHA_UNICO
   from
       src_estado
)
select * from estado