with src_pessoa as (
   select * from {{ source('sap', 'person') }}
),
pessoa as (
   select
       -- chave primária
       businessentityid as ID_ENTIDADE
       -- textos
       , persontype as TIPO_PESSOA
       , title as TITULO
       , firstname as NOME
       , middlename as NOME_MEIO
       , lastname as SOBRENOME
       , suffix as SUFIXO
       -- valores
       , emailpromotion as PROMOCAO_EMAIL
       -- booleano
       , namestyle as ESTILO_NOME
       -- data e timestamp
       , cast(modifieddate as timestamp) as DATA_MODIFICACAO
       -- chave única
       , rowguid as ID_LINHA_UNICO
   from
       src_pessoa
)
select * from pessoa