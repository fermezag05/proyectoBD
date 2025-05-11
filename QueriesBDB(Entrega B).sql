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
    -- Añade más columnas según sea necesario
FROM staging;

-- Alternativa (más dinámica pero requiere ejecutar query por columna o scripting)
-- SELECT 'nombre_columna', SUM(CASE WHEN nombre_columna IS NULL THEN 1 ELSE 0 END) FROM crimes_data;
-- Repetir para cada columna de interés.

--¿Existen inconsistencias en el set de datos?
Categorías con posibles problemas de espacios/capitalización (ejemplo con primary_type)
-- Esto lista variaciones que podrían ser la misma categoría
SELECT DISTINCT primary_type
FROM staging
ORDER BY primary_type;
-- (Revisión visual requerida para identificar ' THEFT' vs 'THEFT' o 'Theft' vs 'THEFT')

-- Query para ver específicamente si hay espacios al inicio/final en 'primary_type'
SELECT COUNT(*)
FROM staging
WHERE primary_type <> TRIM(primary_type); -- TRIM quita espacios al inicio y final
