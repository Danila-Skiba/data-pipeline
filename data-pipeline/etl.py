from src.load_data_to_db import load_data_to_db
import pandas as pd
from src.get_dataset import get_dataset
from src.fill_structurd_table import fill_structured_table



def etl():
    path = "/Users/danilaskiba/git_repository/data-pipeline/sql/dds/s_sql_dds/table/t_sql_source_unstructured.sql"
    data = get_dataset()
    load_data_to_db(data,path)
    fill_structured_table('2025-04-19', '2025-04-24')

def main():
    etl()

main()

