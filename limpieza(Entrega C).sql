-- LIMPIEZA DE DATOS

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

-- CTE para identificar duplicados de case_number asignando un número de fila
WITH ranked_cases AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY case_number ORDER BY id) AS rn
  FROM staging
)

-- Eliminamos duplicados de case_number dejando solo la primera ocurrencia
DELETE FROM staging
WHERE id IN (
  SELECT id
  FROM ranked_cases
  WHERE rn > 1
);

-- Identificamos coordenadas (x,y) que tienen múltiples valores distintos de latitud o longitud
SELECT x_coordinate, y_coordinate,
       COUNT(DISTINCT latitude), COUNT(DISTINCT longitude)
FROM staging
GROUP BY x_coordinate, y_coordinate
HAVING COUNT(DISTINCT latitude) > 1 OR COUNT(DISTINCT longitude) > 1;

-- Conteo de valores nulos por columna relevante
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
    COUNT(CASE WHEN location IS NULL THEN 1 END) AS null_location_count;

-- Buscamos inconsistencias: un mismo tipo y descripción con múltiples códigos FBI
SELECT 
    primary_type, 
    description, 
    COUNT(DISTINCT fbi_code) AS distinct_fbi_codes
FROM staging
GROUP BY primary_type, description
HAVING COUNT(DISTINCT fbi_code) > 1;

-- Revisión específica de un caso con posible inconsistencia en códigos FBI
SELECT 
    primary_type, 
    description, 
    fbi_code, 
    COUNT(*) AS occurrences
FROM staging
WHERE primary_type = 'DECEPTIVE PRACTICE'
  AND description = 'UNAUTHORIZED VIDEOTAPING'
GROUP BY primary_type, description, fbi_code;

-- Corregimos el código FBI para registros específicos con inconsistencia detectada
UPDATE staging
SET fbi_code = '11'
WHERE primary_type = 'DECEPTIVE PRACTICE'
  AND description = 'UNAUTHORIZED VIDEOTAPING'
  AND fbi_code = '17';

-- Evaluamos cuántos tipos y descripciones distintas tiene cada IUCR, para detectar ambigüedad
SELECT 
    iucr,
    COUNT(*) AS total_ocurrencias,
    COUNT(DISTINCT primary_type) AS tipos_distintos,
    COUNT(DISTINCT description) AS descripciones_distintas,
    COUNT(DISTINCT fbi_code) AS codigos_fbi_distintos
FROM staging
GROUP BY iucr
ORDER BY tipos_distintos DESC, descripciones_distintas DESC;

-- Validamos las combinaciones únicas de IUCR, tipo, descripción y código FBI
SELECT 
    iucr, primary_type, description, fbi_code, COUNT(*) AS ocurrencias
FROM staging
GROUP BY iucr, primary_type, description, fbi_code
ORDER BY iucr, ocurrencias DESC;



