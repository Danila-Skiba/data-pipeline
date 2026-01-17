import psycopg2
from datetime import datetime
from src.config import get_connection_string

def fill_structured_table(start_date, end_date):
    if start_date is None:
        start_date = datetime.now()
    if end_date is None:
        end_date = datetime.now()
    
    try:
        with psycopg2.connect(get_connection_string()) as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    "SELECT s_psql_dds.fn_etl_data_load(%s, %s)",
                    (start_date, end_date)
                )
                conn.commit()
                print(f"ETL выполнен для периода {start_date} - {end_date}")
    
    except Exception as e:
        print(f"Ошибка: {e}")

def main():
    fill_structured_table('2025-04-19', '2025-04-24')
main()

