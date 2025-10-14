import pandas as pd
import sidrapy

def sidrapy_populacao(nome,tabela,nivel_territorial,codigo_ibge,variavel,uf):
    data = sidrapy.get_table(table_code=tabela,territorial_level=nivel_territorial,ibge_territorial_code=codigo_ibge,variable=variavel) 

    data.columns = data.iloc[0]
    df = data.iloc[1:, [5,6,4,10]]
    df["ESTADO"] = df["Município"].str.split(' - ',expand=True).iloc[:, -1]
    df["MUNICIPIO"] = df["Município"].str.split(' - ',expand=True)[0]

    filtro_estado = df["ESTADO"]==uf

    df = df[filtro_estado]
    df = df.iloc[:, [4,0,5,2,3]]
    df = df.rename(columns={'Ano':'ANO','Valor':'VALOR','Município (Código)':'CODIGO'})

    df.to_csv(f'data/raw/ibge/{nome}.csv')