import pandas as pd
from modules.infodengue_request import infodengue_casos_dengue


ano = '2022'

municipio_pd = pd.read_csv('data/raw/geobr/territorio_municipios_am.csv',)

infodengue_casos_dengue(municipio_pd,ano)