from src.get_dataset import get_dataset
from src.load_data_to_db import load_data_to_db
import pandas as pd


def main():
    print('werkjg')
    dataset = get_dataset()
    load_data_to_db(dataset, 't_sql_source_unstructured')