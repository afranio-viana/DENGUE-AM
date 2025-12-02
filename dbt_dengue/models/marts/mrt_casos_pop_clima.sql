{{config(materialized = "view")}}

WITH casos_pop_clima AS (
    SELECT * FROM {{source('intermediate','int_casos_pop_clima')}}
)

SELECT
    *
FROM casos_pop_clima