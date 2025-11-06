{{config(matreialized="view")}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','destino_lixo_2022')}}
),

clean AS (
    SELECT
        "ESTADO" AS estado,
        "CODIGO"::text AS codigo_municipio,
        REGEXP_REPLACE(TRIM(LOWER("MUNICIPIO")),'\s+',' ','g') AS municipio,
        "DESTINO_DO_LIXO" AS pop_destino_lixo,
        COALESCE("VALOR",0)::int AS pop_destino_lixo,
        "ANO"::text AS ano
    FROM raw_table
)

SELECT
    *
FROM clean