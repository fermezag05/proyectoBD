---1
SELECT
  DATE_PART('hour', crime_date) AS hora,
  COUNT(*) AS total_incidentes
FROM crimes
GROUP BY hora
ORDER BY hora;
--2
SELECT
  CASE EXTRACT(DOW FROM crime_date)
    WHEN 0 THEN 'Domingo'
    WHEN 1 THEN 'Lunes'
    WHEN 2 THEN 'Martes'
    WHEN 3 THEN 'Miércoles'
    WHEN 4 THEN 'Jueves'
    WHEN 5 THEN 'Viernes'
    WHEN 6 THEN 'Sábado'
  END AS dia_semana,
  COUNT(*) AS total_incidentes
FROM crimes
GROUP BY EXTRACT(DOW FROM crime_date)
ORDER BY EXTRACT(DOW FROM crime_date);
---3
SELECT
  cc.primary_type,
  ROUND(
    100.0 * SUM(CASE WHEN c.arrest THEN 1 ELSE 0 END) / COUNT(*),
    2
  ) AS tasa_arresto_pct
FROM crimes c
JOIN crime_codes cc ON c.iucr = cc.iucr
GROUP BY cc.primary_type
ORDER BY tasa_arresto_pct DESC;
---4
SELECT
  c."year",
  COUNT(*) AS total_crimes,
  ROUND(
    100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
    2
  ) AS pct_sobre_total
FROM crimes c
GROUP BY c."year"
ORDER BY c."year";
---5
SELECT
  c.community_area,
  COUNT(*) FILTER (WHERE c.domestic) AS domesticos,
  COUNT(*) FILTER (WHERE NOT c.domestic) AS no_domesticos,
  ROUND(
    100.0 * COUNT(*) FILTER (WHERE c.domestic) / COUNT(*),
    2
  ) AS pct_domesticos
FROM crimes c
GROUP BY c.community_area
ORDER BY pct_domesticos DESC
LIMIT 10;
---6
SELECT
  DATE_TRUNC('month', crime_date) AS mes,
  COUNT(*) AS mensual,
  SUM(COUNT(*)) OVER (ORDER BY DATE_TRUNC('month', crime_date)) AS acumulado
FROM crimes
GROUP BY mes
ORDER BY mes;
--7 

SELECT crimes.id, coordinates.latitude, coordinates.longitude
FROM crimes
LEFT JOIN locations ON locations.id = crimes.location_id
LEFT JOIN coordinates ON coordinates.id = locations.coordinate_id
WHERE coordinates.latitude IS NOT NULL AND coordinates.longitude IS NOT NULL;

