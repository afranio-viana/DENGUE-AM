{{config(materialized="view")}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','existencia_canalizacao_2022')}}
),

clean AS (
    SELECT
        "ESTADO" AS estado,
        "CODIGO"::text AS codigo_municipio,
        REGEXP_REPLACE(TRIM(LOWER("MUNICIPIO")),'\s+',' ','g') AS municipio,
        COALESCE("VALOR",0)::int AS pop_canalizacao,
        "ANO" AS ano,
        CASE
            WHEN "EXISTENCIA_DE_CANALIZACAO_DE_AGUA" = 'Sem água canalizada' THEN 'NAO_CANALIZADA'
            ELSE 'CANALIZADA'
        END AS tipo_canalizacao
    FROM raw_table
),

sum_canalizacao AS (
    SELECT
        estado,
        codigo_municipio,
        municipio,
        ano,
        tipo_canalizacao,
        SUM(pop_canalizacao) AS pop_canalizacao
    FROM clean
    GROUP BY estado, codigo_municipio, municipio, ano, tipo_canalizacao
)

SELECT
    *
FROM sum_canalizacao