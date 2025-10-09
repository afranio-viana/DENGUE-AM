from pysus.online_data.Infodengue import search_string, download
from modules.strings import normalizar_strings

municipios_am = [
    "Alvarães",
    "Amaturá",
    "Anamã",
    "Anori",
    "Apuí",
    "Atalaia do Norte",
    "Autazes",
    "Barcelos",
    "Barreirinha",
    "Benjamin Constant",
    "Beruri",
    "Boa Vista do Ramos",
    "Boca do Acre",
    "Borba",
    "Caapiranga",
    "Canutama",
    "Carauari",
    "Careiro",
    "Careiro da Várzea",
    "Coari",
    "Codajás",
    "Eirunepé",
    "Envira",
    "Fonte Boa",
    "Guajará",
    "Humaitá",
    "Ipixuna",
    "Iranduba",
    "Itacoatiara",
    "Itamarati",
    "Itapiranga",
    "Japurá",
    "Juruá",
    "Jutaí",
    "Lábrea",
    "Manacapuru",
    "Manaquiri",
    "Manaus",
    "Manicoré",
    "Maraã",
    "Maués",
    "Nhamundá",
    "Nova Olinda do Norte",
    "Novo Airão",
    "Novo Aripuanã",
    "Parintins",
    "Pauini",
    "Presidente Figueiredo",
    "Rio Preto da Eva",
    "Santa Isabel do Rio Negro",
    "Santo Antônio do Içá",
    "São Gabriel da Cachoeira",
    "São Paulo de Olivença",
    "São Sebastião do Uatumã",
    "Silves",
    "Tabatinga",
    "Tapauá",
    "Tefé",
    "Tonantins",
    "Uarini",
    "Urucará",
    "Urucurituba"
]


ano = '2024'

for municipio in municipios_am:
    df = download('dengue', int(f'{ano}01'), int(f'{ano}12'), municipio)
    municipio_sem_acento = normalizar_strings(municipio)
    #print(municipio_sem_acento)
    df.to_csv(f'data/raw/infodengue/{municipio_sem_acento}_{ano}.csv')