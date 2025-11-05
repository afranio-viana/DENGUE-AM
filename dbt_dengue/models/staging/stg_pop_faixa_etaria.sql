{{config(materialized="view")}}

WITH raw_table1 AS (
    SELECT 
        "VALOR"::text AS valor_raw,
        "CODIGO"::text AS codigo,
        "ANO"::text AS ano_raw,
        "IDADE" AS idade,
        "ESTADO" AS estado,
        "MUNICIPIO" AS municipio_raw
    FROM {{source("raw","faixa_etaria1_2022")}}
),
raw_table2 AS (
    SELECT 
        "VALOR"::text AS valor_raw,
        "CODIGO"::text AS codigo,
        "ANO"::text AS ano_raw,
        "IDADE" AS idade,
        "ESTADO" AS estado,
        "MUNICIPIO" AS municipio_raw
    FROM {{source("raw","faixa_etaria2_2022")}}
),
raw_table3 AS (
    SELECT 
        "VALOR"::text AS valor_raw,
        "CODIGO"::text AS codigo,
        "ANO"::text AS ano_raw,
        "IDADE" AS idade,
        "ESTADO" AS estado,
        "MUNICIPIO" AS municipio_raw
    FROM {{source("raw","faixa_etaria3_2022")}}
),

union_table AS (
    SELECT * FROM raw_table1
    UNION ALL
    SELECT * FROM raw_table2
    UNION ALL
    SELECT * FROM raw_table3
),

clean AS (
    SELECT
        estado,
        codigo AS codigo_municipio,
        REGEXP_REPLACE(TRIM(LOWER(municipio_raw)),'\s+',' ','g') AS municipio,
        idade AS faixa_etaria,
        COALESCE(NULLIF(TRIM(valor_raw),'-'),'0')::int AS pop_faixa_etaria,
        ano_raw AS ano
    FROM union_table
    ORDER BY municipio, faixa_etaria ASC
)

SELECT
    *
FROM clean