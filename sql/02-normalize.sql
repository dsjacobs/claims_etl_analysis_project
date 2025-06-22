INSERT INTO nrml_data_providers (data_provider_code, data_provider_description, data_provider_priority)
SELECT DISTINCT 
    data_provider_code, 
    data_provider_description, 
    data_provider_priority
FROM full_raw;

INSERT INTO nrml_member (name, gender, dob)
SELECT DISTINCT name, gender, dob
FROM (
    SELECT name_1 AS name, gender_1 AS gender, birth_date_1 AS dob FROM full_raw
    UNION
    SELECT name_2 AS name, gender_2 AS gender, birth_date_2 AS dob FROM full_raw WHERE name_2 IS NOT NULL
);

WITH ranked_policies AS (
    SELECT 
        number AS orig_id,
        DENSE_RANK() OVER (
            ORDER BY name_1
--                data_provider_code, 
--                data_provider_description,
--                data_provider_priority,
--                effective_date,
--                issue_date,
--                maturity_date,
--                origination_death_benefit,
--                carrier_name,
--                name_1,
--                gender_1,
--                birth_date_1,
--                name_2,
--                gender_2,
--                birth_date_2
        ) AS new_id
    FROM full_raw
)
INSERT INTO nrml_id_map (orig_id, new_id)
SELECT DISTINCT orig_id, new_id
FROM ranked_policies;

INSERT INTO nrml_depivoted (
    number, member_type, data_provider_code, effective_date, issue_date, 
    maturity_date, origination_death_benefit, carrier_name, name, gender, birth_date
)
SELECT 
    number,
    'primary' AS member_type,
    data_provider_code,
    effective_date,
    issue_date,
    maturity_date,
    origination_death_benefit,
    carrier_name,
    name_1,
    gender_1,
    birth_date_1
FROM full_raw
UNION ALL
SELECT 
    number,
    'secondary' AS member_type,
    data_provider_code,
    effective_date,
    issue_date,
    maturity_date,
    origination_death_benefit,
    carrier_name,
    name_2,
    gender_2,
    birth_date_2
FROM full_raw
WHERE name_2 IS NOT NULL;

INSERT INTO nrml_pol_mbr_map (new_id, member_type, member_id)
SELECT DISTINCT 
    id_map.new_id,
    d.member_type,
    m.id AS member_id
FROM nrml_depivoted d
JOIN nrml_member m 
    ON d.name = m.name AND d.gender = m.gender AND d.birth_date = m.dob
JOIN nrml_id_map id_map 
    ON d.number = id_map.orig_id;

INSERT INTO nrml_pol (
    new_id, data_provider_code, primary_member_id, effective_date, issue_date, 
    maturity_date, origination_death_benefit, carrier_name
)
SELECT DISTINCT 
    id_map.new_id,
    d.data_provider_code,
    mbr_map.member_id AS primary_member_id,
    d.effective_date,
    d.issue_date,
    d.maturity_date,
    d.origination_death_benefit,
    d.carrier_name
FROM nrml_depivoted d
JOIN nrml_id_map id_map 
    ON d.number = id_map.orig_id
JOIN nrml_pol_mbr_map mbr_map
    ON id_map.new_id = mbr_map.new_id AND mbr_map.member_type = 'primary';

INSERT INTO nrml_pol_priority (new_id, data_provider_code, data_provider_priority, effective_date, issue_date,
    maturity_date, origination_death_benefit,carrier_name)
SELECT DISTINCT
    id_map.new_id,
    d.data_provider_code,
    dp.data_provider_priority,
    d.effective_date,
    d.issue_date,
    d.maturity_date,
    d.origination_death_benefit,
    d.carrier_name
FROM nrml_depivoted d
JOIN nrml_id_map id_map
    ON d.number = id_map.orig_id
JOIN nrml_data_providers dp
    ON d.data_provider_code = dp.data_provider_code;

