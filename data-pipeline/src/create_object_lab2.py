
from src.config import get_connection_string
from datetime import datetime
from src.execute_sql import execute_script

PATH = '/data-pipeline/sql/dds/s_sql_dds'
PATH_TO_DIM = f'{PATH}/table/dim_tables'

def create_objects():

    try:
        #Создание таблиц dim_*.sql
        execute_script(f'{PATH_TO_DIM}/dim_location.sql')
        execute_script(f'{PATH_TO_DIM}/dim_payment.sql')
        execute_script(f'{PATH_TO_DIM}/dim_ratecode.sql')
        execute_script(f'{PATH_TO_DIM}/dim_vendor.sql')

        #Создание таблицы t_dm_task
        execute_script(f'{PATH}/table/t_dm_task.sql')

        #Создание функции 
        execute_script(f'{PATH}/function/fn_dm_data_load.sql')

        #Создание представления 
        execute_script(f'{PATH}/view/v_dm_task.sql')

    except Exception as e:
        print(f"Ошибка: {e}")