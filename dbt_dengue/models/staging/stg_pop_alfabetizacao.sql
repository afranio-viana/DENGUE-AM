{{config(materialized="view")}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','alfabetizados_2022')}}
),

clean AS (
    SELECT
        "ESTADO" AS estado,
        "CODIGO"::text AS codigo_municipio,
        REGEXP_REPLACE(TRIM(LOWER("MUNICIPIO")),'\s+',' ','g') AS MUNICIPIO,
        CASE
            WHEN "ALFABETIZACAO" = 'Alfabetizadas' THEN 'ALFABETIZADOS'
            ELSE 'NAO_ALFABETIZADOS'
        END AS situacao,
        COALESCE("VALOR", 0) AS pop_alfabetizados,
        "ANO"::text AS ano
    FROM raw_table
)

SELECT
    *
FROM clean