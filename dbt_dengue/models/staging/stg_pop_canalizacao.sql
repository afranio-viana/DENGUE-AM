{{config(materialized="view")}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','existencia_canalizacao_2022')}}
),

clean AS (
    SELECT
        "ESTADO" AS estado,
        "CODIGO"::text AS codigo_municipio,
        REGEXP_REPLACE(TRIM(LOWER("MUNICIPIO")),'\s+',' ','g') AS municipio,
        "EXISTENCIA_DE_CANALIZACAO_DE_AGUA" AS tipo_canalizacao,
        COALESCE("VALOR",0)::int AS pop_canalizacao,
        "ANO" AS ano
    FROM raw_table
)

SELECT
    *
FROM clean