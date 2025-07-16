CREATE TABLE dim_date (
    date_id VARCHAR PRIMARY KEY,
    year INT,
    month INT,
    dayweek VARCHAR,
    day_of_week VARCHAR,
    holiday_indicator VARCHAR
);

CREATE TABLE dim_lga (
    lga_id VARCHAR PRIMARY KEY,
    lga_name VARCHAR,
    dwellings INT
);

CREATE TABLE dim_location (
    location_id VARCHAR PRIMARY KEY,
    lga_id VARCHAR REFERENCES dim_lga(lga_id),
    state VARCHAR,
    national_remoteness_areas VARCHAR,
    sa4_name_2021 VARCHAR,
    national_lga_name_2021 VARCHAR
);

CREATE TABLE dim_crash_type (
    crash_type_id VARCHAR PRIMARY KEY,
    crash_type VARCHAR
);

CREATE TABLE dim_vehicle_involvement (
    vehicle_involvement_id VARCHAR PRIMARY KEY,
    bus_involvement VARCHAR,
    heavy_rigid_truck_involvement VARCHAR,
    articulated_truck_involvement VARCHAR,
    vehicle_involvement_description VARCHAR
);

CREATE TABLE dim_person (
    person_id VARCHAR PRIMARY KEY,
    gender VARCHAR,
    age FLOAT,
    age_group VARCHAR
);

CREATE TABLE dim_road_user (
    road_user_id VARCHAR PRIMARY KEY,
    road_user VARCHAR
);

CREATE TABLE dim_national_road_type (
    national_road_type_id VARCHAR PRIMARY KEY,
    national_road_type VARCHAR
);

CREATE TABLE fact_crash (
    crash_id VARCHAR PRIMARY KEY,
    date_id VARCHAR REFERENCES dim_date(date_id),
    location_id VARCHAR REFERENCES dim_location(location_id),
    road_user_id VARCHAR REFERENCES dim_road_user(road_user_id),
    person_id VARCHAR REFERENCES dim_person(person_id),
    crash_type_id VARCHAR REFERENCES dim_crash_type(crash_type_id),
    vehicle_involvement_id VARCHAR REFERENCES dim_vehicle_involvement(vehicle_involvement_id),
    national_road_type_id VARCHAR REFERENCES dim_national_road_type(national_road_type_id),
    number_fatalities INT
);

-- Add time column
ALTER TABLE fact_crash
ADD COLUMN time TIME;

-- Add time_of_day column
ALTER TABLE fact_crash
ADD COLUMN time_of_day VARCHAR;

-- Add speed_limit column
ALTER TABLE fact_crash
ADD COLUMN speed_limit INT;

ALTER TABLE fact_crash
ALTER COLUMN speed_limit TYPE NUMERIC;


