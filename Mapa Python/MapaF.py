import pandas as pd
import geopandas as gpd
from shapely.geometry import Point
import plotly.express as px
from sqlalchemy import create_engine
import json

# --- 1. Connect to PostgreSQL using SQLAlchemy (Removes warning) ---
engine = create_engine('postgresql+psycopg2://postgres:1710@localhost/proyecto')

query = """
SELECT crimes.id, coordinates.latitude, coordinates.longitude
FROM crimes
LEFT JOIN locations ON locations.id = crimes.location_id
LEFT JOIN coordinates ON coordinates.id = locations.coordinate_id
WHERE coordinates.latitude IS NOT NULL AND coordinates.longitude IS NOT NULL;
"""
crimes_df = pd.read_sql(query, engine)

# --- 2. Convert to GeoDataFrame ---
geometry = [Point(xy) for xy in zip(crimes_df['longitude'], crimes_df['latitude'])]
crimes_gdf = gpd.GeoDataFrame(crimes_df, geometry=geometry, crs="EPSG:4326")

# --- 3. Load Police Districts Shapefile ---
districts = gpd.read_file("/Users/jorgepuszkar/ProyectoBas/PoliceDistrict/PoliceDistrict.shp")

# --- 4. Reproject both to EPSG:4326 if needed ---
if str(districts.crs) != "EPSG:4326":
    districts = districts.to_crs("EPSG:4326")

# --- 5. Spatial join to assign crimes to districts ---
crimes_gdf = crimes_gdf.to_crs(districts.crs)
crimes_with_districts = gpd.sjoin(crimes_gdf, districts, how="inner", predicate="within")

# --- 6. Check columns for grouping ---
print("\nDISTRICTS DATA SAMPLE COLUMNS:", districts.columns)
print("\nCRIMES WITH DISTRICTS SAMPLE COLUMNS:", crimes_with_districts.columns)

# --- 7. Count crimes per district ---
crime_counts = crimes_with_districts.groupby('DIST_NUM').size().reset_index(name='crime_count')
districts = districts.merge(crime_counts, on='DIST_NUM', how='left')
districts['crime_count'] = districts['crime_count'].fillna(0)

# --- 8. Diagnostic print to verify data ---
print("\nMERGED DISTRICTS DATA SAMPLE:")
print(districts[['DIST_NUM', 'DIST_LABEL', 'crime_count']].head())

# --- 9. Convert to GeoJSON ---
districts_json = json.loads(districts.to_json())

# --- 10. Verify GeoJSON keys ---
print("\nGEOJSON SAMPLE PROPERTIES:")
print(districts_json['features'][0]['properties'])

# --- 11. Plot Interactive Map with Hover ---
fig = px.choropleth_map(
    districts,
    geojson=districts_json,
    locations='DIST_NUM',
      color='crime_count',
    color_continuous_scale=px.colors.sequential.Reds,
    featureidkey="properties.DIST_NUM",  # Adjust if needed based on the diagnostic print
    center={"lat": 41.8781, "lon": -87.6298},
    zoom=9,
    opacity=0.6,
    hover_name='DIST_LABEL',
    hover_data={'DIST_NUM': True, 'crime_count': True}
)

fig.update_layout(title="Crime Count per Police District in Chicago", margin={"r":0,"t":0,"l":0,"b":0})
fig.show()