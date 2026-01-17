from dotenv import load_dotenv
import os

load_dotenv(dotenv_path='/data-pipeline/src/passwords.env')

DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'etl_database',
    'user': 'postgres',
    'password': os.getenv('DB_PgSQL')
}

MYSQL_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'database': 'taxi_dwh',     
    'user': 'root',             
    'password': os.getenv('DB_MySQL')
}

def get_connection_string():
    return f"postgresql://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"

