{{config(materialized="view")}}

WITH casos_clima AS (
    SELECT * FROM {{source ('intermediate','int_casos_clima')}}
),

casos_pop AS (
    SELECT * FROM {{source ('intermediate','int_casos_pop')}}
),

join_casos_pop_clima AS (
    SELECT
        cac.municipio,
        cac.ano_mes,
        cac.casos_dengue,
        cap.pop_total,
        cap.densidade_demografica,
        cap.porc_alfabetizados,
        cap.porc_agua_encanada,
        cap.porc_agua_rede_geral,
        cap.porc_coleta_lixo,
        cap.porc_maculino,
        cap.porc_feminino,
        cap.porc_idosos,
        cap.rendimento_medio,
        cap.casos_dengue_por_10k,
        cac.precipitacao_media_mensal,
        cac.temperatura_media_minima_mensal,
        cac.temperatura_media_maxima_mensal,
        cac.variacao_temperatura,
        cac.lag_casos_1m,
        cac.lag_casos_2m,
        cac.lag_casos_3m,
        cac.media_movel_3m_casos,
        cac.chuva_acima_media
    FROM casos_clima cac
    LEFT JOIN casos_pop cap
    ON cac.municipio = cap.municipio AND cac.ano = cap.ano
)


SELECT
    *
FROM join_casos_pop_clima