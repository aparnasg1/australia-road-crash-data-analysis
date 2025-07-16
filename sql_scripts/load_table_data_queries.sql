ALTER TABLE fact_crash DROP CONSTRAINT fact_crash_pkey;
ALTER TABLE fact_crash ADD COLUMN id SERIAL PRIMARY KEY;


COPY dim_date
FROM '/tmp/project1_data/dim_date.csv'
WITH (FORMAT csv, DELIMITER ',', HEADER true);

COPY dim_lga
FROM '/tmp/project1_data/dim_lga.csv'
WITH (FORMAT csv, DELIMITER ',', HEADER true);

COPY dim_location
FROM '/tmp/project1_data/dim_location.csv'
WITH (FORMAT csv, DELIMITER ',', HEADER true);

COPY dim_crash_type
FROM '/tmp/project1_data/dim_crash_type.csv'
WITH (FORMAT csv, DELIMITER ',', HEADER true);

COPY dim_vehicle_involvement
FROM '/tmp/project1_data/dim_vehicle_involvement.csv'
WITH (FORMAT csv, DELIMITER ',', HEADER true);

COPY dim_person
FROM '/tmp/project1_data/dim_person.csv'
WITH (FORMAT csv, DELIMITER ',', HEADER true);

COPY dim_road_user
FROM '/tmp/project1_data/dim_road_user.csv'
WITH (FORMAT csv, DELIMITER ',', HEADER true);

COPY dim_national_road_type
FROM '/tmp/project1_data/dim_national_road_type.csv'
WITH (FORMAT csv, DELIMITER ',', HEADER true);



COPY fact_crash (
    crash_id,
    date_id,
    location_id,
    road_user_id,
    person_id,
    crash_type_id,
    vehicle_involvement_id,
    national_road_type_id,
    time,
    time_of_day,
    speed_limit,
    number_fatalities
)
FROM '/tmp/project1_data/fact_crash.csv'
WITH (
    FORMAT csv,
    DELIMITER ',',
    HEADER true
);