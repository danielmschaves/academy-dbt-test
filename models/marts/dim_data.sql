WITH spine AS (
    {{
        dbt_utils.date_spine(
            datepart = 'day',
            start_date = "cast('2011-01-01' as date)",
            end_date = "cast('2015-01-01' as date)"
        )
    }}
),

dim_tempo AS (
    SELECT
        -- chave surrogate
        {{ dbt_utils.generate_surrogate_key(['date_day']) }} AS SK_DATA,
        -- chave natural
        date_day AS DATA_PEDIDO,
        -- atributos de ano/mês/dia
        EXTRACT(year FROM date_day) AS ANO,
        EXTRACT(quarter FROM date_day) AS TRIMESTRE,
        EXTRACT(month FROM date_day) AS MES,
        ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
         'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro']
            [ORDINAL(EXTRACT(month FROM date_day))] AS NOME_MES,
        EXTRACT(day FROM date_day) AS DIA,
        -- atributos de semana
        EXTRACT(dayofweek FROM date_day) AS DIA_SEMANA,
        ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado']
            [ORDINAL(EXTRACT(dayofweek FROM date_day))] AS NOME_DIA_SEMANA,
        EXTRACT(week FROM date_day) AS SEMANA_ANO,
        -- flags
        EXTRACT(dayofweek FROM date_day) IN (1, 7) AS IS_FIM_SEMANA,
        date_day = DATE_TRUNC(date_day, MONTH) AS IS_PRIMEIRO_DIA_MES,
        date_day = LAST_DAY(date_day, MONTH) AS IS_ULTIMO_DIA_MES,
        -- metadados
        CURRENT_TIMESTAMP() AS DW_DATA_CARGA
    FROM spine
)

SELECT * FROM dim_tempo
