{{config(materialized='view')}}

WITH raw_table1 AS (
    SELECT * FROM {{source('raw','rendimento_medio1_2022')}}
),

raw_table2 AS (
    SELECT * FROM {{source('raw','rendimento_medio2_2022')}}
),

raw_table3 AS (
    SELECT * FROM {{source('raw','rendimento_medio3_2022')}}
),

union_raw_table AS (
    SELECT * FROM raw_table1
    UNION ALL
    SELECT * FROM raw_table2
    UNION ALL
    SELECT * FROM raw_table3
),

clean AS (
    SELECT
        "ESTADO" AS estado,
        "CODIGO"::text AS codigo_municipio,
        REGEXP_REPLACE(TRIM(LOWER("MUNICIPIO")),'\s+',' ','g') AS municipio,
        "POSICAO_NA_OCUPACAO_E_CATEGORIA_DO_EMPREGO_NO_TRABALHO_PRINCIPA" AS ocupacao,
        COALESCE(NULLIF(TRIM("VALOR"),'-'),'0.0')::float AS pop_redimento_medio,
        "ANO"::text AS ano
    FROM union_raw_table
    ORDER BY "MUNICIPIO","POSICAO_NA_OCUPACAO_E_CATEGORIA_DO_EMPREGO_NO_TRABALHO_PRINCIPA" ASC
)

SELECT
    *
FROM clean