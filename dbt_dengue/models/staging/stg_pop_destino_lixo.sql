{{config(matreialized="view")}}

WITH raw_table AS (
    SELECT * FROM {{source('raw','destino_lixo_2022')}}
),

clean AS (
    SELECT
        "ESTADO" AS estado,
        "CODIGO"::text AS codigo_municipio,
        REGEXP_REPLACE(TRIM(LOWER("MUNICIPIO")),'\s+',' ','g') AS municipio,
        CASE
            WHEN "DESTINO_DO_LIXO" LIKE '%Coletado%' THEN 'COLETADO'
            ELSE 'NAO_COLETADO'
        END AS destino_lixo,
        COALESCE("VALOR",0)::int AS pop_destino_lixo,
        "ANO"::text AS ano
    FROM raw_table
),

sum_destino_lixo AS (
    SELECT
        estado,
        codigo_municipio,
        municipio,
        ano,
        destino_lixo,
        SUM(pop_destino_lixo)::float AS pop_destino_lixo
    FROM clean
    GROUP BY estado,codigo_municipio,municipio,ano,destino_lixo
),

sum_destino_lixo_total AS (
    SELECT
        estado,
        codigo_municipio,
        municipio,
        ano,
        SUM(pop_destino_lixo)::float AS pop_destino_lixo_total
    FROM clean
    GROUP BY estado,codigo_municipio,municipio,ano
),

join_destino_lixo AS (
    SELECT
        sdl.estado,
        sdl.codigo_municipio,
        sdl.municipio,
        sdl.destino_lixo,
        sdl.pop_destino_lixo,
        sdlt.pop_destino_lixo_total,
        sdl.ano
    FROM sum_destino_lixo sdl
    LEFT join sum_destino_lixo_total sdlt
    ON sdl.codigo_municipio = sdlt.codigo_municipio
)

SELECT
    *
FROM join_destino_lixo