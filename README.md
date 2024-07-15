# Deforestation Exploration
## Project Overview

ForestQuery, a fictitious non-profit organization, is dedicated to reducing deforestation worldwide and raising awareness about the importance of this environmental issue.

The goal of this project is to help ForestQuery's management understand the global deforestation trends between 1990 and 2016. We have sourced three tables of data online: forest area, land area, and regions.

Our task is to present a report to ForestQuery's management, detailing the global situation, regional outlook, and country-level specifics of deforestation, along with recommendations. The appendix will include all SQL queries formatted according to SQL guidelines.

## Project Tasks


* Join Tables and create view

* Create a View called “forestation” by joining all three tables - forest_area, land_area and regions in the workspace.

* The forest_area and land_area tables join on both country_code AND year.

* The regions table joins these based on only country_code.

* In the ‘forestation’ View, include the following:

* All of the columns of the origin tables
* A new column that provides the percent of the land area that is designated as forest.
*  Keep in mind that the column forest_area_sqkm in the forest_area table and the land_area_sqmi in the land_area table are in different units (square kilometers and square miles, 
   respectively), so an adjustment will need to be made in the calculation you write (1 sq mi = 2.59 sq km).






