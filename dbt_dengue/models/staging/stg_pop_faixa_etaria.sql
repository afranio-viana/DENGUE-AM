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
        COALESCE(NULLIF(TRIM(valor_raw),'-'),'0')::int AS pop_faixa_etaria,
        ano_raw AS ano,
        CASE
            WHEN split_part(idade, ' ',1)::float >=60 THEN 'MAIOR_IGUAL_60'
            ELSE 'MENOR_60'
        END AS faixa_etaria
    FROM union_table
    ORDER BY municipio, faixa_etaria ASC
),

sum_faixa_etaria AS (
    SELECT 
        estado,
        codigo_municipio,
        municipio,
        faixa_etaria,
        SUM(pop_faixa_etaria) AS pop_faixa_etaria,
        ano
    FROM clean
    GROUP BY estado,codigo_municipio,municipio,faixa_etaria,ano
),

sum_faixa_etaria_total AS (
    SELECT 
        estado,
        codigo_municipio,
        municipio,
        SUM(pop_faixa_etaria) AS pop_faixa_etaria_total,
        ano
    FROM clean
    GROUP BY estado,codigo_municipio,municipio,ano
),

join_faixa_etaria AS (
    SELECT
        sfe.estado,
        sfe.codigo_municipio,
        sfe.municipio,
        sfe.faixa_etaria,
        sfe.pop_faixa_etaria,
        sfet.pop_faixa_etaria_total,
        sfe.ano
    FROM sum_faixa_etaria sfe
    LEFT JOIN sum_faixa_etaria_total sfet
    ON sfe.municipio = sfet.municipio AND sfe.codigo_municipio = sfet.codigo_municipio AND sfe.ano = sfet.ano

)


SELECT
    *
FROM join_faixa_etaria