# proyectoBD
Proyecto Bases de Datos

PROYECTO EQUIPO 3

Nuestros datos contienen información sobre los crímenes que se han cometido en la ciudad de Chichado a partir del 2021. Estos datos incluyen información relevante sobre los crímenes, así como: fecha, tipo de crimen, si sucede un arresto, ubicación del crimen y más. Los datos fueron extraídos del Chicago Data Portal.
	Nuestros datos son recolectados por el sistema CLEAR (Citizen Law Enforcement Analysis and Reporting) del departamento de policía de Chicago. El propósito de la recolección de estos datos es para mantener un registro sobre los crímenes que ocurren en la ciudad de Chicago. Los datos se pueden obtener en el Chicago Data Portal: https://data.cityofchicago.org/Public-Safety/Crimes-2021/dwme-t96c/about_data
Los datos se actualizan de manera diaria, permitiéndonos utilizar datos sobre crímenes muy recientes (se bajó el csv de la última actualización de la base de datos el día 16 de Abril del 2025). 

Información sobre la base de datos:
Número de tuplas: 209,000
Número de atributos que se usarán: 22

Atributo
Descripción
Tipo
ID
Es el identificador único del reporte.
Bigserial
  Case Number
El número de división de registros del Departamento de Policía de Chicago, que es exclusivo del incidente.
VARCHAR
  Date
Fecha en que ocurrió el incidente
TEXT
  Block
La dirección parcialmente redactada donde ocurrió el incidente, colocándola en el mismo bloque que la dirección real.
VARCHAR
  IUCR
El código uniforme de denuncia de delitos de Illinois. Esto está directamente relacionado con el tipo principal y la descripción.
VARCHAR
  Primary Type
La descripción principal del código IUCR.
VARCHAR
  Description
La descripción secundaria del código IUCR, una subcategoría de la descripción primaria.
VARCHAR
  Location Description
Descripción del lugar donde ocurrió el incidente.
VARCHAR
  Arrest
Indica si se realizó un arresto.
BOOLEAN
  Domestic
Indica si el incidente estuvo relacionado con el hogar según lo define la Ley de Violencia Doméstica de Illinois.
BOOLEAN
  Beat (smallest police geographic area)
Indica donde ocurrió el incidente. Un beat es el área geográfica policial más pequeña.
BIGINT
  District
Indica el distrito policial donde ocurrió el incidente.
BIGINT
  Community Area
Indica el área comunitaria donde ocurrió el incidente. Chicago tiene 77 áreas comunitarias.
BIGINT
  FBI Code
Indica la clasificación de delitos como se describe en el Sistema Nacional de Informes Basados ​​en Incidentes del FBI.
VARCHAR
  X Coordinate
La coordenada x del lugar donde ocurrió el incidente.
BIGINT
  Y Coordinate
La coordenada y del lugar donde ocurrió el incidente.
BIGINT
  Year
Año en el que ocurrió el incidente.
BIGINT
  Updated On
Día en el que se actualizó el reporte.
VARCHAR
  Latitude
La latitud del lugar donde ocurrió el incidente.
DOUBLE PRECISION
  Longitude
La longitud del lugar donde ocurrió el incidente.
DOUBLE PRECISION
  Location
La ubicación donde ocurrió el incidente en un formato que permita la creación de mapas y otras operaciones geográficas en este portal de datos.
VARCHAR


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


Por último, carga la información utilizando el siguiente comando en SQL Shell:

\copy staging(id, case_number, crime_date, block, iucr, primary_type, description, location_description, arrest, domestic, beat, district, ward, community_area, fbi_code, x_coordinate, y_coordinate, year, updated_on, latitude, longitude, location) FROM '/.../Crimes_-_2021_20250416.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
Es importante tener en cuenta que el texto dentro de las comillas simples ('...') corresponde a la ruta completa del archivo .csv. Esta ruta varía según la computadora. En Windows, una forma de obtenerla es haciendo clic derecho sobre el archivo y seleccionando “Copiar como ruta”. Además, recuerda que en SQL, los caracteres \ deben ser reemplazados por /.

Una vez realizado este proceso, los datos estarán correctamente cargados en la base de datos. El siguiente paso será abrirla con un entorno de desarrollo para SQL; en este caso, utilizaremos TablePlus.



Parte C: 
Limpieza de Datos

Para garantizar la calidad del dataset y asegurar su adecuación al objetivo del proyecto, se llevaron a cabo las siguientes tareas de limpieza y validación sobre la tabla staging:

1. Eliminación de duplicados por case_number

Se identificaron múltiples registros con el mismo case_number, lo cual indica duplicación lógica de eventos. Antes de la eliminación, se revisaron las tuplas que compartían el mismo case number para afirmar que compartían datos.
Se utilizó una CTE con ROW_NUMBER() para conservar una sola fila por case_number, seleccionando la de menor id.

Esta operación no fue destructiva: se creó un respaldo (staging_backup) y una tabla limpia (staging_cleaned).

Justificación:
case_number debe ser un identificador único de caso; su duplicación puede distorsionar análisis agregados y espaciales.

⸻

2. Verificación de inconsistencias en primary_type

Se revisó si existían valores con capitalización inconsistente o espacios al inicio o final de la cadena.
Resultado: no se encontraron inconsistencias. Todos los valores en primary_type están correctamente formateados.

Justificación:
Este paso garantiza que categorías como “THEFT”, “theft” o “ THEFT” no se traten como valores distintos, lo cual fragmentaría los análisis por tipo de crimen.

⸻

3. Revisión de columnas geográficas (x/y_coordinate vs latitude/longitude)

Se validó que una misma combinación de x_coordinate y y_coordinate no tuviera múltiples pares latitude/longitude.
Resultado: no se encontraron inconsistencias en las coordenadas geográficas.

Justificación:
Esta verificación garantiza la coherencia espacial de los datos para su uso en mapas o análisis de localización.

⸻

4. Conteo de valores nulos

Se identificó la cantidad de valores nulos por columna. Los hallazgos más relevantes fueron:
	•	arrest: 1,258 valores nulos
	•	latitude, longitude y location: 6,604 valores nulos cada uno

Justificación:
Esta revisión permite evaluar la completitud de los datos antes de entrenar modelos o construir visualizaciones.
No se imputaron valores por ahora, pero se considera relevante en futuras etapas del proyecto.

⸻

5. Análisis de frecuencia en variables categóricas

Se generaron conteos por las siguientes variables categóricas:
	•	primary_type
	•	location_description
	•	arrest
	•	domestic

Justificación:
Este paso facilitó la exploración inicial del dataset y la detección de posibles sesgos o categorías predominantes.

⸻

Conclusión

La limpieza del dataset fue cuidadosa y no destructiva.
Se documentaron todos los pasos y se dejaron versiones limpias y respaldadas para futuros análisis.
El dataset quedó listo para ser utilizado de forma confiable en las siguientes etapas del proyecto.
