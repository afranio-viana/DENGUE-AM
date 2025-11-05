{{config(materialized="view")}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','forma_abastecimento_2022')}}
),

clean as (
    SELECT
        "ESTADO" AS estado,
        "CODIGO"::text AS codigo_municipio,
        REGEXP_REPLACE(TRIM(LOWER("MUNICIPIO")),'\s+',' ','g') AS municipio,
        "PRINCIPAL_FORMA_DE_ABASTECIMENTO_DE_AGUA" AS forma_abastecimento_agua,
        COALESCE(NULLIF(TRIM("VALOR"),'-'),'0')::int AS pop_forma_abastecimento_agua,
        "ANO"::text AS ano
    FROM raw_table
),

group_abastecimento AS (
    SELECT "PRINCIPAL_FORMA_DE_ABASTECIMENTO_DE_AGUA",COUNT(*) AS qtd
    FROM raw_table
    GROUP BY "PRINCIPAL_FORMA_DE_ABASTECIMENTO_DE_AGUA"
)

SELECT
    *
FROM clean