/* ASSIGNMENT - 2
https://drive.google.com/file/d/1XHk04JYacfXA5H-u6aYeiOZkvZZm7g0g/view
*/


CREATE SCHEMA ASSIGNMENT_2;

CREATE TABLE ACCIDENTS_2015 (
Accident_Index VARCHAR(255), Location_Easting_OSGR	VARCHAR(255), Location_Northing_OSGR	VARCHAR(255),
Longitude	VARCHAR(255), Latitude	VARCHAR(255), Police_Force	VARCHAR(255),
Accident_Severity	VARCHAR(255),
Number_of_Vehicles	VARCHAR(255),
Number_of_Casualties	VARCHAR(255),
`Date` VARCHAR(255), Day_of_Week	VARCHAR(255), `Time` VARCHAR(255),
Local_Authority_District	VARCHAR(255), Local_Authority_Highway	VARCHAR(255),
 `1st_Road_Class`	VARCHAR(255),
`1st_Road_Number`	VARCHAR(255), Road_Type	VARCHAR(255), Speed_limit	VARCHAR(255),
Junction_Detail	VARCHAR(255), Junction_Control	VARCHAR(255),
`2nd_Road_Class` VARCHAR(255), `2nd_Road_Number` VARCHAR(255),	`Pedestrian_Crossing-Human_Control` VARCHAR(255),
Pedestrian_Crossing_Physical_Facilities	VARCHAR(255),Light_Conditions	VARCHAR(255),
Weather_Conditions	VARCHAR(255),Road_Surface_Conditions	VARCHAR(255),
Special_Conditions_at_Site VARCHAR(255),	
arriageway_Hazards	VARCHAR(255),Urban_or_Rural_Area	VARCHAR(255),
Did_Police_Officer_Attend_Scene_of_Accident	VARCHAR(255),LSOA_of_Accident_Location VARCHAR(255));

LOAD DATA INFILE "D:/Ineuron_FSDA/SQL/Assignment_2_Datasets/Accidents_2015.csv"
INTO TABLE ACCIDENTS_2015
FIELDS TERMINATED  by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE VEHICLES_2015 ( 
Accident_Index VARCHAR(255),	Vehicle_Reference	VARCHAR(255), Vehicle_Type	VARCHAR(255),
Towing_and_Articulation	VARCHAR(255), Vehicle_Manoeuvre	VARCHAR(255), Vehicle_Location_Restricted_Lane	VARCHAR(255),
Junction_Location	VARCHAR(255), Skidding_and_Overturning	VARCHAR(255), Hit_Object_in_Carriageway	VARCHAR(255),
Vehicle_Leaving_Carriageway	VARCHAR(255), Hit_Object_off_Carriageway	VARCHAR(255),
`1st_Point_of_Impact`	VARCHAR(255), `Was_Vehicle_Left_Hand_Drive?`	VARCHAR(255),
Journey_Purpose_of_Driver	VARCHAR(255), Sex_of_Driver	VARCHAR(255), Age_of_Driver	VARCHAR(255), 
Age_Band_of_Driver	VARCHAR(255), Engine_Capacity_CC	VARCHAR(255), Propulsion_Code	VARCHAR(255),
Age_of_Vehicle	VARCHAR(255), Driver_IMD_Decile	VARCHAR(255),
Driver_Home_Area_Type	VARCHAR(255), Vehicle_IMD_Decile VARCHAR(255));

LOAD DATA INFILE "D:/Ineuron_FSDA/SQL/Assignment_2_Datasets/Vehicles_2015.csv"
INTO TABLE VEHICLES_2015
FIELDS TERMINATED  by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE VEHICLE_TYPE (
`CODE` VARCHAR(255),
LABEL VARCHAR(255));

LOAD DATA INFILE "D:/Ineuron_FSDA/SQL/Assignment_2_Datasets/vehicle_types.csv"
INTO TABLE VEHICLE_TYPE
FIELDS TERMINATED  by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 1. Evaluate the median severity value of accidents caused by various Motorcycle

SET @rowindex := -1;
SELECT
   AVG(NEW_TABLE.Accident_Severity) AS MEDIAN
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           LABEL, Accident_Severity
    FROM ACCIDENTS_2015 A LEFT JOIN VEHICLES_2015 V ON A.Accident_Index = V.Accident_Index
	LEFT JOIN VEHICLE_TYPE VT ON V.Vehicle_Type = VT.`CODE`
    ORDER BY Accident_Severity) AS NEW_TABLE
WHERE
NEW_TABLE.rowindex IN (FLOOR(@rowindex / 2) , CEIL(@rowindex / 2));



-- 2. Evaluate Accident Severity and Total Accidents per Vehicle Type.

SELECT LABEL, AVG(Accident_Severity), COUNT(Accident_Severity) AS TOTAL_ACCIDENTS
FROM ACCIDENTS_2015 A LEFT JOIN VEHICLES_2015 V ON A.Accident_Index = V.Accident_Index
LEFT JOIN VEHICLE_TYPE VT ON V.Vehicle_Type = VT.`CODE`
GROUP BY LABEL;


-- 3. Calculate the Average Severity by vehicle type.

SELECT LABEL, AVG(Accident_Severity)
FROM ACCIDENTS_2015 A LEFT JOIN VEHICLES_2015 V ON A.Accident_Index = V.Accident_Index
LEFT JOIN VEHICLE_TYPE VT ON V.Vehicle_Type = VT.`CODE`
GROUP BY LABEL;


-- 4. Calculate the Average Severity and Total Accidents by Motorcycle.

SELECT LABEL, AVG(Accident_Severity) AS AVG_SEVERITY, COUNT(Accident_Severity) AS TOTAL_ACCIDENTS
FROM ACCIDENTS_2015 A LEFT JOIN VEHICLES_2015 V ON A.Accident_Index = V.Accident_Index
LEFT JOIN VEHICLE_TYPE VT ON V.Vehicle_Type = VT.`CODE`
WHERE LABEL LIKE 'MOTORCYCLE%';



/* 🎯Analyzing the World Population 
DATASET - https://drive.google.com/file/d/16K7yCzEwt7k3s0m05j31sGmohX3AdNDa/view*/
-- NA valus in population_growth_rate were changed to 0 in the dataset to find the results

CREATE TABLE POPULATION (
country VARCHAR(255), area	VARCHAR(255), birth_rate	VARCHAR(255), death_rate	VARCHAR(255),
infant_mortality_rate	VARCHAR(255), internet_users VARCHAR(255), life_exp_at_birth	VARCHAR(255),
maternal_mortality_rate	VARCHAR(255), net_migration_rate	VARCHAR(255), 
population	INT, population_growth_rate DECIMAL
);

LOAD DATA INFILE "D:/Ineuron_FSDA/SQL/Assignment_2_Datasets/cia_factbook___FSDA 18th Sept 2022.csv"
INTO TABLE POPULATION
FIELDS TERMINATED  by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 1. Which country has the highest population?

SELECT COUNTRY 
FROM POPULATION 
WHERE POPULATION  NOT IN ('NA')
ORDER BY POPULATION DESC 
LIMIT 1;

-- 2. Which country has the least number of people?

SELECT COUNTRY 
FROM POPULATION 
WHERE POPULATION  NOT IN('NA')
ORDER BY POPULATION LIMIT 1;


-- 3. Which country is witnessing the highest population growth?

SELECT COUNTRY
FROM POPULATION 
ORDER BY population_growth_rate DESC
LIMIT 1;

-- 4. Which country has an extraordinary number for the population?
/* SOLUTION CREATED CONSIDERING THAT EXTRAORDINARY NUMBER OF POPULATION
 IMPLIES HIGH POPULATION DENSITY */

SELECT COUNTRY 
FROM 
	(SELECT *, POPULATION/AREA AS POPULATION_DENSITY
	FROM POPULATION) AS POP_DENSITY_TABLE
ORDER BY POPULATION_DENSITY DESC 
LIMIT 1;

-- 5. Which is the most densely populated country in the world?

SELECT COUNTRY 
FROM 
	(SELECT *, POPULATION/AREA AS POPULATION_DENSITY
	FROM POPULATION) AS POP_DENSITY_TABLE
ORDER BY POPULATION_DENSITY DESC 
LIMIT 1;