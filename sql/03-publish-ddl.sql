DROP TABLE IF EXISTS policy;
CREATE TABLE policy (
    new_policy_id INTEGER PRIMARY KEY,
    effective_date DATE,
    effective_date_source TEXT,
    issue_date DATE,
    issue_date_source TEXT,
    maturity_date DATE,
    maturity_date_source TEXT,
    death_benefit TEXT,
    death_benefit_source TEXT,
    carrier_name TEXT,
    carrier_name_source TEXT
);

DROP TABLE IF EXISTS data_provider;
CREATE TABLE data_provider (
    data_provider_code TEXT PRIMARY KEY,
    data_provider_description TEXT,
    data_provider_priority INTEGER
);

DROP TABLE IF EXISTS id_map;
CREATE TABLE id_map (
    original_policy_id TEXT PRIMARY KEY,
    new_policy_id INTEGER
);

DROP TABLE IF EXISTS member;
CREATE TABLE member (
    id INTEGER PRIMARY KEY,
    member_name TEXT,
    gender TEXT,
    dob DATE
);

DROP TABLE IF EXISTS member_policy;
CREATE TABLE member_policy (
    new_id INTEGER,
    member_type TEXT,
    member_id INTEGER
);




















