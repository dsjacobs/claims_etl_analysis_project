import os
import pandas as pd
from functools import reduce

def find_csv(CSV_DIR):
     for root, dirs, files in os.walk(CSV_DIR):
        for file in files:
            if file.endswith(".csv"):
                return os.path.join(root, file)
            
def run_sql(conn, folder, file_list):
    for file in file_list:
        path = os.path.join(folder, file)
        with open(path, "r") as f:
            sql = f.read()
        conn.executescript(sql)

def prioritize(conn):
    df = pd.read_sql_query('SELECT * FROM nrml_pol_priority;', conn)

    fields = [
        'effective_date',
        'issue_date',
        'maturity_date',
        'origination_death_benefit',
        'carrier_name'
    ]

    best_fields = []
    for field in fields:
        best = (
            df[df[field].notnull()]
            .sort_values(['new_id', 'data_provider_priority'])
            .drop_duplicates(subset=['new_id'], keep='first')
            [['new_id', field, 'data_provider_code']]
            .rename(columns={
                field: field,
                'data_provider_code': f'{field}_source'
            })
            .set_index('new_id')
        )
        best_fields.append(best)

    prioritized = reduce(lambda left, right: left.join(right, how='outer'), best_fields)
    prioritized.reset_index(inplace=True)
    prioritized.to_sql('prioritized', conn, if_exists='replace', index=False)
