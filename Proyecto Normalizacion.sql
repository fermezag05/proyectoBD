BEGIN;

CREATE TABLE crime_types (
	id BIGSERIAL PRIMARY KEY,
    iucr VARCHAR(200) NOT NULL,
    primary_type VARCHAR(200) NOT NULL,
    description TEXT NULL,
    fbi_code VARCHAR(200) NOT NULL
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
    locations_id BIGINT NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
    crimes_types_id BIGINT NOT NULL REFERENCES crime_types(id) ON DELETE CASCADE,
    arrest BOOLEAN NOT NULL,
    domestic BOOLEAN NOT NULL,
    beat BIGINT NOT NULL,
    "year" BIGINT NOT NULL,
    updated_on VARCHAR(200)
);

ROLLBACK;
