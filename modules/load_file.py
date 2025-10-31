import pandas as pd

def load_csv_postgres(file_path,name_table,engine,schema):
    try:
        csv_df = pd.read_csv(file_path)
        csv_df.to_sql(name_table,engine,schema=schema,if_exists="replace",index=False)
        print(f"\nA tabela {name_table} foi criada e {len(csv_df)} linhas foram inseridas")
    except Exception as e:
        print(f"Erro: {e}")
