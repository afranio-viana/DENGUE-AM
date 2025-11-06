{{config(materialized='view')}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','densidade_demografica_2022')}}
),

clean AS (
    SELECT
        "ESTADO" as estado,
        "CODIGO"::text AS codigo,
        REGEXP_REPLACE(TRIM(LOWER("MUNICIPIO")),'\s+',' ','g') AS municipio,
        COALESCE("VALOR",'0.0')::float AS pop_densidade_demografica,
        "ANO"::text AS ano
    FROM raw_table
)

SELECT
    *
FROM clean