import pandas as pd
import sidrapy
from modules.strings import normalizar_strings

def sidrapy_populacao(nome,tabela,nivel_territorial,variavel,codigo_ibge,uf,colunas,classificacao):
    data = sidrapy.get_table(table_code=tabela,territorial_level=nivel_territorial,variable=variavel,ibge_territorial_code=codigo_ibge,classifications=classificacao) 

    data.columns = data.iloc[0]
    df = data.iloc[1:, colunas]
    df["ESTADO"] = df["Município"].str.split(' - ',expand=True).iloc[:, -1]
    df["MUNICIPIO"] = df["Município"].str.split(' - ',expand=True)[0]
    df= df.drop('Município', axis=1)
    filtro_estado = df["ESTADO"]==uf

    df = df[filtro_estado]
    df = df.rename(columns={'Município (Código)':'CODIGO'})
    for nomes in df.columns:
        df = df.rename(columns={nomes:normalizar_strings(nomes).upper()})

    df.to_csv(f'data/raw/ibge/{nome}.csv',index=False)
    print(f"\nArquivo {nome}.csv criado")