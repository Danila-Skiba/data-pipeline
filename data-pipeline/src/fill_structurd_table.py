import psycopg2
from datetime import datetime
from config import get_connection_string

def fill_structured_table(start_date: datetime = None, end_date: datetime = None):
    if start_date is None:
        start_date = datetime.now()
    if end_date is None:
        end_date = datetime.now()
    
    try:
        with psycopg2.connect(get_connection_string()) as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    "SELECT fn_etl_data_load(%s, %s)",
                    (start_date.date(), end_date.date())
                )
                conn.commit()
                print(f"ETL выполнен для периода {start_date.date()} - {end_date.date()}")
    
    except Exception as e:
        print(f"Ошибка: {e}")

