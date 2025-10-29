import geobr
import geopandas as gpd
import pandas as pd

municipios_br = geobr.read_municipality(year=2022)

municipios_am = municipios_br[municipios_br['code_state'] == 13].copy()

municipios_am['centroid'] = municipios_am.geometry.centroid
municipios_am['latitude'] = municipios_am.centroid.y
municipios_am['longitude'] = municipios_am.centroid.x

municipios_am_coordenadas = municipios_am[['name_muni','code_muni','latitude','longitude']].rename(
    columns={'name_muni':'MUNICIPIO','code_muni':'COD_IBGE','latitude':'LATITUDE','longitude':'LONGITUDE'})

municipios_am_coordenadas.to_csv(f'data/raw/geobr/territorio_municipios_am.csv', index=False)
