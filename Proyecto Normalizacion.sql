BEGIN;

CREATE TABLE crime_codes (
    iucr VARCHAR(10) PRIMARY KEY,
    primary_type VARCHAR(200) NOT NULL,
    description VARCHAR(200) NOT NULL,
    fbi_code VARCHAR(10) NOT NULL
);

CREATE TABLE blocks (
	id BIGSERIAL PRIMARY KEY,
	block VARCHAR(200) NOT NULL
);

CREATE TABLE locations_descriptions (
	id BIGSERIAL PRIMARY KEY,
	location_description VARCHAR(200) NOT NULL
);

CREATE TABLE coordinates (
	id BIGSERIAL PRIMARY KEY,
	x_coordinate BIGINT,
	y_coordinate BIGINT,
	latitude DOUBLE PRECISION,
	longitude DOUBLE PRECISION,
	location VARCHAR(200)
);

CREATE TABLE locations (
    id BIGSERIAL PRIMARY KEY,
    block_id BIGINT REFERENCES blocks(id),
    description_id BIGINT REFERENCES locations_descriptions(id),
    coordinate_id BIGINT REFERENCES coordinates(id),
    UNIQUE (block_id, description_id, coordinate_id)
);

CREATE TABLE crimes(
    id BIGSERIAL PRIMARY KEY,
    case_number VARCHAR(200) NOT NULL,
    crime_date TIMESTAMP NOT NULL,
    iucr VARCHAR(10) REFERENCES crime_codes(iucr),
    location_id BIGINT REFERENCES locations(id),
    arrest BOOLEAN NOT NULL,
    domestic BOOLEAN NOT NULL,
    beat BIGINT,
    district BIGINT,
    ward BIGINT,
    community_area BIGINT,
    "year" BIGINT,
    updated_on TIMESTAMP
);

ROLLBACK;
