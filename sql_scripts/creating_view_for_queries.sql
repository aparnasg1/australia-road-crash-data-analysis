--1. Crash Density Normalized by Dwellings
CREATE OR REPLACE VIEW vw_crash_density_per_1000_dwellings AS
WITH unique_crashes AS (
    SELECT DISTINCT crash_id, location_id
    FROM fact_crash
)
SELECT
    dl.lga_name,
    dl.dwellings,
    COUNT(uc.crash_id) AS total_crashes,
    ROUND(COUNT(uc.crash_id) * 1000.0 / NULLIF(dl.dwellings, 0), 2) AS crashes_per_1000_dwellings
FROM unique_crashes uc
JOIN dim_location loc ON uc.location_id = loc.location_id
JOIN dim_lga dl ON loc.lga_id = dl.lga_id
GROUP BY dl.lga_name, dl.dwellings;

-- 2. Holiday Hotspot LGAs
CREATE OR REPLACE VIEW vw_holiday_hotspots_lga AS
WITH unique_holiday_crashes AS (
    SELECT DISTINCT crash_id, location_id, fc.date_id
    FROM fact_crash fc
    JOIN dim_date dd ON fc.date_id = dd.date_id
    WHERE dd.holiday_indicator IN ('Christmas', 'Easter')
)
SELECT
    dl.national_lga_name_2021 AS lga_name,
    COUNT(uhc.crash_id) AS holiday_crashes
FROM unique_holiday_crashes uhc
JOIN dim_location dl ON uhc.location_id = dl.location_id
GROUP BY dl.national_lga_name_2021;

--3. Most Fatal Road Users
CREATE OR REPLACE VIEW vw_road_user_fatalities AS
WITH unique_crashes AS (
    SELECT DISTINCT crash_id, road_user_id, number_fatalities
    FROM fact_crash
)
SELECT
    dru.road_user,
    COUNT(uc.crash_id) AS total_crashes,
    SUM(uc.number_fatalities) AS total_fatalities
FROM unique_crashes uc
JOIN dim_road_user dru ON uc.road_user_id = dru.road_user_id
GROUP BY dru.road_user;

--4. Time of Day Crash Patterns
CREATE OR REPLACE VIEW vw_time_of_day_fatal_crashes AS
WITH unique_crashes AS (
    SELECT DISTINCT crash_id, time_of_day, number_fatalities
    FROM fact_crash
)
SELECT
    time_of_day,
    COUNT(crash_id) AS total_crashes,
    SUM(number_fatalities) AS total_fatalities
FROM unique_crashes
GROUP BY time_of_day;

--5. Speed Limit vs Fatalities
CREATE OR REPLACE VIEW vw_speed_limit_fatalities AS
WITH unique_crashes AS (
    SELECT DISTINCT crash_id, speed_limit, number_fatalities
    FROM fact_crash
)
SELECT 
    speed_limit,
    COUNT(crash_id) AS crash_count,
    SUM(number_fatalities) AS total_fatalities,
    ROUND(AVG(number_fatalities), 2) AS avg_fatalities_per_crash
FROM unique_crashes
GROUP BY speed_limit;

--6. Road User Type & Holiday Period (CUBE)
CREATE OR REPLACE VIEW vw_road_user_holiday_cube AS
WITH unique_crashes AS (
    SELECT DISTINCT crash_id, road_user_id, date_id, number_fatalities
    FROM fact_crash
)
SELECT 
    dru.road_user,
    dd.holiday_indicator,
    COUNT(DISTINCT uc.crash_id) AS crash_count,
    SUM(uc.number_fatalities) AS total_fatalities
FROM unique_crashes uc
JOIN dim_date dd ON uc.date_id = dd.date_id
JOIN dim_road_user dru ON uc.road_user_id = dru.road_user_id
GROUP BY CUBE (dru.road_user, dd.holiday_indicator);

--7. Vehicle Type Involvement
CREATE OR REPLACE VIEW vw_vehicle_involvement_fatalities AS
WITH unique_crashes AS (
    SELECT DISTINCT crash_id, vehicle_involvement_id, number_fatalities
    FROM fact_crash
)
SELECT
    dvi.vehicle_involvement_description,
    COUNT(DISTINCT uc.crash_id) AS total_crashes,
    SUM(uc.number_fatalities) AS total_fatalities
FROM unique_crashes uc
JOIN dim_vehicle_involvement dvi 
    ON uc.vehicle_involvement_id = dvi.vehicle_involvement_id
GROUP BY dvi.vehicle_involvement_description;

--8. Crash Type and Road Type (CUBE)
CREATE OR REPLACE VIEW vw_crash_road_type_cube AS
WITH unique_crashes AS (
    SELECT DISTINCT crash_id, crash_type_id, national_road_type_id, number_fatalities
    FROM fact_crash
)
SELECT 
    dct.crash_type,
    dnrt.national_road_type,
    COUNT(DISTINCT uc.crash_id) AS crash_count,
    SUM(uc.number_fatalities) AS total_fatalities
FROM unique_crashes uc
JOIN dim_crash_type dct 
    ON uc.crash_type_id = dct.crash_type_id
JOIN dim_national_road_type dnrt 
    ON uc.national_road_type_id = dnrt.national_road_type_id
GROUP BY CUBE (dct.crash_type, dnrt.national_road_type);
