import pandas as pd
import psycopg2 as ps


DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'postgres',
    'user': 'postgres',
    'password': '111'

}

def load_data_to_db(df:pd.DataFrame, table_name):
    conn = ps.connect(**DB_CONFIG)
    df.to_sql(
        name = table_name,
        con = conn,
        if_exists= 'replace',
        index=False
    )



