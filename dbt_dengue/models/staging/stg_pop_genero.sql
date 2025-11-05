{{config(materialized='view')}}

WITH raw_table AS(
    SELECT * FROM {{source('raw','genero_2022')}}
),

clean AS (
    SELECT
        "ESTADO" AS estado,
        "CODIGO"::text AS codigo_municipio,
        REGEXP_REPLACE(TRIM(LOWER("MUNICIPIO")),'\s+',' ','g') as municipio,
        CASE
            WHEN "SEXO" =  'Homens' THEN 'MASCULINO'
            ELSE 'FEMININO'
        END AS genero,
        COALESCE("VALOR",0)::int AS pop_genero,
        "ANO"::text AS ano
    FROM raw_table
)

SELECT
    *
FROM clean