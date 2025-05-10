BEGIN;

CREATE TABLE crime_types (
	id BIGSERIAL PRIMARY KEY,
    iucr SMALLINT,
    primary_type TEXT,
    description TEXT
);

CREATE TABLE locations (
	id BIGSERIAL PRIMARY KEY
    block TEXT,
    location_description TEXT,
    district INTEGER,
    ward INTEGER,
    community_area INTEGER
);

CREATE TABLE crimes(
    id BIGSERIAL PRIMARY KEY,
    case_number VARCHAR(50),
    "date" TIMESTAMP,
    locations_id BIGINT NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
    crimes_types_id BIGINT NOT NULL REFERENCES crime_types(id) ON DELETE CASCADE,
    arrest BOOLEAN,
    domestic BOOLEAN,
    beat INTEGER,
    fbi_code VARCHAR(50),
    x_coordinate BIGINT,
    y_coordinate BIGINT,
    "year" BIGINT,
    updated_on TIMESTAMP,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location TEXT
);

SELECT "Block", "District", "Ward", "Community Area" FROM crimes_2021 ORDER BY "Block" LIMIT 300;

SELECT * FROM crimes_2021 LIMIT 100;

ROLLBACK;
