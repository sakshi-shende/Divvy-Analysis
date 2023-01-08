#Create table trip to place the data from csv file
CREATE TABLE trip 
(number SMALLINT,
x SMALLINT, 
ride_id VARCHAR(50),
rideable_type VARCHAR(50), 
started_at DATETIME,
ended_at DATETIME,
start_station_name VARCHAR(50),
start_station_id INT,
end_station_name VARCHAR(50),
end_station_id INT, 
start_lat FLOAT, 
start_lng FLOAT, 
end_lat FLOAT, 
end_lng FLOAT,
member_casual VARCHAR(10), 
trip_duration_min FLOAT, 
year YEAR, 
month SMALLINT, 
date SMALLINT, 
location_start VARCHAR(100), 
location_end VARCHAR(100),
distance FLOAT);
 
#Create table population to place the data from csv file
CREATE TABLE population 
(year YEAR, 
ZIP INT, 
POP_10 INT(10), 
POP_20 INT(10), 
POP_30 INT(10), 
POP_40 INT(10), 
POP_50 INT(10), 
POP_60 INT(10), 
POP_70 INT(10), 
POP_80 INT(10));

#Create table station to place the data from csv file
CREATE TABLE station 
( number SMALLINT, 
new_one VARCHAR(50), 
station_name VARCHAR(50), 
timestamp DATETIME, 
address VARCHAR(10), 
total_docks SMALLINT, 
docks_in_service SMALLINT, 
docks_available SMALLINT, 
bikes_available SMALLINT, 
percent_full SMALLINT, 
status VARCHAR(15), 
latitude FLOAT, 
longitude FLOAT, 
location VARCHAR(50), 
zipcodes INT);

#Create table weather to place the data from csv file
CREATE TABLE weather 
(year YEAR, 
month SMALLINT, 
day SMALLINT, 
date DATE, 
temperature_max SMALLINT, 
temperature_min SMALLINT, 
temperature_avg FLOAT, 
temperature_dep FLOAT, 
hdd SMALLINT, 
cdd SMALLINT, 
precipitation FLOAT, 
new_snow FLOAT, 
snow FLOAT);

###Create normalized table and insert data from existing table ###
CREATE TABLE station_table 
(station_id INT NOT NULL AUTO_INCREMENT,
 station_name VARCHAR(45) NOT NULL, 
 latitude DOUBLE NOT NULL, 
 longitude DOUBLE NOT NULL, 
 zipcode INT NOT NULL, 
 total_docks INT NOT NULL, 
 docks_status VARCHAR(45) NOT NULL, 
 available_docks INT NOT NULL, 
 available_bikes INT NOT NULL, 
 docks_in_service INT NOT NULL, 
 percent_full FLOAT NOT NULL, 
 Primary Key (station_id));
 
 INSERT INTO station_table 
 (station_name, 
 latitude, 
 longitude, 
 zipcode, 
 total_docks, 
 docks_status, 
 available_docks, 
 available_bikes, 
 docks_in_service, 
 percent_full) SELECT station_name, 
 latitude, 
 longitude, 
 zipcodes, 
 total_docks, 
 status, 
 docks_available, 
 bikes_available, 
 docks_in_service, 
 percent_full from station;
 
CREATE TABLE ride_type_table 
(ride_type_id INT NOT NULL AUTO_INCREMENT, 
ride_type VARCHAR(50) NOT NULL, 
Primary Key(ride_type_id));

INSERT INTO ride_type_table 
(ride_type) 
SELECT DISTINCT rideable_type from trip;

CREATE TABLE member_type_table 
(member_type_id INT NOT NULL AUTO_INCREMENT, 
member_type VARCHAR(10) NOT NULL, 
PRIMARY KEY (member_type_id));

INSERT INTO member_type_table 
(member_type) SELECT DISTINCT member_casual from trip;

CREATE TABLE weather_table 
(weather_id INT NOT NULL AUTO_INCREMENT, 
date DATE NOT NULL, 
temp_max INT NOT NULL, 
temp_min INT NOT NULL, 
precipitation INT NOT NULL, 
snow_depth INT NOT NULL, 
PRIMARY KEY (weather_id));

INSERT INTO weather_table 
(date, temp_max, temp_min, precipitation, snow_depth) 
SELECT date, temperature_max, temperature_min, precipitation, new_snow from weather; 

CREATE TABLE trip_table 
(ride_id INT NOT NULL AUTO_INCREMENT, 
ride_type_id INT, 
rideable_type VARCHAR(50), 
starting_time DATETIME, 
ending_time DATETIME, 
start_station_id INT, 
start_station_name VARCHAR(50),  
end_station_id INT,  
end_station_name VARCHAR(50), 
member_type_id INT, 
member_casual VARCHAR(10), 
weather_id INT, 
PRIMARY KEY (ride_id));

INSERT INTO trip_table 
(rideable_type, 
starting_time, 
ending_time, 
start_station_name, 
end_station_name, 
member_casual) SELECT rideable_type,
 started_at, 
 ended_at, 
 start_station_name, 
 end_station_name, 
 member_casual from trip;
 
Update trip_table
set ride_type_id = CASE 
WHEN rideable_type = “electric_bike” then 1
WHEN rideable_type = “docked_bike” then 2
WHEN rideable_type = “classic_bike” then 3
end;

UPDATE trip_table t
INNER JOIN weather_table w ON DATE(t.starting_time) = w.date
SET t.weather_id = w.weather_id;

UPDATE trip_table
set member_type_id = CASE
WHEN member_casual = "casual" THEN 1
WHEN member_casual = "member" THEN 2
END;

UPDATE trip_table t
INNER JOIN station_table s ON t.start_station_name = s.station_name
SET t.start_station_id = s.station_id;

UPDATE trip_table t
INNER JOIN station_table s ON t.end_station_name = s. station_name
SET t.end_station_id = s.station_id;

ALTER TABLE trip
DROP COLUMN rideable_type,
DROP COLUMN start_station_name,
DROP COLUMN end_station_name,
DROP COLUMN member_casual;
