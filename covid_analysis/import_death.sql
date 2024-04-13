DROP TABLE IF EXISTS death_data;
CREATE TABLE death_data (
    iso_code VARCHAR(10),
    continent VARCHAR(255),
    location VARCHAR(255),
    date DATE,
    population BIGINT,
    total_cases INT,
    new_cases INT,
    new_cases_smoothed FLOAT,
    total_deaths INT,
    new_deaths INT,
    new_deaths_smoothed FLOAT,
    total_cases_per_million FLOAT,
    new_cases_per_million FLOAT,
    new_cases_smoothed_per_million FLOAT,
    total_deaths_per_million FLOAT,
    new_deaths_per_million FLOAT,
    new_deaths_smoothed_per_million FLOAT,
    reproduction_rate VARCHAR(255)
);

LOAD DATA INFILE 'C:/covid-deathes.csv'
INTO TABLE death_data
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @iso_code,
    @continent,
    @location,
    @date,
    @population,
    @total_cases,
    @new_cases,
    @new_cases_smoothed,
    @total_deaths,
    @new_deaths,
    @new_deaths_smoothed,
    @total_cases_per_million,
    @new_cases_per_million,
    @new_cases_smoothed_per_million,
    @total_deaths_per_million,
    @new_deaths_per_million,
    @new_deaths_smoothed_per_million,
    @reproduction_rate
)
SET
    iso_code = NULLIF(@iso_code, ''),
    continent = NULLIF(@continent, ''),
    location = NULLIF(@location, ''),
    date = NULLIF(@date, ''),
    population = NULLIF(@population, ''),
    total_cases = NULLIF(@total_cases, ''),
    new_cases = NULLIF(@new_cases, ''),
    new_cases_smoothed = NULLIF(@new_cases_smoothed, ''),
    total_deaths = NULLIF(@total_deaths, ''),
    new_deaths = NULLIF(@new_deaths, ''),
    new_deaths_smoothed = NULLIF(@new_deaths_smoothed, ''),
    total_cases_per_million = NULLIF(@total_cases_per_million, ''),
    new_cases_per_million = NULLIF(@new_cases_per_million, ''),
    new_cases_smoothed_per_million = NULLIF(@new_cases_smoothed_per_million, ''),
    total_deaths_per_million = NULLIF(@total_deaths_per_million, ''),
    new_deaths_per_million = NULLIF(@new_deaths_per_million, ''),
    new_deaths_smoothed_per_million = NULLIF(@new_deaths_smoothed_per_million, ''),
    reproduction_rate = NULLIF(@reproduction_rate, '');
