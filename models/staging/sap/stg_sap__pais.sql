with src_countryregion as (
   select * from {{ source('sap', 'countryregion') }}
),
countryregion as (
   select
       -- chave primária
       countryregioncode as ID_PAIS
       -- textos
       , name as NOME_PAIS
       -- data e timestamp
       , cast(modifieddate as timestamp) as DATA_MODIFICACAO
   from
       src_countryregion
)
select * from countryregion