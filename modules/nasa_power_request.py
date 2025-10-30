import requests
import pandas as pd
from io import StringIO

def nasa_power_mensal(municipio_pd,inicio,fim):
    iterador = 0
    try:
        for _,municipio in municipio_pd.iterrows():
            response = requests.get(f'https://power.larc.nasa.gov/api/temporal/monthly/point?start={inicio}&end={fim}&latitude={municipio['LATITUDE']}&longitude={municipio['LONGITUDE']}&community=sb&parameters=T2M_MIN%2CT2M_MAX%2CPRECTOT&format=csv&units=metric&header=false')
            data = pd.read_csv(StringIO(response.text))
            data['MUNICIPIO'] = municipio["MUNICIPIO"]
            for parametro in data['PARAMETER']:
                data_param = data[data['PARAMETER']==parametro]
                if iterador==0:
                    data_param.to_csv(f'data/raw/nasa_power/{parametro}_{fim}.csv',mode='w',index=False)
                    print(f"Arquivo {parametro}_{fim}.csv Criado")
                else:
                    data_param.to_csv(f'data/raw/nasa_power/{parametro}_{fim}.csv',mode='a',index=False,header=None)
                    print(f"{municipio["MUNICIPIO"]} adicionado no arquivo {parametro}_{fim}.csv")
            
            iterador+=1     
            #print(f"\n{iterador}") 
        print("Arquivos criados")
    except requests.exceptions.RequestException as e:
        print(f"Ocorreu um erro: {e}")
