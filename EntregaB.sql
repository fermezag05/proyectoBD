--En este codigo se vera como se hace la carga inicial de los datos desde un .csv que esta disponible para descargar desde https://data.cityofchicago.org/Public-Safety/Crimes-2021/dwme-t96c/about_data 
CREATE DATABASE nombre_de_la_base; 
--Reemplaza nombre_de_la_base con el nombre que desees darle. Después, conéctate a la base de datos usando:
\c nombre_de_la_base 
--A continuación, copia y pega el siguiente script para crear una tabla en SQL:
  
CREATE TABLE staging(id BIGSERIAL PRIMARY KEY,
 case_number VARCHAR(200) NOT NULL,
 crime_date TEXT,
 block VARCHAR(200),
 iucr VARCHAR(200),
 primary_type VARCHAR(200),
 description VARCHAR(200) NOT NULL,
 location_description VARCHAR(200), 
 arrest BOOLEAN NOT NULL, 
 domestic BOOLEAN NOT NULL, 
 beat BIGINT, 
 district BIGINT,
 ward BIGINT,
 community_area BIGINT,
 fbi_code VARCHAR(200),
 x_coordinate BIGINT,
 y_coordinate BIGINT,
 year BIGINT,
 updated_on VARCHAR(200),
 latitude DOUBLE PRECISION,
 longitude DOUBLE PRECISION,
 location VARCHAR(200));

--Por último, carga la información utilizando el siguiente comando en SQL Shell:
/*
\copy staging(id, case_number, crime_date, block, iucr, primary_type, description, location_description, arrest, domestic, beat, district, ward, community_area, fbi_code, x_coordinate, y_coordinate, year, updated_on, latitude, longitude, location) FROM '/.../Crimes_-_2021_20250416.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
*/

--Por último, realizamos una modificación a la tabla para convertir crime_date a un timestamp. Dicha modificación se hace ejecutando el siguiente código:
ALTER TABLE staging ADD COLUMN crime_timestamp TIMESTAMP;
UPDATE staging SET crime_timestamp = TO_TIMESTAMP(crime_date, 'MM/DD/YYYY HH12:MI:SS AM');
ALTER TABLE staging DROP COLUMN crime_date;
ALTER TABLE staging RENAME COLUMN crime_timestamp TO crime_date;

-- ¿Existen columnas con valores únicos?

-- Mínimos y máximos de fechas

SELECT crime_date as maxima
FROM staging
WHERE crime_date=(SELECT MAX(crime_date)
FROM staging);

SELECT crime_date as minima
FROM staging
WHERE crime_date=(SELECT MIN(crime_date)
FROM staging);
-- Mínimos, máximos y promedios de valores numéricos
SELECT
    MIN(latitude) AS min_latitude,
    MAX(latitude) AS max_latitude,
    AVG(latitude) AS avg_latitude,
    MIN(longitude) AS min_longitude,
    MAX(longitude) AS max_longitude,
    AVG(longitude) AS avg_longitude
FROM staging
WHERE latitude IS NOT NULL AND longitude IS NOT NULL;

-- Duplicados en atributos categóricos
SELECT
    case_number, crime_date, primary_type, description, location_description, arrest, domestic, block, COUNT(*)
FROM staging
GROUP BY
    case_number, crime_date, primary_type, description, location_description, arrest, domestic, block
HAVING COUNT(*) > 1;
-- Columnas redundantes
-- Esta query busca si una misma combinación de X/Y Coordinate aparece con diferentes Lat/Lon
SELECT
    x_coordinate,
    y_coordinate,
    COUNT(DISTINCT latitude) AS distinct_lat_count,
    COUNT(DISTINCT longitude) AS distinct_lon_count,
    MIN(latitude) AS example_lat,
    MAX(latitude) AS example_lat2,
    MIN(longitude) AS example_lon,
    MAX(longitude) AS example_lon2
FROM staging
WHERE x_coordinate IS NOT NULL AND y_coordinate IS NOT NULL
GROUP BY x_coordinate, y_coordinate
HAVING COUNT(DISTINCT latitude) > 1 OR COUNT(DISTINCT longitude) > 1;

--Conteo de tuplas por cada categoría
-- Conteo por tipo primario de crimen
SELECT primary_type, COUNT(*) AS count
FROM staging
GROUP BY primary_type
ORDER BY count DESC;

-- Conteo por descripción de la ubicación
SELECT location_description, COUNT(*) AS count
FROM staging
GROUP BY location_description
ORDER BY count DESC;

-- Conteo por estado de arresto (True/False)
SELECT arrest, COUNT(*) AS count
FROM staging
GROUP BY arrest;

-- Conteo por estado doméstico (True/False)
SELECT domestic, COUNT(*) AS count
FROM staging
GROUP BY domestic;
--Conteo de valores nulos
SELECT
    COUNT(CASE WHEN id IS NULL THEN 1 END) AS null_id_count,
    COUNT(CASE WHEN case_number IS NULL THEN 1 END) AS null_case_number_count,
    COUNT(CASE WHEN crime_date IS NULL THEN 1 END) AS null_date_count,
    COUNT(CASE WHEN block IS NULL THEN 1 END) AS null_block_count,
    COUNT(CASE WHEN primary_type IS NULL THEN 1 END) AS null_primary_type_count,
    COUNT(CASE WHEN description IS NULL THEN 1 END) AS null_description_count,
    COUNT(CASE WHEN location_description IS NULL THEN 1 END) AS null_location_description_count,
    COUNT(CASE WHEN arrest IS NULL THEN 1 END) AS null_arrest_count,
    COUNT(CASE WHEN domestic IS NULL THEN 1 END) AS null_domestic_count,
    COUNT(CASE WHEN latitude IS NULL THEN 1 END) AS null_latitude_count,
    COUNT(CASE WHEN longitude IS NULL THEN 1 END) AS null_longitude_count,
    COUNT(CASE WHEN location IS NULL THEN 1 END) AS null_location_count,
    COUNT(CASE WHEN x_coordinate IS NULL THEN 1 END) AS null_x_coordinate_count,
    COUNT(CASE WHEN y_coordinate IS NULL THEN 1 END) AS null_y_coordinate_count
FROM staging;
--¿Existen inconsistencias en el set de datos?

 --buscamos inconsistencias
-- Verifica si existen combinaciones de primary_type y description asociadas a más de un fbi_code
-- Esto indica una inconsistencia semántica: un mismo tipo de crimen debería tener un único código FBI
SELECT 
    primary_type, 
    description, 
    COUNT(DISTINCT fbi_code) AS distinct_fbi_codes
FROM staging
GROUP BY primary_type, description
HAVING COUNT(DISTINCT fbi_code) > 1;

-- Revisión específica de una de las inconsistencias encontradas anteriormente
-- En este caso, el crimen 'UNAUTHORIZED VIDEOTAPING' bajo 'DECEPTIVE PRACTICE' tiene más de un fbi_code
SELECT 
    primary_type, 
    description, 
    fbi_code, 
    COUNT(*) AS occurrences
FROM staging
WHERE primary_type = 'DECEPTIVE PRACTICE'
  AND description = 'UNAUTHORIZED VIDEOTAPING'
GROUP BY primary_type, description, fbi_code;

-- Verifica si existen case_number duplicados (esperado: cada uno debe ser único)
-- Si COUNT(*) > 1, entonces hay registros duplicados lógicamente
SELECT case_number, COUNT(*) AS count_per_case
FROM staging
GROUP BY case_number
HAVING COUNT(*) > 1
ORDER BY count_per_case DESC;

-- Revisión puntual de un case_number duplicado (por ejemplo, JE266473)
-- Se pueden observar los valores que comparten para validar que son duplicados reales
SELECT *
FROM staging
WHERE case_number = 'JE266473';

-- Query para ver específicamente si hay espacios al inicio/final en 'primary_type'
SELECT COUNT(*)
FROM staging
WHERE primary_type <> TRIM(primary_type); -- TRIM quita espacios al inicio y final

-- Esto lista variaciones que podrían ser la misma categoría
SELECT DISTINCT primary_type
FROM staging
ORDER BY primary_type;
-- (Revisión visual requerida para identificar ' THEFT' vs 'THEFT' o 'Theft' vs 'THEFT')

-- CONCLUSIÓN:
-- Se identificaron inconsistencias en el dataset:
-- 1. Existen duplicados lógicos de casos, es decir, múltiples filas con el mismo case_number (ej. JE266473).
-- 2. Algunas combinaciones de (primary_type, description) están asociadas a más de un fbi_code, lo cual rompe la consistencia semántica esperada.
-- 3. No hay inconsistencias en el nombre del primary_type 
--Estas inconsistencias deben corregirse para asegurar integridad y coherencia antes de cualquier análisis o normalización del modelo de datos.
