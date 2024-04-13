#likelihood to die by country by date
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM death_data
WHERE continent is not null
ORDER BY 1,2;

#Shows what percentage of population got covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as PercenrageInfected
FROM death_data
WHERE continent is not null
ORDER BY 1,2;

#Max Percentage of infected bu countries
SELECT 
    location, 
    MAX(total_cases) as max_total_cases, 
    population, 
    (MAX(total_cases)/population)*100 as PercentageInfected
FROM 
    death_data
WHERE continent is not null
GROUP BY 
    location, population
ORDER BY 
    PercentageInfected DESC;


#Max Percentage of deaths bu countries
SELECT 
    location, 
    MAX(total_deaths) as total_deaths, 
    population, 
    (MAX(total_deaths)/population)*100 as PercentageDead
FROM 
    death_data
WHERE continent is not null 
GROUP BY 
    location, population
ORDER BY 
    PercentageDead DESC;
    
    
#Max Percentage of deaths by region
SELECT 
    location, 
    MAX(total_deaths) as total_deaths, 
    population, 
    (MAX(total_deaths)/population)*100 as PercentageDead
FROM 
    death_data
WHERE continent is null AND location not like "%income%"
GROUP BY 
    location, population
ORDER BY 
    PercentageDead DESC;
    
#Max Percentage of deaths by income
SELECT 
    location AS income_level,
    MAX(total_deaths) as total_deaths, 
    population, 
    (MAX(total_deaths)/population)*100 as PercentageDead
FROM 
    death_data
WHERE continent is null AND location like "%income%"
GROUP BY 
    income_level, population
ORDER BY 
    PercentageDead DESC;

#World death procentage each week
SELECT 
    date,
    SUM(new_cases) as total_cases,
    SUM(new_deaths) as total_deaths, 
    (SUM(new_deaths)/SUM(new_cases))*100 as PercentageDead
FROM 
    death_data
WHERE 
    continent is not null 
GROUP BY 
    date
HAVING
    PercentageDead IS NOT NULL
ORDER BY 
    date;

#Population vs Vaccinated 
SELECT dea.continent, dea.location, dea.date, dea.population, hea.new_vaccinations,
SUM(hea.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS total_vactinations, hea.total_vaccinations
FROM death_data dea
JOIN health_data hea
ON dea.location = hea.location
AND dea.date = hea.date
WHERE dea.continent is not null
ORDER by 2,3

# Useing CTE
WITH populationVSdeath 
AS
(SELECT dea.continent, dea.location, dea.date, dea.population, hea.new_vaccinations,
SUM(hea.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS total_vactinations
FROM death_data dea
JOIN health_data hea
ON dea.location = hea.location
AND dea.date = hea.date
WHERE dea.continent is not null
ORDER by 2,3)

SELECT *, (total_vactinations/population)*100 as prcent_vacinated FROM populationVSdeath;

#TEMP TIBLE
DROP TABLE IF EXISTS popVSvac;

CREATE TEMPORARY TABLE popVSvac (
    Continent VARCHAR(255),
    Location VARCHAR(255),
    DATE DATE,
    Population BIGINT,
    New_Vaccination BIGINT,
    Total_Vaccination BIGINT 
);

INSERT INTO popVSvac
(
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        hea.new_vaccinations AS New_Vaccination,
        SUM(hea.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS Total_Vaccination
    FROM 
        death_data dea
    JOIN 
        health_data hea ON dea.location = hea.location AND dea.date = hea.date
    WHERE 
        dea.continent IS NOT NULL
    ORDER BY 
        dea.location, 
        dea.date
);

CREATE VIEW PercentPopulationVacinated
as (
SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        hea.new_vaccinations AS New_Vaccination,
        SUM(hea.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS Total_Vaccination
    FROM 
        death_data dea
    JOIN 
        health_data hea ON dea.location = hea.location AND dea.date = hea.date
    WHERE 
        dea.continent IS NOT NULL
    ORDER BY 
        dea.location, 
        dea.date
);

SELECT *
FROM percentpopulationvacinated