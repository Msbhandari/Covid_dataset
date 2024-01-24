SELECT *
FROM Portfolio_Project..covid_deaths
ORDER BY 3,4;

-- SELECT *
-- FROM Portfolio_Project..covid_vaccinations;
USE Portfolio_Project;

-- Select data which will be use-

--Looking at Total cases vs death
SELECT location,date,total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..covid_deaths
ORDER BY 1,2;

-- likelihood of dying in U.S
SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT)/total_cases)*100 AS deathpercent --CONVERT(int,...) can also be used
FROM dbo.covid_deaths
WHERE location LIKE '%states%'
ORDER BY 2;
-----------------------------------------------------------------------------------------------------------------------
ALTER TABLE dbo.covid_deaths
-- ALTER COLUMN total_deaths int;
ALTER COLUMN total_cases int;

EXEC sp_help 'dbo.covid_deaths'; -- to check type of variables in a table
------------------------------------------------------------------------------------------------------------------------
-- current deat percent in india due to covid
SELECT location, date, new_cases, new_deaths, (new_deaths /NULLIF(new_cases, 0))*100 AS current_deathpercent
FROM dbo.covid_deaths
WHERE location LIKE '%India%'
ORDER BY 2;

-- What percent of Population got covid

SELECT location, date, population,total_cases, (total_cases/population)*100 AS infect_popu_percent
FROM dbo.covid_deaths
WHERE location LIKE 'India'
ORDER BY 2;

-- Countries with highest infection rate compare to population
SELECT location, population,MAX(total_cases) AS Highest_inf_count, MAX((total_cases/population))*100 AS infectpopulation_percent
FROM dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY infectpopulation_percent DESC;

-- Showing COUNTRIES with Highest death count per population 
SELECT location, population, MAX(total_deaths) AS Total_death_count 
FROM dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY Total_death_count DESC;

-- LET'S BREAK DOWN BY CONTINENT

SELECT continent, MAX(total_deaths) AS Total_death_count 
FROM dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_death_count DESC;

SELECT location, MAX(total_deaths) AS Total_death_count 
FROM dbo.covid_deaths
WHERE continent IS NULL
GROUP BY location
ORDER BY Total_death_count DESC;

-- BIGGER NUMBERS
SELECT Location,SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_death_count
FROM dbo.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 3 DESC;
----------------------------------------------------------------------------------------------------------------------

--Looking at Total population vs Vacination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM dbo.covid_deaths dea
JOIN dbo.covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

-- LOOKING AT Rolling count for vacination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollinG_Vacination
FROM dbo.covid_deaths dea
JOIN dbo.covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;
