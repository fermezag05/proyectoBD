
## Parte A: Descripción del Proyecto

### Datos Utilizados

Nuestro dataset contiene información sobre los crímenes cometidos en la ciudad de Chicago a partir del año 2021. Estos datos incluyen variables relevantes como: fecha, tipo de crimen, si hubo arresto, ubicación y más.

- **Fuente de datos**: [Chicago Data Portal](https://data.cityofchicago.org/Public-Safety/Crimes-2021/dwme-t96c/about_data)
- **Sistema de recolección**: CLEAR (Citizen Law Enforcement Analysis and Reporting) del Departamento de Policía de Chicago
- **Fecha de descarga del CSV**: 14 de febrero de 2025
- **Número de tuplas**: 209,000
- **Número de atributos utilizados**: 22

### Atributos del Dataset

| Atributo              | Descripción                                                                                         | Tipo         |
|-----------------------|-----------------------------------------------------------------------------------------------------|--------------|
| ID                    | Identificador único del reporte                                                                     | Numérico     |
| Case Number           | Número exclusivo del incidente del Departamento de Policía de Chicago                              | Texto        |
| Date                  | Fecha del incidente                                                                                 | Timestamp    |
| Block                 | Dirección parcialmente redactada donde ocurrió el incidente                                         | Texto        |
| IUCR                  | Código uniforme de denuncia de delitos de Illinois                                                  | Texto        |
| Primary Type          | Descripción principal del código IUCR                                                               | Texto        |
| Description           | Subcategoría de la descripción principal                                                            | Texto        |
| Location Description  | Descripción del lugar del incidente                                                                 | Texto        |
| Arrest                | Indica si hubo arresto                                                                              | Booleano     |
| Domestic              | Indica si estuvo relacionado con violencia doméstica                                                | Booleano     |
| Beat                  | Área geográfica policial más pequeña donde ocurrió el incidente                                     | Texto        |
| District              | Distrito policial del incidente                                                                     | Texto        |
| Community Area        | Área comunitaria donde ocurrió el incidente (Chicago tiene 77)                                      | Texto        |
| FBI Code              | Clasificación de delitos según el FBI                                                               | Texto        |
| X Coordinate          | Coordenada X del lugar del incidente                                                                | Numérico     |
| Y Coordinate          | Coordenada Y del lugar del incidente                                                                | Numérico     |
| Year                  | Año del incidente                                                                                   | Numérico     |
| Updated On            | Día en que se actualizó el reporte                                                                  | Timestamp    |
| Latitude              | Latitud del lugar del incidente                                                                     | Numérico     |
| Longitude             | Longitud del lugar del incidente                                                                    | Numérico     |
| Location              | Ubicación en formato geográfico (para mapas y análisis espacial)                                    | Punto        |

### Objetivo del Proyecto

El objetivo del equipo es **identificar patrones en la incidencia delictiva en Chicago**, analizando:

- Tendencias delictivas en distintas áreas comunitarias y distritos policiales
- Relación entre ubicación y tipo de delito
- Frecuencia de arrestos
- Cambios temporales en la criminalidad

Esto permitirá **proponer estrategias para reducir el crimen** en la ciudad.

### Consideraciones Éticas

- Se debe mantener responsabilidad ética al trabajar con datos sensibles.
- No se utilizará la información para perjudicar a terceros.
- Se respetarán las fuentes originales de los datos y se dará el crédito correspondiente.
