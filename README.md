# proyectoBD
Proyecto Bases de Datos

PROYECTO EQUIPO 3

Nuestros datos contienen información sobre los crímenes que se han cometido en la ciudad de Chicago a partir del 2021. Estos datos incluyen información relevante sobre los crímenes, así como: fecha, tipo de crimen, si sucede un arresto, ubicación del crimen y más. Los datos fueron extraídos del Chicago Data Portal.
	Nuestros datos son recolectados por el sistema CLEAR (Citizen Law Enforcement Analysis and Reporting) del departamento de policía de Chicago. El propósito de la recolección de estos datos es para mantener un registro sobre los crímenes que ocurren en la ciudad de Chicago. Los datos se pueden obtener en el Chicago Data Portal: https://data.cityofchicago.org/Public-Safety/Crimes-2021/dwme-t96c/about_data
Nota: Realizamos este proyecto con la base de datos adjunta en el zip, ya que sabíamos que junto con las actualizaciones de los datos podrían venir cambios, por lo que decisimos utilizar todos la misma versión).
Los datos se actualizan de manera diaria, permitiéndonos utilizar datos sobre crímenes muy recientes (se bajó el csv de la última actualización de la base de datos el día 16 de Abril del 2025). 

Información sobre la base de datos:
Número de tuplas: 209,000
Número de atributos que se usarán: 22

| Nombre                | Descripción                                                                                                                                     | Tipo de Dato       |
|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|--------------------|
| ID                    | Es el identificador único del reporte.                                                                                                          | BIGINT          |
| Case Number           | El número de división de registros del Departamento de Policía de Chicago, que es exclusivo del incidente.                                     | VARCHAR            |
| Date                  | Fecha en que ocurrió el incidente                                                                                                               | TEXT               |
| Block                 | La dirección parcialmente redactada donde ocurrió el incidente, colocándola en el mismo bloque que la dirección real.                          | VARCHAR            |
| IUCR                  | El código uniforme de denuncia de delitos de Illinois. Esto está directamente relacionado con el tipo principal y la descripción.              | VARCHAR            |
| Primary Type          | La descripción principal del código IUCR.                                                                                                       | VARCHAR            |
| Description           | La descripción secundaria del código IUCR, una subcategoría de la descripción primaria.                                                         | VARCHAR            |
| Location Description  | Descripción del lugar donde ocurrió el incidente.                                                                                               | VARCHAR            |
| Arrest                | Indica si se realizó un arresto.                                                                                                                | BOOLEAN            |
| Domestic              | Indica si el incidente estuvo relacionado con el hogar según lo define la Ley de Violencia Doméstica de Illinois.                              | BOOLEAN            |
| Beat                  | Indica donde ocurrió el incidente. Un beat es el área geográfica policial más pequeña.                                                          | BIGINT             |
| District              | Indica el distrito policial donde ocurrió el incidente.                                                                                         | BIGINT             |
| Community Area        | Indica el área comunitaria donde ocurrió el incidente. Chicago tiene 77 áreas comunitarias.                                                     | BIGINT             |
| FBI Code              | Indica la clasificación de delitos como se describe en el Sistema Nacional de Informes Basados en Incidentes del FBI.                          | VARCHAR            |
| X Coordinate          | La coordenada x del lugar donde ocurrió el incidente.                                                                                           | BIGINT             |
| Y Coordinate          | La coordenada y del lugar donde ocurrió el incidente.                                                                                           | BIGINT             |
| Year                  | Año en el que ocurrió el incidente.                                                                                                             | BIGINT             |
| Updated On            | Día en el que se actualizó el reporte.                                                                                                          | VARCHAR            |
| Latitude              | La latitud del lugar donde ocurrió el incidente.                                                                                                | DOUBLE PRECISION   |
| Longitude             | La longitud del lugar donde ocurrió el incidente.                                                                                               | DOUBLE PRECISION   |
| Location              | La ubicación donde ocurrió el incidente en un formato que permita la creación de mapas y otras operaciones geográficas en este portal de datos. | VARCHAR            |


El objetivo de nuestro equipo es identificar patrones en la incidencia delictiva en Chicago mediante el estudio de variables como ubicación, tipo de crimen y evolución temporal. El equipo utilizará el set de datos para analizar tendencias delictivas en distintas áreas comunitarias y distritos policiales, evaluar la relación entre la ubicación y el tipo de delito, examinar la frecuencia de arrestos y detectar cambios temporales en la criminalidad. Con esta información, podremos determinar estrategias potenciales para reducir el crimen en Chicago.
	Trabajar con datos tan delicados así como lo es la criminalidad en una ciudad conlleva a una gran responsabilidad de no utilizar ninguna información que obtengamos de trabajar los datos para perjudicar a alguien. Además, debemos de reconocer nuestras fuentes de información y no presentarla como propia. 

Cómo cargar los datos

En primer lugar, necesitamos obtener los datos. Estos se encuentran disponibles a través del siguiente enlace del portal de la ciudad de Chicago:
https://data.cityofchicago.org/Public-Safety/Crimes-2021/dwme-t96c/about_data

Para descargarlos, haz clic en el botón blanco con texto azul ubicado en la esquina superior derecha que dice "Export". Posteriormente, selecciona el formato CSV (comma separated values).

Una vez descargado el archivo, será necesario crear una nueva base de datos en SQL Shell (psql). Esto se hace con el siguiente comando:

CREATE DATABASE nombre_de_la_base;
Reemplaza nombre_de_la_base con el nombre que desees darle. Después, conéctate a la base de datos usando:

\c nombre_de_la_base
A continuación, copia y pega el siguiente script para crear una tabla en SQL:
```sql
CREATE TABLE staging(id BIGINT PRIMARY KEY,
 case_number VARCHAR(200) NOT NULL,
 crime_date TEXT,
 block VARCHAR(200),
 iucr VARCHAR(10),
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
```

Por último, carga la información utilizando el siguiente comando en SQL Shell:

\copy staging(id, case_number, crime_date, block, iucr, primary_type, description, location_description, arrest, domestic, beat, district, ward, community_area, fbi_code, x_coordinate, y_coordinate, year, updated_on, latitude, longitude, location) FROM '/.../Crimes_-_2021_20250416.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

Es importante tener en cuenta que el texto dentro de las comillas simples ('...') corresponde a la ruta completa del archivo .csv. Esta ruta varía según la computadora. En Windows, una forma de obtenerla es haciendo clic derecho sobre el archivo y seleccionando “Copiar como ruta”. Además, recuerda que en SQL, los caracteres \ deben ser reemplazados por /.

Una vez realizado este proceso, los datos estarán correctamente cargados en la base de datos. El siguiente paso será abrirla con un entorno de desarrollo para SQL; en este caso, utilizaremos TablePlus.

Por último, realizamos una modificación a la tabla para convertir crime_date a un timestamp. Dicha modificación se hace ejecutando el siguiente código:

ALTER TABLE staging ADD COLUMN crime_timestamp TIMESTAMP;

UPDATE staging
SET crime_timestamp = TO_TIMESTAMP(crime_date, 'MM/DD/YYYY HH12:MI:SS AM');

ALTER TABLE staging DROP COLUMN crime_date;

ALTER TABLE staging RENAME COLUMN crime_timestamp TO crime_date;

# Parte C: Limpieza de Datos

Para garantizar la calidad del dataset y su adecuación al objetivo del proyecto, se llevaron a cabo las siguientes tareas de limpieza y validación sobre la tabla `staging`.

---

## 1. Respaldo del dataset original

Antes de cualquier modificación, se creó un respaldo completo de la tabla original:

```sql
CREATE TABLE staging_backup AS
SELECT * FROM staging;
```

**Justificación**: Esta medida preventiva permite recuperar el estado inicial de los datos ante cualquier error o necesidad de comparación futura.

---

## 2. Eliminación de duplicados por `case_number`

Se identificaron múltiples registros con el mismo `case_number`, lo cual indica duplicación lógica de eventos. Se utilizó una CTE con `ROW_NUMBER()` para conservar una sola fila por `case_number`, seleccionando aquella con menor `id`. Esta operación generó una versión limpia de la tabla:

```sql
CREATE TABLE staging_cleaned AS
WITH ranked_cases AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY case_number ORDER BY id) AS rn
  FROM staging
)
SELECT * FROM ranked_cases
WHERE rn = 1;
```

Además, se eliminó directamente de `staging` cualquier fila duplicada:

```sql
WITH ranked_cases AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY case_number ORDER BY id) AS rn
  FROM staging
)
DELETE FROM staging
WHERE id IN (
  SELECT id FROM ranked_cases WHERE rn > 1
);
```

**Justificación**: `case_number` debe ser un identificador único de caso; su duplicación puede distorsionar análisis agregados y espaciales.

---

## 3. Revisión de consistencia en `primary_type`

Se inspeccionaron los valores de la columna `primary_type` en busca de inconsistencias por capitalización o espacios.  
**Resultado**: No se encontraron inconsistencias. Todos los valores estaban correctamente formateados.

**Justificación**: Evita que valores como “THEFT”, “theft” y “ THEFT” se traten como diferentes, lo cual fragmentaría el análisis.

---

## 4. Revisión de columnas geográficas (`x/y_coordinate` vs `latitude/longitude`)

Se identificaron combinaciones de `x_coordinate` y `y_coordinate` que estuvieran asociadas a más de un par `latitude`/`longitude`:

```sql
SELECT x_coordinate, y_coordinate,
       COUNT(DISTINCT latitude), COUNT(DISTINCT longitude)
FROM staging
GROUP BY x_coordinate, y_coordinate
HAVING COUNT(DISTINCT latitude) > 1 OR COUNT(DISTINCT longitude) > 1;
```

**Resultado**: No se encontraron inconsistencias. Cada par (`x_coordinate`, `y_coordinate`) está asociado a un único par (`latitude`, `longitude`).

**Justificación**: Esta verificación garantiza la coherencia espacial del dataset para su uso en mapas, visualizaciones geográficas y análisis espaciales de crimen.

---

## 5. Conteo de valores nulos

Se identificó la cantidad de valores nulos por columna:

```sql
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
```

**Resultado**:
- `location_description`: 1,258 valores nulos  
- `latitude`, `longitude`, `x_coordinate`, `y_coordinate`, `location`: 6,604 valores nulos cada una

**Justificación**: Es necesario evaluar la completitud de los datos antes de construir modelos o visualizaciones. Aún no se imputaron valores.

---

## 6. Verificación de inconsistencias en la codificación `fbi_code`

Se identificaron combinaciones de `primary_type` y `description` con más de un código `fbi_code`:

```sql
SELECT primary_type, description, COUNT(DISTINCT fbi_code) AS distinct_fbi_codes
FROM staging
GROUP BY primary_type, description
HAVING COUNT(DISTINCT fbi_code) > 1;
```

Se revisó el caso específico de:

```sql
SELECT primary_type, description, fbi_code, COUNT(*) AS occurrences
FROM staging
WHERE primary_type = 'DECEPTIVE PRACTICE'
  AND description = 'UNAUTHORIZED VIDEOTAPING'
GROUP BY primary_type, description, fbi_code;
```

**Resultado**:
- `'fbi_code' = '11'`: 42 veces  
- `'fbi_code' = '17'`: 1 vez

Se unificó a `'fbi_code' = '11'`:

```sql
UPDATE staging
SET fbi_code = '11'
WHERE primary_type = 'DECEPTIVE PRACTICE'
  AND description = 'UNAUTHORIZED VIDEOTAPING'
  AND fbi_code = '17';
```

**Justificación**: Cada combinación (`primary_type`, `description`) debe tener un solo `fbi_code` asociado para mantener integridad semántica y facilitar la normalización en `crime_codes`.

---

## 7. Evaluación de ambigüedad en códigos `iucr`

Se evaluó cuántos tipos y descripciones distintas tenía cada `iucr`:

```sql
SELECT 
    iucr,
    COUNT(*) AS total_ocurrencias,
    COUNT(DISTINCT primary_type) AS tipos_distintos,
    COUNT(DISTINCT description) AS descripciones_distintas,
    COUNT(DISTINCT fbi_code) AS codigos_fbi_distintos
FROM staging
GROUP BY iucr
ORDER BY tipos_distintos DESC, descripciones_distintas DESC;
```

**Resultado**: Algunos `iucr` tenían múltiples combinaciones, lo cual sugiere ambigüedad.

**Justificación**: Cada `iucr` debería estar vinculado a una sola combinación semántica para ser clave primaria en `crime_codes`.

---

## 8. Validación de combinaciones únicas `iucr`, `primary_type`, `description`, `fbi_code`

Se revisaron todas las combinaciones posibles de esas cuatro columnas:

```sql
SELECT 
    iucr, primary_type, description, fbi_code, COUNT(*) AS ocurrencias
FROM staging
GROUP BY iucr, primary_type, description, fbi_code
ORDER BY iucr, ocurrencias DESC;
```

**Justificación**: Validar la unicidad de estas combinaciones asegura la correcta construcción de relaciones en una base de datos normalizada.

---

## Conclusión

La limpieza del dataset fue cuidadosa, sistemática y no destructiva. Se crearon respaldos y versiones limpias, se eliminaron duplicados, se evaluó la integridad espacial y semántica de los datos, y se corrigieron inconsistencias relevantes. El dataset quedó listo para análisis exploratorios, modelado, y diseño de una base de datos relacional normalizada.
⸻

# D: Normalización


Este proyecto implementa un modelo relacional normalizado a partir de una tabla original de crímenes (`staging`). El objetivo fue eliminar redundancias, asegurar integridad referencial y cumplir con las formas normales hasta 4NF.

---

## Dependencias Funcionales

### `crime_codes`
```
iucr → primary_type, description, fbi_code
```

### `blocks`
```
id → block  
block → id
```

### `locations_descriptions`
```
id → location_description  
location_description → id
```

### `coordinates`
```
id → x_coordinate, y_coordinate, latitude, longitude, location  
(x_coordinate, y_coordinate, latitude, longitude, location) → id
```

### `locations`
```
id → block_id, description_id, coordinate_id  
(block_id, description_id, coordinate_id) → id
```

### `crimes`
```
id → case_number, crime_date, iucr, location_id, arrest, domestic, beat, district, ward, community_area, year, updated_on  
(case_number, crime_date, iucr, location_id) → id
```

---

## Dependencias Multivaluadas

No existen dependencias multivaluadas en el esquema final. Cada tabla representa una sola entidad o relación, y ha sido descompuesta correctamente hasta alcanzar la **Cuarta Forma Normal (4NF)**, eliminando cualquier repetición independiente de datos.

---

## Proceso de Normalización

### Etapa Inicial (Tabla `staging`)

La tabla original contenía múltiples redundancias, como:

- Repetición innecesaria de los mismos `iucr`, `primary_type`, `description` y `fbi_code`.
- Información duplicada de bloques (`block`), descripciones (`location_description`) y coordenadas.
- Violaciones a 2NF y 3NF por dependencias funcionales parciales y transitivas.

### Objetivo

Reducir redundancia, evitar anomalías de actualización/eliminación, y mejorar el rendimiento y la integridad del sistema mediante un modelo 100% normalizado.

---

## Formas Normales Alcanzadas

### 1NF (Primera Forma Normal)
- Todos los atributos son atómicos.
- No existen listas ni estructuras anidadas.

### 2NF (Segunda Forma Normal)
- Eliminadas dependencias parciales creando tablas independientes para `crime_codes`, `blocks`, `coordinates`, etc.

### 3NF (Tercera Forma Normal)
- Cada campo no clave depende únicamente de la clave primaria.
- Eliminadas todas las dependencias transitivas.

### BCNF (Forma Normal de Boyce-Codd)
- Todos los determinantes en las dependencias funcionales son claves candidatas.

### 4NF (Cuarta Forma Normal)
- No hay dependencias multivaluadas.
- Relaciones independientes se descompusieron en tablas separadas como `locations`.

---

## Justificación del Modelo

Este modelo relacional permite:

- Reutilización eficiente de descripciones, coordenadas y códigos sin redundancia.
- Mantenimiento sencillo gracias a claves foráneas con `ON DELETE CASCADE`.
- Escalabilidad a grandes volúmenes de datos sin pérdida de integridad.
- Extensibilidad futura (por ejemplo, incluir víctimas, armas, zonas o categorías de delito).

---

## Estructura de Tablas

```sql
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
```

---

## Proceso de Población de Datos

```sql
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
    TO_TIMESTAMP(s.updated_on, 'MM/DD/YYYY HH12:MI:SS AM') -- Adjust format as needed
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
```

---

