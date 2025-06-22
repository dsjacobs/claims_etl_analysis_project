INSERT INTO policy (
    new_policy_id, effective_date, effective_date_source,
    issue_date, issue_date_source,
    maturity_date, maturity_date_source,
    death_benefit, death_benefit_source,
    carrier_name, carrier_name_source
)
SELECT 
    new_id AS new_policy_id,
    effective_date,
    effective_date_source,
    issue_date,
    issue_date_source,
    maturity_date,
    maturity_date_source,
    origination_death_benefit AS death_benefit,
    origination_death_benefit_source AS death_benefit_source,
    carrier_name,
    carrier_name_source
FROM prioritized;

INSERT INTO data_provider (
    data_provider_code, data_provider_description, data_provider_priority
)
SELECT DISTINCT 
    data_provider_code, data_provider_description, data_provider_priority
FROM nrml_data_providers;

INSERT INTO id_map (
    original_policy_id, new_policy_id
)
SELECT DISTINCT
    orig_id, new_id
FROM nrml_id_map;

INSERT INTO member (
    id, member_name, gender, dob
)
SELECT DISTINCT
    id, name, gender, dob
FROM nrml_member;

INSERT INTO member_policy (
    new_id, member_type, member_id
)
SELECT DISTINCT
    new_id, member_type, member_id
FROM nrml_pol_mbr_map;
