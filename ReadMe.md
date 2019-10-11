# Tableau Homework
## Citi Bike Analytics

Once the 2018 files were acquired from the [Citi Bike Data](https://www.citibikenyc.com/system-data) site, the data was then loaded to a data frame.

```python
path = r'data'
all_files = glob.glob(path + "/*.csv")

li = []

for filename in all_files:
    df_raw = pd.read_csv(filename, index_col=None, header=0)
    li.append(df_raw)

df = pd.concat(li, axis=0, ignore_index=True)
```

The data was exported to a CSV file and loaded to a PostgreSQL database to continue the ETL process. The following two queries were executed to finalize the data for Tableau:

```sql
 -- create table bikes to import the data from the data frame
 CREATE TABLE bikes

(
tripduration INT,
 starttime DATE,
 stoptime DATE,
 start_station_id INT,
 start_station_name TEXT,
 start_lat NUMERIC,
 start_lon NUMERIC,
 end_station_id INT,
 end_station_name TEXT,
 end_lat NUMERIC,
 end_lon NUMERIC,
 bikeid BIGINT,
 usertype TEXT,
 birth_year INT,
 gender INT
)

-- create table for Tableau, select query that aggragates the data
CREATE TABLE summary AS
SELECT
	CASE
		WHEN date_part('month', starttime) IN (3, 4, 5) THEN 'Spring'
		WHEN date_part('month', starttime) IN (6, 7, 8) THEN 'Summer'
		WHEN date_part('month', starttime) IN (9, 10, 11) THEN 'Fall'
		ELSE 'Winter' END AS season,
		usertype,
	CASE
		WHEN gender = 1 THEN 'Male'
		ELSE 'Female' END AS gender,
		start_station_name, start_station_id, start_lat, start_lon, end_station_name, end_station_id, end_lat, end_lon, (2 * 3961 * ASIN(SQRT((SIN(RADIANS((end_lat - start_lat) / 2))) ^ 2 + COS(RADIANS(start_lat)) * COS(RADIANS(end_lat)) * (sin(radians((end_lon - start_lon) / 2))) ^ 2))) AS distance, COUNT(record_id) AS count
FROM bikes

GROUP BY season, usertype, gender, start_station_name, start_station_id, start_lat, start_lon, end_station_name, end_station_id, end_lat, end_lon, distance
```

The Tableau visualizations were then created and focused on the following:
- listing the bike stations based on their starting_station_name and end_station_name along with an associated map that displays their location
- display the usertypes based on seasons, gender, total rides and average distance
- list the bike stations where the user started and end their trip at the same location

Observations were made and included within the [Tableau story](https://public.tableau.com/profile/cesar.martinez6494/views/Citibikes2018Summary).