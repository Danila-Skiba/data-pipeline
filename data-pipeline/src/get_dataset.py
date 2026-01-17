import pandas as pd
def get_dataset():
    return pd.read_csv('/data-pipeline/src/df.csv', sep=',')