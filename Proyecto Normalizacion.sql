BEGIN;

CREATE TABLE crime_types (
	id BIGSERIAL PRIMARY KEY,
    iucr VARCHAR(200) NOT NULL,
    primary_type VARCHAR(200) NOT NULL,
    description TEXT NULL
);

CREATE TABLE locations (
	id BIGSERIAL PRIMARY KEY
    block VARCHAR(200) NOT NULL,
    location_description TEXT NOT NULL,
    district BIGINT NOT NULL,
    ward BIGINT NOT NULL,
    community_area BIGINT NOT NULL
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
    fbi_code VARCHAR(200) NOT NULL,
    x_coordinate BIGINT NOT NULL,
    y_coordinate BIGINT NOT NULL,
    "year" BIGINT NOT NULL,
    updated_on VARCHAR(200),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location TEXT NULL
);

ROLLBACK;
