from src.load_data_to_db import load_data_to_db
import pandas as pd
from src.execute_sql import execute_script
from src.get_dataset import get_dataset



def main():
    path = "/Users/danilaskiba/git_repository/data-pipeline/sql/dds/s_sql_dds/table/t_sql_source_unstructured.sql"
    data = get_dataset()
    load_data_to_db(data,path)

    path = "/Users/danilaskiba/git_repository/data-pipeline/sql/dds/s_sql_dds/table/t_sql_source_structured.sql"
    execute_script(path)

    create_function_path = "/Users/danilaskiba/git_repository/data-pipeline/sql/dds/s_sql_dds/function/fn_etl_data_load.sql"
    execute_script(create_function_path)

    
