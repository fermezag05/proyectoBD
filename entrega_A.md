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
| ID                    | Identificador único del reporte                                                                     | Numerical    |
| Case Number           | Número exclusivo del incidente del Departamento de Policía de Chicago                              | Text         |
| Date                  | Fecha del incidente                                                                                 | Timestamp    |
| Block                 | Dirección parcialmente redactada donde ocurrió el incidente                                         | Text         |
| IUCR                  | Código uniforme de denuncia de delitos de Illinois                                                  | Text         |
| Primary Type          | Descripción principal del código IUCR                                                               | Text         |
| Description           | Subcategoría de la descripción principal                                                            | Text         |
| Location Description  | Descripción del lugar del incidente                                                                 | Text         |
| Arrest                | Indica si hubo arresto                                                                              | Boolean      |
| Domestic              | Indica si estuvo relacionado con violencia doméstica                                                | Boolean      |
| Beat                  | Área geográfica policial más pequeña donde ocurrió el incidente                                     | Text         |
| District              | Distrito policial del incidente                                                                     | Text         |
| Community Area        | Área comunitaria donde ocurrió el incidente (Chicago tiene 77)                                      | Text         |
| FBI Code              | Clasificación de delitos según el FBI                                                               | Text         |
| X Coordinate          | Coordenada X del lugar del incidente                                                                | Number       |
| Y Coordinate          | Coordenada Y del lugar del incidente                                                                | Number       |
| Year                  | Año del incidente                                                                                   | Number       |
| Updated On            | Día en que se actualizó el reporte                                                                  | Timestamp    |
| Latitude              | Latitud del lugar del incidente                                                                     | Number       |
| Longitude             | Longitud del lugar del incidente                                                                    | Number       |
| Location              | Ubicación en formato geográfico (para mapas y análisis espacial)                                    | Point        |

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
