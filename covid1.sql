# inspecting covid data using bigquery

# subset data
SELECT  location, date, total_cases, new_cases, total_deaths, population
FROM `sql-projects-383108.covid_project_sql.CovidDeath` 
WHERE continent IS NOT NULL
ORDER BY location, date

# inspect total cases v.s. total deaths in Germany
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM `sql-projects-383108.covid_project_sql.CovidDeath` 
WHERE location = "Germany"
ORDER BY location, date

# inspect total cases v.s. population in Germany
SELECT  location, date, total_cases, population, (total_cases/population)*100 AS CasePercentage
FROM `sql-projects-383108.covid_project_sql.CovidDeath` 
WHERE location = "Germany" AND continent IS NOT NULL
ORDER BY location, date

# what countries have the highest infection rate compared to population?
SELECT  location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM `sql-projects-383108.covid_project_sql.CovidDeath` 
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

# what countries have the highest death count?
SELECT  location, MAX(total_deaths) AS TotalDeathCount
FROM `sql-projects-383108.covid_project_sql.CovidDeath` 
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

# what continent has the highest death count?
SELECT  continent, MAX(total_deaths) AS TotalDeathCount
FROM `sql-projects-383108.covid_project_sql.CovidDeath` 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

# global numbers
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, IEEE_DIVIDE(SUM(new_deaths), SUM(new_cases)) * 100 AS DeathPercentage
FROM `sql-projects-383108.covid_project_sql.CovidDeath` 
WHERE continent IS NOT NULL
ORDER BY DeathPercentage DESC

# total population v.s. total vaccinations
# create view for visualization
CREATE VIEW `sql-projects-383108.covid_project_sql.table1` AS 
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(v.  new_vaccinations) OVER(PARTITION BY d.location ORDER BY d.location, d.date) AS rollingPeopleVaccinated 
FROM `sql-projects-383108.covid_project_sql.CovidDeath` AS d
JOIN `sql-projects-383108.covid_project_sql.CovidVac` AS v
ON d.location = v.location 
AND d.date = v.date
WHERE d.continent IS NOT NULL AND v.continent IS NOT NULL
ORDER BY d.location, d.date




