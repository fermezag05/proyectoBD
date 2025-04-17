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
Numerical
Case Number
El número de división de registros del Departamento de Policía de Chicago, que es exclusivo del incidente.


Text
Date
Fecha en que ocurrió el incidente
Time Stamp
Block
La dirección parcialmente redactada donde ocurrió el incidente, colocándola en el mismo bloque que la dirección real.
Text
IUCR
El código uniforme de denuncia de delitos de Illinois. Esto está directamente relacionado con el tipo principal y la descripción.
Text
Primary Type
La descripción principal del código IUCR.
Text
Description
La descripción secundaria del código IUCR, una subcategoría de la descripción primaria.
Text
Location Description
Descripción del lugar donde ocurrió el incidente.
Text
Arrest
Indica si se realizó un arresto.
Boolean
Domestic
Indica si el incidente estuvo relacionado con el hogar según lo define la Ley de Violencia Doméstica de Illinois.
Boolean
Beat (smallest police geographic area)
Indica donde ocurrió el incidente. Un beat es el área geográfica policial más pequeña.
Text
District
Indica el distrito policial donde ocurrió el incidente.
Text
Community Area
Indica el área comunitaria donde ocurrió el incidente. Chicago tiene 77 áreas comunitarias.
Text
FBI Code
Indica la clasificación de delitos como se describe en el Sistema Nacional de Informes Basados ​​en Incidentes del FBI.
Text
X Coordinate
La coordenada x del lugar donde ocurrió el incidente.
Number
Y Coordinate
La coordenada y del lugar donde ocurrió el incidente.
Number
Year
Año en el que ocurrió el incidente.
Number
Updated On
Día en el que se actualizó el reporte.
Time Stamp
Latitude
La latitud del lugar donde ocurrió el incidente.
Number
Longitude
La longitud del lugar donde ocurrió el incidente.
Number
Location
La ubicación donde ocurrió el incidente en un formato que permita la creación de mapas y otras operaciones geográficas en este portal de datos.
Point



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

CREATE TABLE staging (
    id INTEGER,
    case_number TEXT,
    crime_date TEXT,
    block TEXT,
    iucr TEXT,
    primary_type TEXT,
    description TEXT,
    location_description TEXT,
    arrest BOOLEAN,
    domestic BOOLEAN,
    beat INTEGER,
    district INTEGER,
    ward INTEGER,
    community_area INTEGER,
    fbi_code TEXT,
    x_coordinate INTEGER,
    y_coordinate INTEGER,
    year INTEGER,
    updated_on TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location TEXT
);
Por último, carga la información utilizando el siguiente comando en SQL Shell:

\copy staging(id, case_number, crime_date, block, iucr, primary_type, description, location_description, arrest, domestic, beat, district, ward, community_area, fbi_code, x_coordinate, y_coordinate, year, updated_on, latitude, longitude, location) FROM '/.../Crimes_-_2021_20250416.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
Es importante tener en cuenta que el texto dentro de las comillas simples ('...') corresponde a la ruta completa del archivo .csv. Esta ruta varía según la computadora. En Windows, una forma de obtenerla es haciendo clic derecho sobre el archivo y seleccionando “Copiar como ruta”. Además, recuerda que en SQL, los caracteres \ deben ser reemplazados por /.

Una vez realizado este proceso, los datos estarán correctamente cargados en la base de datos. El siguiente paso será abrirla con un entorno de desarrollo para SQL; en este caso, utilizaremos TablePlus.



Parte C: 

# Proyecto de Análisis de Crímenes

El objetivo general es analizar patrones de crimen (temporales, geográficos, por tipo) en el área cubierta por los datos. La limpieza debe facilitar este análisis asegurando datos precisos, consistentes y completos en la medida de lo posible.

## Limpieza de Datos

Para asegurar la calidad y fiabilidad de los datos utilizados en este análisis, se llevó a cabo un proceso de limpieza sobre el dataset original (`Crimes_-_2021_20250416.csv`) cargado en la tabla `staging` de PostgreSQL. El objetivo de la limpieza fue [Reitera tu objetivo, ej: preparar los datos para análisis espacio-temporal de patrones delictivos].

Las siguientes actividades de limpieza fueron realizadas mediante el script `scripts/clean_data.sql`:

1.  **Corrección de Tipos de Datos:**
    * Se ajustaron los tipos de datos de columnas clave como `"Date"`, `"Updated On"` (a `TIMESTAMP`), `"Arrest"`, `"Domestic"` (a `BOOLEAN`), `"Latitude"`, `"Longitude"` (a `NUMERIC`), etc., para permitir operaciones válidas.
    * *Justificación:* Necesario para cálculos temporales, lógicos, numéricos y geoespaciales precisos.

2.  **Estandarización de Datos Categóricos:**
    * Se eliminaron espacios iniciales/finales y se convirtió a mayúsculas el contenido de columnas como `"Primary Type"`, `"Location Description"`, `"Description"`.
    * *Justificación:* Unifica categorías que difieren solo por formato, permitiendo agrupaciones correctas.

3.  **Manejo de Valores Nulos:**
    * Los `NULL` en `"Location Description"` se reemplazaron por `'UNKNOWN'`.
    * [Describe cómo manejaste otros NULLs importantes, ej: Se eliminaron X filas (Y%) con `"Latitude"` o `"Longitude"` nulos].
    * *Justificación:* Se optó por [preservar filas / eliminar filas / imputar] para [balancear completitud vs precisión / asegurar validez de análisis clave como el espacial].

4.  **Resolución de `"Case Number"` Duplicados:**
    * Se identificaron múltiples registros con el mismo `"Case Number"`. Tras investigar, se observó que [explica brevemente qué representaban los duplicados, ej: parecían ser actualizaciones del mismo caso].
    * Se implementó una estrategia para conservar únicamente el registro más reciente para cada `"Case Number"`, basado en la columna `"Updated On"`. Ver el script para la query exacta (`DELETE` con `DISTINCT ON`).
    * *Justificación:* Asegura que cada incidente esté representado una sola vez (o por su estado más actual), evitando sobreestimaciones y permitiendo análisis a nivel de incidente.

5.  **Validación y Corrección de Fechas:**
    * Se corrigieron los registros donde `"Updated On"` era anterior a `"Date"`, igualando `"Updated On"` a `"Date"`.
    * *Justificación:* Corrige una inconsistencia lógica fundamental para el análisis temporal.

6.  **Validación de Coordenadas Geográficas:**
    * Se identificaron y se establecieron como `NULL` las coordenadas (`"Latitude"`, `"Longitude"`) que caían fuera del rango geográfico esperado para [Tu Área].
    * *Justificación:* Elimina datos de ubicación claramente erróneos que invalidarían análisis espaciales.

7.  **[Incluir cualquier otra limpieza realizada, como eliminación de columnas]**

El script `scripts/clean_data.sql` contiene las operaciones SQL exactas utilizadas. Se recomienda ejecutarlo sobre los datos en bruto cargados en la tabla `staging`.
