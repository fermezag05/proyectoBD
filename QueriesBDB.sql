-- Comprobar si 'id' es único
SELECT COUNT(id) AS total_rows, COUNT(DISTINCT id) AS unique_ids
FROM staging;

-- Comprobar si 'case_number' es único (a menudo debería serlo)
SELECT COUNT(case_number) AS total_rows, COUNT(DISTINCT case_number) AS unique_case_numbers
FROM staging;

SELECT case_number, COUNT(*) AS count_per_case
FROM staging
GROUP BY case_number
HAVING COUNT(*) > 1
ORDER BY count_per_case DESC; -- Ordena para ver los más repetidos primero


--JE266473
SELECT *
FROM staging
WHERE case_number = 'JE266473'; -- Reemplaza con un case_number duplicado

SELECT *
FROM staging
WHERE id = 13809379;

-- 1. Crear respaldo completo de la tabla original
CREATE TABLE staging_backup AS
SELECT *
FROM staging;

-- 2. Crear tabla limpia dejando solo un registro por case_number
CREATE TABLE staging_cleaned AS
WITH ranked_cases AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY case_number ORDER BY id) AS rn
  FROM staging
)
SELECT *
FROM ranked_cases
WHERE rn = 1;


-- min y max
SELECT
    MIN(latitude) AS min_latitude,
    MAX(latitude) AS max_latitude,
    AVG(latitude) AS avg_latitude,
    MIN(longitude) AS min_longitude,
    MAX(longitude) AS max_longitude,
    AVG(longitude) AS avg_longitude
FROM staging
WHERE latitude IS NOT NULL AND longitude IS NOT NULL;

--Duplicados en atributos categóricos
SELECT
    case_number, crime_date, primary_type, description, location_description, arrest, domestic, block, COUNT(*)
FROM staging
GROUP BY
    case_number, crime_date, primary_type, description, location_description, arrest, domestic, block
HAVING COUNT(*) > 1;

--Columnas redundantes

-- Asumiendo que tienes x_coordinate, y_coordinate, latitude, longitude
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
    COUNT(CASE WHEN location IS NULL THEN 1 END) AS null_location_count
FROM staging;

-- Alternativa (más dinámica pero requiere ejecutar query por columna o scripting)
-- SELECT 'nombre_columna', SUM(CASE WHEN nombre_columna IS NULL THEN 1 ELSE 0 END) FROM crimes_data;
-- Repetir para cada columna de interés.

--¿Existen inconsistencias en el set de datos?
--Categorías con posibles problemas de espacios/capitalización (ejemplo con primary_type)
-- Esto lista variaciones que podrían ser la misma categoría
SELECT DISTINCT primary_type
FROM staging
ORDER BY primary_type;
-- (Revisión visual requerida para identificar ' THEFT' vs 'THEFT' o 'Theft' vs 'THEFT')

-- Query para ver específicamente si hay espacios al inicio/final en 'primary_type'
SELECT COUNT(*)
FROM staging
WHERE primary_type <> TRIM(primary_type); -- TRIM quita espacios al inicio y final




--LIMPIEZA DE DATOS


-- CTE para identificar duplicados
WITH ranked_cases AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY case_number ORDER BY id) AS rn
  FROM staging
)

-- Dejar solo la primera ocurrencia de cada case_number
DELETE FROM staging
WHERE id IN (
  SELECT id
  FROM ranked_cases
  WHERE rn > 1
);


SELECT x_coordinate, y_coordinate,
       COUNT(DISTINCT latitude), COUNT(DISTINCT longitude)
FROM staging
GROUP BY x_coordinate, y_coordinate
HAVING COUNT(DISTINCT latitude) > 1 OR COUNT(DISTINCT longitude) > 1;

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
    COUNT(CASE WHEN location IS NULL THEN 1 END) AS null_location_count
FROM staging;

-- Step 1: Add a new column with TIMESTAMP type
ALTER TABLE staging ADD COLUMN crime_timestamp TIMESTAMP;

-- Step 2: Populate it by converting from the old text column
UPDATE staging
SET crime_timestamp = TO_TIMESTAMP(crime_date, 'MM/DD/YYYY HH12:MI:SS AM');

-- Step 3: Drop the old column
ALTER TABLE staging DROP COLUMN crime_date;

-- Step 4 (Optional): Rename the new column
ALTER TABLE staging RENAME COLUMN crime_timestamp TO crime_date;


SELECT DISTINCT primary_type,description, fbi_code
FROM staging;
 --buscamos inconsistencias
SELECT 
    primary_type, 
    description, 
    COUNT(DISTINCT fbi_code) AS distinct_fbi_codes
FROM staging
GROUP BY primary_type, description
HAVING COUNT(DISTINCT fbi_code) > 1;

SELECT 
    primary_type, 
    description, 
    fbi_code, 
    COUNT(*) AS occurrences
FROM staging
WHERE primary_type = 'DECEPTIVE PRACTICE'
  AND description = 'UNAUTHORIZED VIDEOTAPING'
GROUP BY primary_type, description, fbi_code;

UPDATE staging
SET fbi_code = '11'
WHERE primary_type = 'DECEPTIVE PRACTICE'
  AND description = 'UNAUTHORIZED VIDEOTAPING'
  AND fbi_code = '17';

SELECT 
    iucr,
    COUNT(*) AS total_ocurrencias,
    COUNT(DISTINCT primary_type) AS tipos_distintos,
    COUNT(DISTINCT description) AS descripciones_distintas,
    COUNT(DISTINCT fbi_code) AS codigos_fbi_distintos
FROM staging
GROUP BY iucr
ORDER BY tipos_distintos DESC, descripciones_distintas DESC;

SELECT 
    iucr, primary_type, description, fbi_code, COUNT(*) AS ocurrencias
FROM staging
GROUP BY iucr, primary_type, description, fbi_code
ORDER BY iucr, ocurrencias DESC;
