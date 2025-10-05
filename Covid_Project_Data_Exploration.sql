/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-- Let's view the data (just Countries)

Select *
From PortfolioProject..CovidDeaths
Where continent is null 
order by 3,4;


-- Select Tables of interest

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2;



-- Top 10 countries with the highest number of cases

Select top 10
	Location, 
	max(total_cases) as Total_recorded
From PortfolioProject..CovidDeaths 
Where continent is not null 
-- and location like 'Nigeria'
Group by Location
order by Total_recorded desc;



-- Total Death count per Country ordered in desc

Select top 10
	Location, 
	max(cast(Total_deaths as bigint)) as TotalDeathCount
From PortfolioProject..CovidDeaths 
Where continent is not null 
-- and location like 'Nigeria'
Group by Location
order by TotalDeathCount desc;



-- max number of cases vs population
-- percentage of population of each country that got infected with covid at the end of the recorded duration

Select 
	Location, 
	max(Population) as Total_population, 
	max(total_cases) as Total_recorded,  
	max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null
-- and location = 'Nigeria'
group by location
order by 1;



-- Total Cases vs Total Deaths
-- Probability of Dying from covid per country per day

Select 
	Location,
	max(total_cases) as TotalCases, 
	max(total_deaths) as TotalDeaths, 
	max((total_deaths/total_cases))*100 as Prob_of_death_in_Percent
From PortfolioProject..CovidDeaths
Where continent is not null
-- and  location = 'Nigeria'
group by location
order by 1;



-- Total Cases vs Population
-- Shows the percentage of population of each country infected with Covid per day

Select 
	Location, 
	date, 
	Population, 
	total_cases,  (total_cases/population)*100 as PercentPopulationInfectedPerDay
From PortfolioProject..CovidDeaths
Where continent is not null
-- and location = 'Nigeria'
order by 1,2;



-- Percentage of the population per country that got DInfected with COVID-19 

Select 
	Location,
	max(total_cases) as TotalCases, 
	max(Population) as TotalPopulation, 
	max((total_cases/Population))*100 as PercentageInfected
From PortfolioProject..CovidDeaths
Where continent is not null
-- and  location = 'Nigeria'
group by location
order by 4 desc;



-- Percentage of the population per country that got Died from COVID-19 

Select 
	Location,
	max(cast(total_deaths as bigint)) as TotalDeaths, 
	max(Population) as TotalPopulation, 
	max((cast(total_deaths as bigint)/Population))*100 as PercentageDied
From PortfolioProject..CovidDeaths
Where continent is not null
-- and  location = 'Nigeria'
group by location
order by 4 desc;



-- BREAKING THINGS DOWN BY CONTINENT

-- Total Death Count per continent

Select  
	location, 
	max(cast(Total_deaths as bigint)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is null
	and location != 'World' 
	and location != 'International'
group by location
order by TotalDeathCount desc;


-- Total Number of Cases per continent

Select  
	location,
	max(cast(total_cases as bigint)) as TotalNumberOfCases
From PortfolioProject..CovidDeaths
where continent is null
	and location != 'World'
	and location != 'International' 
	and location != 'European Union'
group by location
order by TotalNumberOfCases desc;


-- Percentage of poulation infected with covid per continent in 3 d.p.

Select 
	Location, 
	max(Population) as Total_population, 
	max(cast(total_cases as bigint)) as Total_recorded,  
	round(max((total_cases/population))*100, 3) as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is null
	and location != 'World' 
	and location != 'International' 
	and location != 'European Union'
group by location
order by 1;


-- Percentage of poulation that died from covid per continent in 3 d.p.

Select 
	Location, 
	max(Population) as Total_population, 
	max(cast(total_deaths as bigint)) as Total_Deaths,  
	round(max((total_deaths/population))*100, 3) as PercentPopulationDied
From PortfolioProject..CovidDeaths
Where continent is null
	and location != 'World'	
	and location != 'International'
	and location != 'European Union'
group by location
order by 1;



-- GLOBAL NUMBERS

-- Below shows the Total number of cases, Total Death, total population and Percentage that died Globally
	-- This assumes that:
		-- 1. the data for European union is already contained in the data for Europe.
		-- 2. The data for International is treated as an independent entity
		-- 7794798729


select 
	sum(total_population) as TotalPopulation,
	sum(Total_recorded) as TotalInfected, 
	sum(Total_Deaths) as TotalDeaths, 
	round((sum(Total_recorded)/sum(total_population))*100, 3) as PercentPopulationInfected,
	round((sum(Total_Deaths)/sum(total_population))*100, 3) as PercentPopulationDied
From (
	Select 
		Location, 
		max(cast(total_cases as bigint)) as Total_recorded, 
		max(Population) as total_population, 
		max(cast(total_deaths as bigint)) as Total_Deaths
	From PortfolioProject..CovidDeaths
	Where continent is null
		and location != 'World'
		and location != 'European Union'
	group by location
	)t;



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	sum(convert(bigint,vac.new_vaccinations)) 
		OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;


-- Using CTE

With Pop_vs_Vac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	sum(convert(bigint,vac.new_vaccinations)) 
		OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
-- order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
from Pop_vs_Vac;


-- Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	sum(convert(bigint,vac.new_vaccinations)) 
		OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated;
GO



-- Creating view to store data for later visualization

Create View PercentPopulationVaccinated as
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	sum(convert(bigint,vac.new_vaccinations)) 
		OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null;
GO

select *
from PercentPopulationVaccinated;
