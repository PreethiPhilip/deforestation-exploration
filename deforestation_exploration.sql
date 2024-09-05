/*

    Create a View called “forestation” by joining all three tables - forest_area,
    and_area and regions in the workspace.
    The forest_area and land_area tables join on both country_code AND year.
    The regions table joins these based on only country_code.

    In the ‘forestation’ View, include the following:
    All of the columns of the origin tables
    A new column that provides the percent of the land area that is designated as forest.

    Keep in mind that the column forest_area_sqkm in the forest_area table and the land_area_sqmi
    in the land_area table are in different units (square kilometers and square miles, respectively),
    so an adjustment will need to be made in the calculation you write (1 sq mi = 2.59 sq km).
*/

CREATE VIEW forestation AS
SELECT
f.country_code,
f.country_name,
f.year,
f.forest_area_sqkm,
l.total_area_sq_mi,
l.total_area_sq_mi * 2.59 AS total_area_sqkm,
r.region,
r.income_group,
(f.forest_area_sqkm *100)/(total_area_sq_mi*2.59) AS percent_forestation
FROM forest_area f
JOIN land_area l
ON f.country_code = l.country_code
AND f.year = l.year
JOIN regions r
ON r.country_code = f.country_code
SELECT *
FROM forestation;


/*
1. GLOBAL SITUATION

Instructions:

    Answering these questions will help you add information into the template.
    Use these questions as guides to write SQL queries.
    Use the output from the query to answer these questions.
    

1a. What was the total forest area (in sq km) of the world in 1990?
   Please keep in mind that you can use the country record denoted as “World" in the region table.*/

SELECT SUM(forest_area_sqkm) AS total_forest_area
FROM forestation
WHERE year = 1990
AND region = 'World';
/*

1b. What was the total forest area (in sq km) of the world in 2016?
   Please keep in mind that you can use the country record in the table is denoted as “World.”

*/
SELECT SUM(forest_area_sqkm) AS total_forest_area
FROM forestation
WHERE year = 2016
AND region = 'World';



/*
1c. What was the change (in sq km) in the forest area of the world from 1990 to 2016?

*/

SELECT (f1.forest_area_sqkm - f2.forest_area_sqkm) AS change_forest_area
FROM forestation f1 ,forestation f2
WHERE f1.year = 1990
AND f1.region = 'World'
AND f2.year = 2016
AND f2.region = 'World';


/*
1d. What was the percentage of change in forest area of the world between 1990 and 2016?
*/

SELECT (f1.forest_area_sqkm - f2.forest_area_sqkm)*100 / f1.forest_area_sqkm
AS percent_change
FROM forestation f1,forestation f2
WHERE f1.year = 1990
AND f1.region = 'World'
AND f2.year = 2016
AND f2.region = 'World';



/*
1e. If you compare the amount of forest area lost between 1990 and 2016,
   to which country's total area in 2016 is it closest to?
*/
SELECT country_name, total_area_sqkm
FROM forestation
WHERE year = 2016
AND total_area_sqkm <= (SELECT (f1.forest_area_sqkm - f2.forest_area_sqkm)
AS change_forest_area
FROM forestation f1,forestation f2
WHERE f1.year = 1990
AND f1.region = 'World'
AND f2.year = 2016
AND f2.region = 'World')
ORDER BY 2 DESC
LIMIT 1 ;



/*
2. REGIONAL OUTLOOK

Create a table that shows the Regions and their percent forest area (sum of forest area 
divided by sum of land area) in 1990 and 2016. (Note that 1 sq mi = 2.59 sq km)
*/

SELECT region,
ROUND(CAST((forest_1990*100/land_1990)AS numeric),2) AS
Forest_Percentage_1990,
ROUND(CAST((forest_2016*100/land_2016)AS numeric),2) AS
Forest_Percentage_2016
FROM(SELECT f1.region,
SUM(f1.forest_area_sqkm)AS forest_1990,
SUM(f1.total_area_sqkm)AS land_1990,
SUM(f2.forest_area_sqkm)AS forest_2016,
SUM(f2.total_area_sqkm)AS land_2016
FROM forestation f1,forestation f2
WHERE f1.year = 1990
AND f1.region != 'World'
AND f2.year = 2016
AND f2.region != 'World'
AND f1.region = f2.region
GROUP BY f1.region)T1
ORDER BY 2 DESC;
/*
2a. What was the percent forest of the entire world in 2016?
   
*/
SELECT percent_forestation
FROM forestation
WHERE region = 'World'
AND year = 2016;

/*
2b. Which region had the HIGHEST percent forest in 2016,
   and which had the LOWEST, to 2 decimal places?

*/

SELECT region,
ROUND(CAST(percent_forest_area AS numeric),2)
FROM(SELECT region,
SUM(forest_area_sqkm)*100/SUM(total_area_sqkm)AS percent_forest_area
FROM forestation
WHERE year = 2016
GROUP BY region)T1
ORDER BY 2 DESC
LIMIT 1;


SELECT region,
ROUND(CAST(percent_forest_area AS numeric),2)
FROM(SELECT region,
SUM(forest_area_sqkm)*100/SUM(total_area_sqkm)AS percent_forest_area
FROM forestation
WHERE year = 2016
GROUP BY region)T1
ORDER BY 2
LIMIT 1;

/* 
2d.  What was the percent forest of the entire world in 1990?
   
*/

SELECT percent_forestation
FROM forestation
WHERE region = 'World'
AND year = 1990;
/*
Which region had the HIGHEST percent forest in 1990,
   and which had the LOWEST, to 2 decimal places?
*/


SELECT region,
ROUND(CAST(percent_forest_area AS numeric),2)
FROM(SELECT region,
SUM(forest_area_sqkm)*100/SUM(total_area_sqkm)AS percent_forest_area
FROM forestation
WHERE year = 1990
GROUP BY region)T1
ORDER BY 2 DESC
LIMIT 1;

SELECT region,
ROUND(CAST(percent_forest_area AS numeric),2)
FROM(SELECT region,
SUM(forest_area_sqkm)*100/SUM(total_area_sqkm)AS percent_forest_area
FROM forestation
WHERE year = 1990
GROUP BY region)T1
ORDER BY 2
LIMIT 1



/*
3. COUNTRY-LEVEL DETAIL
A.	SUCCESS STORIES
*/
WITH t1 AS
(SELECT region,
country_name,
forest_area_sqkm
FROM forestation
WHERE year = 1990),
t2 AS
(SELECT region,
country_name,
forest_area_sqkm
FROM forestation
WHERE year = 2016)
SELECT t1.region,
t1.country_name,
t1.forest_area_sqkm AS forest_area_1990,
t2.forest_area_sqkm AS forest_area_2016,
ROUND(CAST((t2.forest_area_sqkm - t1.forest_area_sqkm)AS numeric),2)AS
differece_forest_area,
ROUND(CAST(((t2.forest_area_sqkm -
t1.forest_area_sqkm)*100/t1.forest_area_sqkm) AS numeric),2)AS
percent_increase_forest
FROM t1
JOIN t2
ON t1.country_name = t2.country_name
WHERE t2.forest_area_sqkm > t1.forest_area_sqkm
ORDER BY percent_increase_forest DESC;

/*

A. LARGEST CONCERNS
a. Table 3.1: Top 5 Amount Decrease in Forest Area by Country, 1990 & 2016

*/
WITH t1 AS
(SELECT region,
country_name,
forest_area_sqkm
FROM forestation
WHERE year = 1990),
t2 AS
(SELECT region,
country_name,
forest_area_sqkm
FROM forestation
WHERE year = 2016)
SELECT t1.country_name,
t1.region,
t1.forest_area_sqkm AS forest_area_1990,
t2.forest_area_sqkm AS forest_area_2016,
ROUND(CAST((t1.forest_area_sqkm - t2.forest_area_sqkm)AS numeric),2)AS
differece_forest_area
FROM t1
JOIN t2
ON t1.country_name = t2.country_name
WHERE t1.forest_area_sqkm > t2.forest_area_sqkm
AND t1.region != 'World'
ORDER BY differece_forest_area DESC
LIMIT 5;
/*
b. Table 3.2: Top 5 Percent Decrease in Forest Area by Country, 1990 & 2016:
*/

WITH t1 AS
(SELECT region,
country_name,
forest_area_sqkm
FROM forestation
WHERE year = 1990),
t2 AS
(SELECT region,
country_name,
forest_area_sqkm
FROM forestation
WHERE year = 2016)
SELECT t1.country_name,
t1.region,
t1.forest_area_sqkm AS forest_area_1990,
t2.forest_area_sqkm AS forest_area_2016,
ROUND(CAST(((t1.forest_area_sqkm -
t2.forest_area_sqkm)*100/t1.forest_area_sqkm) AS numeric),2)AS
percent_decrease_forest
FROM t1
JOIN t2
ON t1.country_name = t2.country_name
WHERE t1.forest_area_sqkm > t2.forest_area_sqkm
AND t1.region != 'World'
ORDER BY percent_decrease_forest DESC
LIMIT 5;
/*
C. QUARTILES
c. Table 3.3: Count of Countries Grouped by Forestation Percent Quartiles, 2016:
*/

SELECT DISTINCT(quartile), COUNT(country_name)OVER(PARTITION BY
quartile)
FROM(SELECT country_name,
CASE WHEN percent_forestation<= 25 THEN '0-25%'
WHEN percent_forestation<= 50 THEN '25%-50%'
WHEN percent_forestation<= 75 THEN '50%-70%'
ELSE '75%-100%'
END AS quartile
FROM forestation
WHERE year = 2016
AND percent_forestation IS NOT NULL)sub;
Table 3.4: Top Quartile Countries, 2016:
SELECT country_name,
region,
percent_forestation
FROM forestation
WHERE percent_forestation > 75
AND percent_forestation IS NOT NULL
AND year = 2016
ORDER BY 3 DESC;