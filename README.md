# proyectoBD
Proyecto Bases de Datos

PROYECTO EQUIPO 3

Nuestros datos contienen información sobre los crímenes que se han cometido en la ciudad de Chichado a partir del 2021. Estos datos incluyen información relevante sobre los crímenes, así como: fecha, tipo de crimen, si sucede un arresto, ubicación del crimen y más. Los datos fueron extraídos del Chicago Data Portal.
	Nuestros datos son recolectados por el sistema CLEAR (Citizen Law Enforcement Analysis and Reporting) del departamento de policía de Chicago. El propósito de la recolección de estos datos es para mantener un registro sobre los crímenes que ocurren en la ciudad de Chicago. Los datos se pueden obtener en el Chicago Data Portal: https://data.cityofchicago.org/Public-Safety/Crimes-2021/dwme-t96c/about_data
Los datos se actualizan de manera diaria, permitiéndonos utilizar datos sobre crímenes muy recientes (se bajó el csv de la última actualización de la base de datos el día 14 de Febrero del 2025). 

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
