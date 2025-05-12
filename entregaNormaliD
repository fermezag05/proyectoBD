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

--Poblar crime_codes
-- Insertar combinaciones únicas de IUCR, primary_type, description, fbi_code
INSERT INTO crime_codes (iucr, primary_type, description, fbi_code)
SELECT DISTINCT iucr, primary_type, description, fbi_code
FROM staging
WHERE iucr IS NOT NULL;

--Poblar locations
-- Insertar ubicaciones únicas con sus coordenadas y descripciones
INSERT INTO locations (
    block, location_description,
    x_coordinate, y_coordinate,
    latitude, longitude, location
)
SELECT DISTINCT
    block, location_description,
    x_coordinate, y_coordinate,
    latitude, longitude, location
FROM staging
WHERE block IS NOT NULL AND location_description IS NOT NULL;

--Poblar crimes
-- Insertar registros de crimen con sus claves foráneas correctamente asociadas
INSERT INTO crimes (
    case_number, crime_date, iucr,
    arrest, domestic, beat, district,
    ward, community_area, location_id,
    year, updated_on
)
SELECT
    s.case_number,
    s.date,                    -- o s.crime_date si ya renombraste
    s.iucr,
    s.arrest,
    s.domestic,
    s.beat,
    s.district,
    s.community_area,
    l.location_id,
    s.year,
    s.updated_on
FROM staging s
JOIN locations l ON
    s.block = l.block AND
    s.location_description = l.location_description AND
    s.x_coordinate = l.x_coordinate AND
    s.y_coordinate = l.y_coordinate AND
    s.latitude = l.latitude AND
    s.longitude = l.longitude AND
    s.location = l.location
WHERE s.iucr IS NOT NULL;
