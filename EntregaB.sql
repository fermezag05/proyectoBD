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

-- Mínimos, máximos y promedios de valores numéricos

-- Duplicados en atributos categóricos

-- Columnas redundantes

--Conteo de tuplas por cada categoría

--Conteo de valores nulos

--¿Existen inconsistencias en el set de datos?




