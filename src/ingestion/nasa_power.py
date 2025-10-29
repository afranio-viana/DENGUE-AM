import pandas as pd
from modules.nasa_power_request import nasa_power_mensal

municipio_pd = pd.read_csv('data/raw/geobr/territorio_municipios_am.csv')
nasa_power_mensal(municipio_pd,'2022','2022')