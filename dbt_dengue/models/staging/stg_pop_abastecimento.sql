{{config(materialized="view")}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','forma_abastecimento_2022')}}
),

clean as (
    SELECT
        "ESTADO" AS estado,
        "CODIGO"::text AS codigo_municipio,
        REGEXP_REPLACE(TRIM(LOWER("MUNICIPIO")),'\s+',' ','g') AS municipio,
        CASE
            WHEN "PRINCIPAL_FORMA_DE_ABASTECIMENTO_DE_AGUA" = 'Rede geral de distribuição' THEN 'REDE_GERAL'
            ELSE 'OUTROS'
        END AS forma_abastecimento_agua,
        COALESCE(NULLIF(TRIM("VALOR"),'-'),'0')::int AS pop_forma_abastecimento_agua,
        "ANO"::text AS ano
    FROM raw_table
),

sum_abastecimento AS (
    SELECT
        estado,
        codigo_municipio,
        municipio,
        forma_abastecimento_agua,
        SUM(pop_forma_abastecimento_agua)::float AS pop_forma_abastecimento_agua,
        ano
    FROM clean
    GROUP BY estado,codigo_municipio,municipio,forma_abastecimento_agua,ano
),

sum_abastecimento_total AS (
    SELECT
        estado,
        codigo_municipio,
        municipio,
        SUM(pop_forma_abastecimento_agua)::float AS pop_forma_abastecimento_agua_total,
        ano
    FROM clean
    GROUP BY estado,codigo_municipio,municipio,ano
),

join_abastecimento AS (
    SELECT
        sa.estado,
        sa.codigo_municipio,
        sa.municipio,
        sa.forma_abastecimento_agua,
        sa.pop_forma_abastecimento_agua,
        sat.pop_forma_abastecimento_agua_total,
        sa.ano
    FROM sum_abastecimento sa
    LEFT JOIN sum_abastecimento_total sat
    ON sa.codigo_municipio = sat.codigo_municipio AND sa.ano = sat.ano
)

SELECT
    *
FROM join_abastecimento