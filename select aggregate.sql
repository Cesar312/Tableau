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
