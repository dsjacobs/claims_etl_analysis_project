# main.py
import pandas as pd
import sqlite3
import os
from utils.etl_utils import run_sql, prioritize, find_csv

SQL_FOLDER = 'sql'
CSV_DIR = 'data_input'
DB_PATH = 'sqlite/preston_takehome.db'

def run_etl():
# Load from CSV into SQLite
    df = pd.read_csv(find_csv(CSV_DIR))
    conn = sqlite3.connect(DB_PATH)
    df.to_sql('full_raw', conn, if_exists='replace', index=False)

    # Run ETL steps
    run_sql(conn, SQL_FOLDER, ['01-normalize-ddl.sql', '02-normalize.sql'])
    prioritize(conn)
    run_sql(conn, SQL_FOLDER, ['03-publish-ddl.sql', '04-publish.sql'])

    conn.close()

run_etl()
