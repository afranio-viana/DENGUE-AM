{{config(materialized = "view") }}

WITH casos_dengue AS (
    SELECT * FROM {{source('staging','stg_dengue')}}
),

pop_total AS (
    SELECT * FROM {{source('staging','stg_pop_total')}}
),

pop_densidade_demografica AS (
    SELECT * FROM {{source('staging','stg_pop_densidade_demografica')}}
),

pop_alfabetizados AS (
    SELECT * FROM {{source('staging','stg_pop_alfabetizacao')}}
),

pop_encanamento AS (
    SELECT * FROM {{source('staging','stg_pop_canalizacao')}}
),

pop_abastecimento AS (
    SELECT * FROM {{source('staging','stg_pop_abastecimento')}}
),

pop_coleta_lixo AS (
    SELECT * FROM {{source('staging','stg_pop_destino_lixo')}}
),

pop_genero AS (
    SELECT * FROM {{source('staging','stg_pop_genero')}}
),

pop_faixa_etaria AS (
    SELECT * FROM {{source('staging','stg_pop_faixa_etaria')}}
),

pop_rendimento AS (
    SELECT * FROM {{source('staging','stg_pop_rendimento')}}
),

casos_dengue_ano AS (
    SELECT
        municipio,
        ano,
        SUM(casos_dengue) AS casos_dengue_total_ano
    FROM casos_dengue
    GROUP BY ano, municipio
    ORDER BY casos_dengue_total_ano DESC
),

alfabetizados AS (
    SELECT
        codigo_municipio,
        municipio,
        pop_alfabetizados::float,
        ano
    FROM pop_alfabetizados
    WHERE situacao = 'ALFABETIZADOS'

),

agua_encanada AS (
    SELECT
        codigo_municipio,
        municipio,
        pop_canalizacao,
        pop_canalizacao_total,
        (pop_canalizacao/pop_canalizacao_total)::float AS porc_agua_encanada,
        ano::text
    FROM pop_encanamento
    WHERE tipo_canalizacao = 'CANALIZADA'
),

forma_abastecimento AS (
    SELECT
        codigo_municipio,
        municipio,
        pop_forma_abastecimento_agua,
        pop_forma_abastecimento_agua_total,
        (pop_forma_abastecimento_agua/pop_forma_abastecimento_agua_total)::float AS porc_agua_rede_geral,
        ano
    FROM pop_abastecimento
    WHERE forma_abastecimento_agua = 'REDE_GERAL'
),

coleta_lixo AS (
    SELECT
        codigo_municipio,
        municipio,
        destino_lixo,
        pop_destino_lixo,
        pop_destino_lixo_total,
        (pop_destino_lixo/pop_destino_lixo_total)::float AS porc_coleta_lixo,
        ano
    FROM pop_coleta_lixo
    WHERE destino_lixo = 'COLETADO'
),

faixa_etaria AS (
    SELECT
        codigo_municipio,
        municipio,
        faixa_etaria,
        pop_faixa_etaria,
        pop_faixa_etaria_total,
        (pop_faixa_etaria::float/pop_faixa_etaria_total)::float AS porc_idosos,
        ano
    FROM pop_faixa_etaria
    WHERE faixa_etaria = 'MAIOR_IGUAL_60'
),

rendimento_medio AS (
    SELECT
        codigo_municipio,
        municipio,
        avg(pop_redimento_medio)::float AS rendimento_medio,
        ano
    FROM pop_rendimento
    GROUP BY codigo_municipio,municipio,ano
),

join_pop AS (
    SELECT
        pt.codigo_municipio,
        pt.estado,
        c.municipio,
        c.ano,
        c.casos_dengue_total_ano,
        pt.pop_total,
        pdd.pop_densidade_demografica AS densidade_demografica,
        (alf.pop_alfabetizados/pt.pop_total)::float AS porc_alfabetizados,
        ae.porc_agua_encanada,
        fa.porc_agua_rede_geral,
        cl.porc_coleta_lixo,
        (pgm.pop_genero::float/pt.pop_total)::float AS porc_maculino,
        (pgf.pop_genero::float/pt.pop_total)::float AS porc_feminino,
        fe.porc_idosos,
        rm.rendimento_medio,
        ((c.casos_dengue_total_ano::float/pt.pop_total::float)*10000)::float AS casos_dengue_por_10k
    FROM casos_dengue_ano c
    LEFT JOIN pop_total pt
    ON pt.municipio = c.municipio AND pt.ano = pt.ano
    LEFT JOIN pop_densidade_demografica pdd
    ON pdd.municipio = pt.municipio AND pdd.codigo = pt.codigo_municipio AND pdd.ano = pt.ano
    LEFT JOIN alfabetizados alf
    ON alf.municipio = pt.municipio AND alf.codigo_municipio = pt.codigo_municipio AND alf.ano = pt.ano
    LEFT JOIN agua_encanada ae
    ON ae.municipio = pt.municipio AND ae.codigo_municipio = pt.codigo_municipio AND ae.ano = pt.ano
    LEFT JOIN forma_abastecimento fa
    ON fa.municipio = pt.municipio AND fa.codigo_municipio = pt.codigo_municipio AND fa.ano = pt.ano
    LEFT JOIN coleta_lixo cl
    ON cl.municipio = pt.municipio AND cl.codigo_municipio = pt.codigo_municipio AND cl.ano = pt.ano
    LEFT JOIN pop_genero pgm
    ON pgm.municipio = pt.municipio AND pgm.codigo_municipio = pt.codigo_municipio AND pgm.genero = 'MASCULINO' AND pgm.ano = pt.ano
    LEFT JOIN pop_genero pgf
    ON pgf.municipio = pt.municipio AND pgf.codigo_municipio = pt.codigo_municipio AND pgf.genero = 'FEMININO' AND pgf.ano = pt.ano
    LEFT JOIN faixa_etaria fe
    ON fe.municipio = pt.municipio AND fe.codigo_municipio = pt.codigo_municipio
    LEFT JOIN rendimento_medio rm
    ON rm.municipio = pt.municipio AND rm.codigo_municipio = pt.codigo_municipio
)

SELECT
    *
FROM join_pop
