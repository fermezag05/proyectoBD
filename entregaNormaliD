BEGIN;

CREATE TABLE crime_codes (
    iucr VARCHAR(10) PRIMARY KEY,
    primary_type VARCHAR(200) NOT NULL,
    description VARCHAR(200) NOT NULL,
    fbi_code VARCHAR(10) NOT NULL,
    --UNIQUE(primary_type, description, fbi_code)
);

CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    block VARCHAR(200) NOT NULL,
    location_description VARCHAR(200) NOT NULL,
    x_coordinate BIGINT,
    y_coordinate BIGINT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location VARCHAR(200),
    UNIQUE(block, location_description, x_coordinate, y_coordinate, latitude, longitude)
);

CREATE TABLE crimes(
    id BIGSERIAL PRIMARY KEY,
    case_number VARCHAR(200) NOT NULL,
    crime_date TIMESTAMP NOT NULL,
    iucr VARCHAR(10) REFERENCES crime_codes(iucr),
    arrest BOOLEAN NOT NULL,
    domestic BOOLEAN NOT NULL,
    beat BIGINT,
    district BIGINT,
    ward BIGINT,
    community_area BIGINT,
    location_id INT REFERENCES locations(location_id),
    year BIGINT,
    updated_on TIMESTAMP
);

ROLLBACK;
