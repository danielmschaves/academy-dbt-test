with int_pedido as (
    select distinct DATA_PEDIDO from {{ ref('stg_sap__pedido_venda') }}
),
dim_tempo as (
    select 
        -- chave surrogate
        {{ dbt_utils.generate_surrogate_key([
            't.DATA_PEDIDO'
        ]) }} as SK_DATA
        -- chaves naturais
        , t.DATA_PEDIDO
        -- atributos
        , extract(year from t.DATA_PEDIDO) as ANO
        , extract(month from t.DATA_PEDIDO) as MES
        , extract(day from t.DATA_PEDIDO) as DIA
        , case 
            when extract(month from t.DATA_PEDIDO) = 1 then 'Janeiro'
            when extract(month from t.DATA_PEDIDO) = 2 then 'Fevereiro'
            when extract(month from t.DATA_PEDIDO) = 3 then 'Março'
            when extract(month from t.DATA_PEDIDO) = 4 then 'Abril'
            when extract(month from t.DATA_PEDIDO) = 5 then 'Maio'
            when extract(month from t.DATA_PEDIDO) = 6 then 'Junho'
            when extract(month from t.DATA_PEDIDO) = 7 then 'Julho'
            when extract(month from t.DATA_PEDIDO) = 8 then 'Agosto'
            when extract(month from t.DATA_PEDIDO) = 9 then 'Setembro'
            when extract(month from t.DATA_PEDIDO) = 10 then 'Outubro'
            when extract(month from t.DATA_PEDIDO) = 11 then 'Novembro'
            when extract(month from t.DATA_PEDIDO) = 12 then 'Dezembro'
          end as NOME_MES
        , extract(quarter from t.DATA_PEDIDO) as TRIMESTRE
        -- metadados
        , current_timestamp() as DW_DATA_CARGA
    from int_pedido as t
)
select * from dim_tempo