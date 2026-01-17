import psycopg2 as ps
from config import get_connection_string
from datetime import datetime

def fill_dm_table(start_date, end_date):
    if start_date is None:
        start_date = datetime.now()
    if end_date is None:
        end_date = datetime.now()
    try:
        connect = ps.connect(get_connection_string())
        cursor = connect.cursor()

        sql_query = 'select s_psql_dds.fn_dm_data_load(%s, %s)'
        cursor.execute(sql_query, (start_date, end_date))

        connect.commit()

        print('Витрина загружена')

    except Exception as e:
        print(f"Ошибка: {e}")
        
def main():
    fill_dm_table('2025-04-21', '2025-04-23')

main()
