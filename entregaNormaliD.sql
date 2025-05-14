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
	location_description VARCHAR(200)
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
    block_id BIGINT REFERENCES blocks(id) ON DELETE CASCADE,
    description_id BIGINT REFERENCES locations_descriptions(id) ON DELETE CASCADE,
    coordinate_id BIGINT REFERENCES coordinates(id) ON DELETE CASCADE
);

CREATE TABLE crimes(
    id BIGSERIAL PRIMARY KEY,
    case_number VARCHAR(200) NOT NULL,
    crime_date TIMESTAMP NOT NULL,
    iucr VARCHAR(10) REFERENCES crime_codes(iucr) ON DELETE CASCADE,
    location_id BIGINT REFERENCES locations(id) ON DELETE CASCADE,
    arrest BOOLEAN NOT NULL,
    domestic BOOLEAN NOT NULL,
    beat BIGINT,
    district BIGINT,
    ward BIGINT,
    community_area BIGINT,
    "year" BIGINT,
    updated_on TIMESTAMP,
    UNIQUE(case_number, crime_date, iucr, location_id)
);

--Población


-- 1) crime_codes
INSERT INTO crime_codes (iucr, primary_type, description, fbi_code)
SELECT DISTINCT
    sc.iucr,
    sc.primary_type,
    sc.description,
    sc.fbi_code
FROM staging_cleaned sc
WHERE sc.iucr IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
      FROM crime_codes cc
     WHERE cc.iucr = sc.iucr
  );

-- 2) blocks
INSERT INTO blocks (block)
SELECT DISTINCT
    sc.block
FROM staging_cleaned sc
WHERE sc.block IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
      FROM blocks b
     WHERE b.block = sc.block
  );

-- 3) locations_descriptions
INSERT INTO locations_descriptions (location_description)
SELECT DISTINCT
    sc.location_description
FROM staging_cleaned sc
WHERE sc.location_description IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
      FROM locations_descriptions ld
     WHERE ld.location_description = sc.location_description
  );

-- 4) coordinates
INSERT INTO coordinates (x_coordinate, y_coordinate, latitude, longitude, location)
SELECT DISTINCT
    sc.x_coordinate,
    sc.y_coordinate,
    sc.latitude,
    sc.longitude,
    sc.location
FROM staging_cleaned sc
WHERE sc.x_coordinate IS NOT NULL
  AND sc.y_coordinate IS NOT NULL
  AND sc.latitude     IS NOT NULL
  AND sc.longitude    IS NOT NULL
  AND sc.location     IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
      FROM coordinates c
     WHERE c.x_coordinate = sc.x_coordinate
       AND c.y_coordinate = sc.y_coordinate
       AND c.latitude     = sc.latitude
       AND c.longitude    = sc.longitude
       AND c.location     = sc.location
  );

-- 5) locations: arma la tupla (block_id, description_id, coordinate_id) única
INSERT INTO locations(block_id, description_id, coordinate_id)
SELECT DISTINCT
    b.id AS block_id,
    d.id AS description_id,
    c.id AS coordinate_id
FROM staging_cleaned s
JOIN blocks b ON s.block = b.block
JOIN locations_descriptions d ON s.location_description = d.location_description
JOIN coordinates c
     ON s.x_coordinate = c.x_coordinate
    AND s.y_coordinate = c.y_coordinate
    AND s.latitude     = c.latitude
    AND s.longitude    = c.longitude
    AND s.location     = c.location

-- 6) crimes: finalmente, inserta cada crimen referenciando crime_codes y locations
INSERT INTO crimes (
    case_number,
    crime_date,
    iucr,
    location_id,
    arrest,
    domestic,
    beat,
    district,
    ward,
    community_area,
    "year",
    updated_on
)
SELECT
    s.case_number,
    s.crime_date,
    s.iucr,
    l.id           AS location_id,
    s.arrest,
    s.domestic,
    s.beat,
    s.district,
    s.ward,
    s.community_area,
    s."year",
    TO_TIMESTAMP(s.updated_on, 'MM/DD/YYYY HH12:MI:SS AM')
FROM staging s
JOIN blocks                  b ON s.block = b.block
JOIN locations_descriptions  d ON s.location_description = d.location_description
JOIN coordinates             c ON s.x_coordinate = c.x_coordinate
                              AND s.y_coordinate = c.y_coordinate
                              AND s.latitude     = c.latitude
                              AND s.longitude    = c.longitude
                              AND s.location     = c.location
JOIN locations               l ON l.block_id       = b.id
                              AND l.description_id = d.id
                              AND l.coordinate_id  = c.id;


DROP TABLE staging;
DROP TABLE staging_cleaned;
DROP TABLE staging_backup;
