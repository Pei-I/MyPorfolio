--My Very First Try
--Data Source : https://ourworldindata.org/covid-deaths
--Downloaded on 2021-06-23 

--Quick View
SELECT *
FROM MyPortfolio..covid_death
ORDER  BY 3,4

SELECT *
FROM MyPortfolio..covid_vaccination
ORDER  BY 3,4

--Due to data type of "new_deaths" "total_deaths" is nvarchart, convert data type  to INT :CAST(new_deaths AS INT) CAST(total_deaths AS INT)

--Global Data 

--Global population 瞴
SELECT
 SUM(population) AS global_population
FROM MyPortfolio..covid_death
WHERE CAST(date AS date)= '2021-06-23' 

--Global Death Toll 瞴计
SELECT 
  SUM(CAST(total_deaths AS INT)) AS global_death_toll
FROM 
  MyPortfolio..covid_death
WHERE 
  CAST(date AS DATE) = '2021-06-23' 

  --Global Total Cases 瞴絋禘计
SELECT 
  SUM(total_cases) AS global_total_cases
FROM 
  MyPortfolio..covid_death
WHERE 
  CAST(date AS DATE) = '2021-06-23' 

--Global Daily New Cases 瞴–ら穝糤絋禘计
SELECT 
  CAST(date as DATE) AS date,
  SUM(new_cases) AS daily_new_cases
FROM 
  MyPortfolio..covid_death
GROUP BY
  date 
ORDER BY date 


--Global Fatality Rate 瞴瞯
SELECT  
  SUM(CAST(total_deaths AS INT)) AS global_death_toll, 
  SUM(total_cases) AS global_total_cases, 
  (SUM(CAST(total_deaths AS INT))/SUM(total_cases))*100 AS global_fatality_rate
FROM 
  MyPortfolio..covid_death
WHERE 
  CAST(date AS DATE) = '2021-06-23' 

-- Global Incidence Rate 瞴絋禘瞯
SELECT 
 SUM(total_cases) AS global_total_cases,
 SUM(population) AS global_population,
 (SUM(total_cases)/ SUM(population)) *100 AS global_incidence_rate 
FROM 
  MyPortfolio..covid_death
WHERE 
  CAST(date AS DATE) = '2021-06-23' 



 --Break Down to Continent

 --Population by continent 瑆
 SELECT
  continent,
  SUM(population) AS population_continent
FROM  MyPortfolio..covid_death
WHERE CAST(date AS date) ='2021-06-23'
GROUP BY continent,  CAST(date AS date)
ORDER BY population_continent

 -- Death Toll by Continent 瑆计
  SELECT 
  continent,
  SUM(CAST(total_deaths AS INT)) AS death_toll_continet
FROM 
  MyPortfolio..covid_death
WHERE CAST(date AS date) ='2021-06-23'
GROUP BY 
  continent
ORDER BY 
  death_toll_continet DESC


--  Total Cases by Continent 瑆絋禘计
 SELECT
    continent,
	SUM(total_cases) AS total_cases_continent
FROM  
  MyPortfolio..covid_death
WHERE 
  CAST(date AS date) ='2021-06-23'
GROUP BY 
  continent
ORDER BY 
  total_cases_continent DESC

--Daily New Cases by Continent 瑆–ら穝糤絋禘计

 SELECT
    CAST(date as DATE) AS date ,
	continent,
	SUM(new_cases) AS total_cases_continent
FROM  
  MyPortfolio..covid_death
GROUP BY 
  continent, date
ORDER BY 
  date



 --Fatality Rate by Continent 瑆瞯
SELECT 
  continent,  
  SUM(CAST(total_deaths AS INT)) AS death_toll_continent,
  SUM(total_cases) AS total_cases_continent,
  (SUM(CAST(total_deaths AS INT))/SUM(total_cases))*100 AS fatality_rate_continent
FROM 
  MyPortfolio..covid_death
WHERE 
  CAST(date AS date) ='2021-06-23'
GROUP BY 
  continent
ORDER BY
  fatality_rate_continent DESC


--Incidence Rate by Continent 瑆絋禘瞯 (Temporary table)
  SELECT 
  continent, 
  SUM(total_cases) AS total_cases_continent, 
  SUM(population) AS population_continent,
  ( SUM(total_cases)/ SUM(population)) *100 AS incidence_rate_continent 
FROM 
  MyPortfolio..covid_death
WHERE 
  CAST(date AS DATE) = '2021-06-23' 
GROUP BY continent



--Break Down To Country

--Death Toll by Country 瓣计
SELECT   
  location, 
  SUM(CAST(new_deaths AS INT)) AS death_toll_country
FROM 
  MyPortfolio..covid_death
GROUP BY 
  location
ORDER BY 
  death_toll_country DESC

--Total Cases by Country  瓣絋禘计
SELECT   
  location, 
  SUM(total_cases) AS total_cases_country
FROM 
  MyPortfolio..covid_death
WHERE 
  CAST(date AS date) ='2021-06-23'
GROUP BY 
  location
ORDER BY 
  total_cases_country DESC

--Fatality Rate by Country 瓣瞯
--Found that Vanuatu is the country with the highest fatality rate. But their total cases are few. 
SELECT 
  location,  
  SUM(CAST(total_deaths AS INT)) AS death_toll_country,
  SUM(total_cases) AS total_cases_country,
  (SUM(CAST(total_deaths AS INT))/SUM(total_cases))*100 AS fatality_rate_country
FROM 
  MyPortfolio..covid_death
WHERE 
  CAST(date AS date) ='2021-06-23'
GROUP BY 
  location
ORDER BY
  fatality_rate_country DESC

--Daily New Cases of Taiwan (My nationality)  芖–ら穝糤絋禘计
SELECT 
  CAST(date AS DATE) AS date,
  location,  
  SUM(new_cases) AS daily_new_cases_country
FROM 
  MyPortfolio..covid_death
WHERE 
  location ='Taiwan' 
GROUP BY 
  location, date
ORDER BY date

--Fatality Rate of Taiwan 芖瞯
--Found that fatality rate of Taiwan is quite high. Almost 2 times higher than global fatality rate.
SELECT 
  location,  
  SUM(CAST(total_deaths AS INT)) AS death_toll_country,
  SUM(total_cases) AS total_cases_country,
  (SUM(CAST(total_deaths AS INT))/SUM(total_cases))*100 AS fatality_rate_country
FROM 
  MyPortfolio..covid_death
WHERE 
  location ='Taiwan' AND CAST(date AS date) ='2021-06-23'
GROUP BY 
  location

--Daily New Cases of Spain ﹁痁–ら穝糤絋禘计
SELECT 
  CAST(date AS DATE) AS date,
  location,  
  SUM(new_cases) AS daily_new_cases_country
FROM 
  MyPortfolio..covid_death
WHERE 
  location ='Spain' 
GROUP BY 
  location, date
ORDER BY date


--Fatality Rate of Spain (The country where I live in now) ﹁痁瞯
SELECT 
  location,  
  SUM(CAST(total_deaths AS INT)) AS death_toll_country,
  SUM(total_cases) AS total_cases_country,
  (SUM(CAST(total_deaths AS INT))/SUM(total_cases))*100 AS fatality_rate_country
FROM 
  MyPortfolio..covid_death
WHERE 
  location ='Spain' AND CAST(date AS date) ='2021-06-23'
GROUP BY 
  location

--Compare Fatality Rate of Taiwan with Spain, United States
SELECT 
  location,  
  SUM(CAST(total_deaths AS INT)) AS death_toll_country,
  SUM(total_cases) AS total_cases_country,
  (SUM(CAST(total_deaths AS INT))/SUM(total_cases))*100 AS fatality_rate_country
FROM 
  MyPortfolio..covid_death
WHERE 
  location IN ('Taiwan', 'Spain', 'United States') AND CAST(date AS date) ='2021-06-23'
GROUP BY 
  location
ORDER BY fatality_rate_country DESC

--Incidence Rate by Country 瓣絋禘瞯
SELECT 
  location, 
  total_cases, 
  population, 
  (total_cases/population)*100 AS incidence_rate
FROM 
  MyPortfolio..covid_death
WHERE 
  CAST(date AS DATE) = '2021-06-23' and total_cases IS NOT NULL 
ORDER BY 
  incidence_rate DESC


--Incidence Rate of Taiwan 芖絋禘瞯
SELECT 
  location, 
  total_cases, 
  population, 
  (total_cases/population)*100 AS incidence_rate
FROM MyPortfolio..covid_death
WHERE location = 'Taiwan' AND CAST(date AS DATE) = '2021-06-23'
ORDER BY incidence_rate DESC

--Incidence Rate of Spain ﹁痁絋禘瞯
SELECT 
  location, 
  total_cases, 
  population, 
  (total_cases/population)*100 AS incidence_rate
FROM MyPortfolio..covid_death
WHERE location = 'Spain' AND CAST(date AS DATE) = '2021-06-23'
ORDER BY incidence_rate DESC

--Compare Incidence Rate of Taiwan with Spain, United States
SELECT 
  location, 
  total_cases, 
  population, 
  (total_cases/population)*100 AS incidence_rate
FROM MyPortfolio..covid_death
WHERE location IN ('Taiwan','Spain', 'United States') AND CAST(date AS DATE) = '2021-06-23'
ORDER BY incidence_rate DESC


--Population VS Vaccination (Taiwan) 芖璢钡贺薄

SELECT 
  dea.location,
  CAST(dea.date AS date) AS date,
  vac.people_vaccinated AS at_least_one_dose,
  vac.people_fully_vaccinated AS fully_vaccinated,
  dea.population
FROM
  MyPortfolio..covid_death AS dea
   INNER JOIN
   MyPortfolio..covid_vaccination AS vac
  ON dea.iso_code=vac.iso_code AND CAST(dea.date AS date)=CAST(vac.date AS date)
WHERE  dea.location IN ('Taiwan')
ORDER BY date DESC

--Tempporary Table 
WITH people_vaccination_taiwan AS(
SELECT 
  dea.location,
  CAST(dea.date AS date) AS date,
  vac.people_vaccinated AS at_least_one_dose,
  vac.people_fully_vaccinated AS fully_vaccinated,
  dea.population
FROM
  MyPortfolio..covid_death AS dea
   INNER JOIN
   MyPortfolio..covid_vaccination AS vac
  ON dea.iso_code=vac.iso_code AND CAST(dea.date AS date)=CAST(vac.date AS date)
WHERE  dea.location IN ('Taiwan')
)
--
SELECT 
  date,
  ( at_least_one_dose / population)*100 AS percent_one_dose, 
  (fully_vaccinated /population)*100 AS percent_fully
FROM 
  people_vaccination_taiwan
ORDER BY date DESC

--Population VS Vaccination (Spain) ﹁痁璢钡贺薄

SELECT 
  dea.location,
  CAST(dea.date AS date) AS date,
  vac.people_vaccinated AS at_least_one_dose,
  vac.people_fully_vaccinated AS fully_vaccinated,
  dea.population
FROM
  MyPortfolio..covid_death AS dea
   INNER JOIN
   MyPortfolio..covid_vaccination AS vac
  ON dea.iso_code=vac.iso_code AND CAST(dea.date AS date)=CAST(vac.date AS date)
WHERE  dea.location='Spain'
ORDER BY date DESC

--Temporary Table

WITH people_vaccination_spain AS(
SELECT 
  dea.location,
  CAST(dea.date AS date) AS date,
  vac.people_vaccinated AS at_least_one_dose,
  vac.people_fully_vaccinated AS fully_vaccinated,
  dea.population
FROM
  MyPortfolio..covid_death AS dea
   INNER JOIN
   MyPortfolio..covid_vaccination AS vac
  ON dea.iso_code=vac.iso_code AND CAST(dea.date AS date)=CAST(vac.date AS date)
WHERE  dea.location='Spain'
)
--
SELECT 
  date,
  ( at_least_one_dose / population)*100 AS percent_one_dose, 
  (fully_vaccinated /population)*100 AS percent_fully
FROM 
  people_vaccination_spain
ORDER BY date DESC








