import pandas as pd
import sidrapy

data = sidrapy.get_table(table_code='4709',territorial_level="6",ibge_territorial_code="all",variable='93') 

data.columns = data.iloc[0]
df = data.iloc[1:, [6,4,10]]
df["ESTADO"] = df["Município"].str.split(' - ',expand=True).iloc[:, -1]
df["MUNICIPIO"] = df["Município"].str.split(' - ',expand=True)[0]

filtro_estado = df["ESTADO"]=='AM'

df = df[filtro_estado]
df = df.iloc[:, [3,4,1,2]]
df = df.rename(columns={'Ano':'ANO','Valor':"VALOR"})

df.to_csv(f'data/raw/ibge/populacao_2022.csv')
print(df)
