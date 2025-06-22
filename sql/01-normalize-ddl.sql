DROP TABLE IF EXISTS nrml_data_providers;
CREATE TABLE nrml_data_providers (
    data_provider_code TEXT,
    data_provider_description TEXT,
    data_provider_priority INTEGER
);

DROP TABLE IF EXISTS nrml_member;
CREATE TABLE nrml_member (
    id INTEGER PRIMARY KEY,
    member_type TEXT,
    name TEXT,
    gender TEXT,
    dob DATE
);

DROP TABLE IF EXISTS nrml_id_map;
CREATE TABLE nrml_id_map (
    orig_id TEXT,
    new_id INTEGER
);

DROP TABLE IF EXISTS nrml_depivoted;
CREATE TABLE nrml_depivoted (
    number TEXT,
    member_type TEXT,
    data_provider_code TEXT,
    effective_date DATE,
    issue_date DATE,
    maturity_date DATE,
    origination_death_benefit TEXT,
    carrier_name TEXT,
    name TEXT,
    gender TEXT,
    birth_date DATE
);

DROP TABLE IF EXISTS nrml_pol_mbr_map;
CREATE TABLE nrml_pol_mbr_map (
    new_id INTEGER,
    member_type TEXT,
    member_id INTEGER
);

DROP TABLE IF EXISTS nrml_pol;
CREATE TABLE nrml_pol (
    new_id INTEGER,
    data_provider_code TEXT,
    primary_member_id INTEGER,
    effective_date DATE,
    issue_date DATE,
    maturity_date DATE,
    origination_death_benefit TEXT,
    carrier_name TEXT
);

DROP TABLE IF EXISTS nrml_pol_priority;
CREATE TABLE nrml_pol_priority (
    new_id INTEGER,
    data_provider_code TEXT,
    data_provider_priority INTEGER,
    effective_date DATE,
    issue_date DATE,
    maturity_date DATE,
    origination_death_benefit REAL,
    carrier_name TEXT
);
