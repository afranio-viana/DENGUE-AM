{{config(materialized='view')}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','prectotcorr_2022')}}
),

unpivot AS (
    SELECT
        REGEXP_REPLACE(TRIM(LOWER("MUNICIPIO")),'\s+',' ','g') as municipio,
        key as mes,
        value as prec_media,
        t.*
    FROM (
        SELECT *, TO_JSONB(raw_table) AS jb
        FROM raw_table
    ) t
    CROSS JOIN LATERAL (
        SELECT * FROM JSONB_EACH_TEXT(t.jb - 'MUNICIPIO' - 'YEAR' - 'ANN' - 'PARAMETER')
    ) AS j(key,value)
),

clean AS (
    SELECT
        municipio,
        "ANN"::float AS precipitacao_media_anual,
        mes,
        CASE UPPER(mes)
            WHEN 'JAN' THEN "YEAR" || '01'
            WHEN 'FEB' THEN "YEAR" || '02'
            WHEN 'MAR' THEN "YEAR" || '03'
            WHEN 'APR' THEN "YEAR" || '04'
            WHEN 'MAY' THEN "YEAR" || '05'
            WHEN 'JUN' THEN "YEAR" || '06'
            WHEN 'JUL' THEN "YEAR" || '07'
            WHEN 'AUG' THEN "YEAR" || '08'
            WHEN 'SEP' THEN "YEAR" || '09'
            WHEN 'OCT' THEN "YEAR" || '10'
            WHEN 'NOV' THEN "YEAR" || '11'
            WHEN 'DEC' THEN "YEAR" || '12'
        END AS ano_mes,
        COALESCE(prec_media,'0.0')::float AS precipitacao_media_mensal,
        "YEAR"::text AS ano
    FROM unpivot
)

SELECT
    *
FROM clean
ORDER BY municipio, ano_mes ASC