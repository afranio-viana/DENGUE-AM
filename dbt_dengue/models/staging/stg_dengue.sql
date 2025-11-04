{{config(materialized='view')}}

with raw_table as (
    SELECT * FROM {{source('raw','infodengue_am_2022')}}
),

unpivot as (
    SELECT
        TRIM(LOWER("MUNICIPIO")) as municipio_raw,
        key as ym,
        value as casos_text,
        t.*
    FROM (
        SELECT *, TO_JSONB(raw_table) as jb
        from raw_table
    ) t
    CROSS JOIN LATERAL(
        SELECT * FROM jsonb_each_text(t.jb - 'MUNICIPIO')
    ) as j(key, value)
),

clean as (
    SELECT
        REGEXP_REPLACE(municipio_raw,'\s+',' ','g') as municipio,
        (substring(ym from 1 for 4))::int as ano,
        (substring(ym from 5 for 2))::int as mes,
        ym as ano_mes,
        COALESCE(
            NULLIF(TRIM(COALESCE(casos_text,' ')), '')::int,
            0
        ) as casos_dengue
    FROM unpivot
)

SELECT
    municipio,
    ano,
    mes,
    ano_mes,
    casos_dengue
FROM clean
WHERE municipio IS NOT NULL