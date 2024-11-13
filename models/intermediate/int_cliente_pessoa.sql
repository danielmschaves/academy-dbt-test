with stg_cliente as (
    select * from {{ ref('stg_sap__clientes') }}
),
stg_pessoa as (
    select * from {{ ref('stg_sap__pessoas') }}
),
cliente_pessoa as (
    select 
        c.ID_CLIENTE
        , c.ID_TERRITORIO
        , p.NOME
        , p.SOBRENOME
        , concat(p.NOME, ' ', p.SOBRENOME) as NOME_COMPLETO
    from stg_cliente c
    left join stg_pessoa p 
        on c.ID_PESSOA = p.ID_ENTIDADE
)
select * from cliente_pessoa