{{config(materialized='view')}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','populacao_2022')}}
),

clean AS (
    SELECT
        raw_table."ESTADO" AS estado,
        (raw_table."CODIGO")::text AS CODIGO_MUNICIPIO,
        REGEXP_REPLACE(TRIM(LOWER("MUNICIPIO")),'\s+',' ','g') as municipio,
        COALESCE("VALOR",0) AS pop_total,
        (raw_table."ANO")::text AS ano
    FROM raw_table
)

SELECT
    *
FROM clean

