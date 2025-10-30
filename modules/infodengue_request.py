import pandas as pd
from pysus.online_data.Infodengue import search_string, download
from modules.strings import normalizar_strings


def infodengue_casos_dengue(municipio_pd,ano):
    iterador =0
    try:
        for _,municipio in municipio_pd.iterrows():
            df = download('dengue', int(f'{ano}01'), int(f'{ano}12'), municipio['MUNICIPIO'])
            primeira_coluna_nome = df.columns[0]
            df = df.iloc[[4]]
            df['MUNICIPIO'] = municipio['MUNICIPIO']
            if iterador==0:
                df.to_csv(f'data/raw/infodengue/infodengue_AM_{ano}.csv',mode='w',index=False)
                print(f"Arquivo infodengue_AM_{ano}.csv Criado")
            else:
                df.to_csv(f'data/raw/infodengue/infodengue_AM_{ano}.csv',mode='a',index=False,header=None)
                print(f"{municipio["MUNICIPIO"]} adicionado no arquivo infodengue_AM_{ano}.csv")
            iterador+=1
    except Exception as e:
        print(f"Ocorreu um erro {e}")