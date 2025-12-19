DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'etl_database',
    'user': 'postgres',
    'password': '111'
}

def get_connection_string():
    return f"postgresql://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"