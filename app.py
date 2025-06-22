from flask import Flask, render_template, jsonify, request, g
import sqlite3
from etl import run_etl

def initialize_data():
        run_etl()
        print("Initializing data...")

app = Flask(__name__)

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)

def get_db_connection():
    conn = sqlite3.connect('sqlite/preston_takehome.db')
    conn.row_factory = sqlite3.Row
    return conn

@app.route("/")
def index():
    conn = get_db_connection()
    tbl_list = conn.execute("SELECT name FROM sqlite_master WHERE type='table';").fetchall()
    conn.close()
    table_names = [row["name"] for row in tbl_list]
    return jsonify(table_names)

@app.route("/policy-info")
# given a policy number, return the eƯective_date, issue_date, maturity_date, death_benefit, and carrier_name to the best of our knowledge
def policy_info():
     policy_number = request.args.get("policy_number")

     if not policy_number:
        return jsonify({"error": "Missing policy id"}), 400
     
     conn = get_db_connection()
     policies = conn.execute(
            f"""SELECT effective_date,
                    issue_date,
                    maturity_date, 
                    death_benefit,
                    carrier_name
                FROM policy 
                INNER JOIN id_map ON policy.new_id = id_map.new_id
                WHERE id_map.orig_id = ?""",
            (policy_number,)
            ).fetchall()
     conn.close()
     policies_list = [dict(row) for row in policies]
     return jsonify(policies_list)

@app.route("/carrier-policy-count")
#given a carrier name, return the count of all unique policies we have from that carrier in our database
def carrier_policy_count():
    carrier_name = request.args.get("carrier_name")

    if not carrier_name:
        return jsonify({"error": "Missing carrier name"}), 400
     
    conn = get_db_connection()
    carrier_count = conn.execute(
            f"""SELECT COUNT(DISTINCT new_id)
                FROM policy
                WHERE carrier_name = ?""",
            (carrier_name,)
            ).fetchone()
    conn.close()
    count = list(carrier_count)[0]  # or result[0]
    return jsonify(count)

@app.route("/person-policies")
#given a person's name, return a list of all policies for that person regardless of the position (primary or secondary) of the person on the policy
def person_policy_count():
    person_name = request.args.get("person_name")

    if not person_name:
        return jsonify({"error": "Missing person name"}), 400
     
    conn = get_db_connection()
    carrier_count = conn.execute(
            f"""SELECT *
                FROM policy
                WHERE person_name = ?""",
            (person_name,)
            ).fetchone()
    conn.close()
    count = list(carrier_count)[0]  # or result[0]
    return jsonify(count)


@app.route("/data-provider-policies")
#given a data provider code, return the count of all policies that we have information on from that data provider
def data_provider_policy_count():
    data_provider_code = request.args.get("data_provider_code")

    if not data_provider_code:
        return jsonify({"error": "Missing data provider name"}), 400
     
    conn = get_db_connection()
    carrier_count = conn.execute(
            f"""SELECT COUNT(DISTINCT new_id)
                FROM policy
                WHERE data_provider_code = ?""",
            (data_provider_code,)
            ).fetchone()
    conn.close()
    count = list(carrier_count)[0]  # or result[0]
    return jsonify(count)



