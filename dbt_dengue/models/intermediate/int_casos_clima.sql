{{config(materialized = "view")}}

WITH casos_dengue AS (
    SELECT * FROM {{source('staging','stg_dengue')}}
),

precipitacao AS (
    SELECT * FROM {{source('staging','stg_precipitacao_media')}}
),

temp_max AS (
    SELECT * FROM {{source('staging','stg_temperatura_maxima_media')}}
),

temp_min AS (
    SELECT * FROM {{source('staging','stg_temperatura_minima_media')}}
),

join_base AS (
    SELECT
        c.municipio,
        c.ano,
        c.mes,
        c.ano_mes,
        c.casos_dengue,
        p.precipitacao_media_mensal,
        tmax.temperatura_media_maxima_mensal,
        tmin.temperatura_media_minima_mensal,
        (tmax.temperatura_media_maxima_mensal - tmin.temperatura_media_minima_mensal) AS variacao_temperatura
    FROM casos_dengue c
        LEFT join precipitacao p
            ON c.municipio = p.municipio AND c.ano_mes = p.ano_mes
        LEFT JOIN temp_max tmax
            ON c.municipio = tmax.municipio AND c.ano_mes = tmax.ano_mes
        LEFT JOIN temp_min tmin
            ON c.municipio = tmin.municipio AND c.ano_mes = tmin.ano_mes
),

lagged_base AS (
    SELECT
        municipio,
        ano_mes,
        casos_dengue,
        precipitacao_media_mensal,
        temperatura_media_maxima_mensal,
        temperatura_media_minima_mensal,
        variacao_temperatura,
        ano,
        COALESCE(LAG(casos_dengue,1) OVER (PARTITION BY municipio ORDER BY ano_mes),0)::int AS lag_casos_1m,
        COALESCE(LAG(casos_dengue,2) OVER (PARTITION BY municipio ORDER BY ano_mes),0)::int AS lag_casos_2m,
        COALESCE(LAG(casos_dengue,3) OVER (PARTITION BY municipio ORDER BY ano_mes),0)::int AS lag_casos_3m,
        AVG(casos_dengue) OVER(
            PARTITION BY municipio
            ORDER BY ano_mes
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        )::float AS media_movel_3m_casos
    FROM join_base
),

chuva_media AS (
    SELECT
        municipio,
        AVG(precipitacao_media_mensal) AS precipitacao_media_anual
    FROM join_base
    GROUP BY municipio
),

join_lagged_chuva_media AS (
    SELECT
        l.*,
        cm.precipitacao_media_anual,
        CASE
            WHEN l.precipitacao_media_mensal > cm.precipitacao_media_anual THEN 1
            ELSE 0
        END AS chuva_acima_media
    FROM lagged_base l
    LEFT JOIN chuva_media cm
        ON cm.municipio = l.municipio
)

SELECT
    *
FROM join_lagged_chuva_media