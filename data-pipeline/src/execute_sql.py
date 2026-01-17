import psycopg2 as ps
from src.config import get_connection_string

def execute_script(path:str):
    with open(path, 'r') as f:
        sql_script = f.read()
    connect = ps.connect(get_connection_string())
    cursor = connect.cursor()
    try:
        cursor.execute(sql_script)
        connect.commit()
    except Exception as e:
        connect.rollback()
        print(f"ОШИБКА при выполнении скрипта {path}: {e}")
    finally:
        cursor.close()
        connect.close()

# def main():
#     print('wrjg')
#     execute_script("/Users/danilaskiba/git_repository/data-pipeline/sql/dds/s_sql_dds/function/fn_etl_data_load.sql")

# main()