import pandas as pd
import psycopg2 as ps
from src.config import get_connection_string

def load_data_to_db(data:pd.DataFrame, path: str, table_name: str  = 't_sql_source_unstructured'):
    if('Unnamed: 0' in data.columns):
        data = data.drop(columns=['Unnamed: 0'])

    with open(path, 'r') as f:
        sql_script = f.read()
    
    connect = ps.connect(get_connection_string())
    cursor = connect.cursor()

    cursor.execute(sql_script)

    cursor.execute(f"TRUNCATE TABLE s_psql_dds.{table_name}")

    for _, row in data.iterrows():
        values = [str(val) if pd.notna(val) else None for val in row]
        placeholders = ', '.join(['%s'] * len(values))

        query = "INSERT INTO s_psql_dds.t_sql_source_unstructured VALUES (" + placeholders + ")"

        cursor.execute(query, values)
    
    connect.commit()
    connect.close()


