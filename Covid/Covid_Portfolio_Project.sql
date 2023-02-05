
select *
from ProjectCovid..CovidDeaths
where continent is not null -- removes null continent data points
order by 3,4


--select data that we are going to use

Select 
Location, date, total_cases, new_cases, total_deaths, population
From ProjectCovid..CovidDeaths
order by 1,2;

--Total Cases vs Total Deaths 
--Shows likelihood of dying if you contract covid by country
Select 
Location, date, total_cases, total_deaths, 
(total_deaths/total_cases)*100 as DeathPercentage
From ProjectCovid..CovidDeaths
Where location = 'United States' --Look at United States Specifically
order by 1,2;


--Total Cases Vs Population
--Percentage of Population contracted Covid
Select 
Location, date,population, total_cases, 
(total_cases/population)*100 as CovidPercentage
From ProjectCovid..CovidDeaths
Where location = 'United States' --Look at United States Specifically
order by 1,2;

--Highest Infection Rate 
Select 
Location, population, 
MAX(total_cases) as HighestInfectionCount, 
(MAX(total_cases)/population)*100 as PercentPopulationInfected
From ProjectCovid..CovidDeaths
Group by location, population
order by PercentPopulationInfected desc;

--Highest Death Count per Population by Country
Select 
Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From ProjectCovid..CovidDeaths
where continent is not null -- removes null continent data points
Group by location
order by TotalDeathCount desc;

--Highest Death Count per Population by Continent
Select 
continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From ProjectCovid..CovidDeaths
where continent is not null -- removes null continent data points
Group by continent
order by TotalDeathCount desc;


--Global Numbers 
Select 
 date, SUM(new_cases) as total_cases,
 SUM(cast(new_deaths as int)) as total_deaths, 
 SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage

From ProjectCovid..CovidDeaths
Where continent is not null
Group By date
order by 1,2;

--death percentage of the world
Select 
 SUM(new_cases) as total_cases,
 SUM(cast(new_deaths as int)) as total_deaths, 
 SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage

From ProjectCovid..CovidDeaths
Where continent is not null
order by 1,2;

-- Including the Covid Vacination Table

--Total Population  vs Vaccinations
Select 
dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100 as 
From    ProjectCovid..CovidDeaths dea
Join ProjectCovid..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date --joining the two tables based on location and date
Where dea.continent is not null
order by 2,3;

--Use CTE
With PopvsVac (Continent, location, Date, population,new_vaccinations, RollingPeopleVaccinated)
as 
(
	Select 
	dea.continent, dea.location, dea.date, dea.population,
	vac.new_vaccinations, 
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location, dea.Date) as RollingPeopleVaccinated
	From    ProjectCovid..CovidDeaths dea
	Join ProjectCovid..CovidVaccinations vac
		ON dea.location = vac.location
		and dea.date = vac.date --joining the two tables based on location and date
	Where dea.continent is not null
	--order by 2,3
	)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

--Temp Table
DROP table if exists #PercentPopulationVaccinated -- automatically removes any previous temp table made with the same name
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(225), 
location nvarchar(225),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select 
	dea.continent, dea.location, dea.date, dea.population,
	vac.new_vaccinations, 
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location, dea.Date) as RollingPeopleVaccinated
	From    ProjectCovid..CovidDeaths dea
	Join ProjectCovid..CovidVaccinations vac
		ON dea.location = vac.location
		and dea.date = vac.date --joining the two tables based on location and date
	Where dea.continent is not null
	--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100 as PercentVaccinated
From #PercentPopulationVaccinated;

--Creating View to store data for visualizations

Create View PercentPopulationVaccinated as 
Select 
	dea.continent, dea.location, dea.date, dea.population,
	vac.new_vaccinations, 
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location, dea.Date) as RollingPeopleVaccinated
	From    ProjectCovid..CovidDeaths dea
	Join ProjectCovid..CovidVaccinations vac
		ON dea.location = vac.location
		and dea.date = vac.date --joining the two tables based on location and date
	Where dea.continent is not null;


-- 
USE ProjectCovid
GO
Create View Continent_Total_Death_Count as
Select 
continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From ProjectCovid..CovidDeaths
where continent is not null -- removes null continent data points
Group by continent
