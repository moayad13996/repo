select * from coviddeaths
--select * from covidvaccination
select location,date,total_cases,new_cases,total_deaths,population 
from coviddeaths
order by 1,2

--Total cases vs Total deaths 

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage 
from coviddeaths
where location like 'Sudan'
order by 1,2

-- Total cases vs population 

select location,date,total_cases,population,(total_cases/population)*100 as spreadpercentage 
from coviddeaths
where location like 'Sudan'
order by 1,2


--Countries with highest infection rates compared to population


select location,population,max(total_cases)as Highestinfection,max((total_cases/population))*100 as PercentPopulationInfected 
from coviddeaths
group by Location,population
order by PercentPopulationInfected desc


--Countries with highest death count per population 
select location,max(cast(total_deaths as int))as TotalDeathCount
from coviddeaths
where continent is not null
group by Location
order by TotalDeathCount desc


--Breaking things down by Continant

--Continents with the the highest death count per population


select location,max(cast(total_deaths as int))as TotalDeathCount
from coviddeaths
where continent is null
group by location
order by TotalDeathCount desc


--Global Numbers

select date,sum(new_cases)as total_cases,sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from coviddeaths
where continent is not null
group by date
order by 1,2


--Looking at total population vs vaccination


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint))
over(partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from covidvaccination vac
join coviddeaths dea 
    on dea.location=vac.location
    and dea.date=vac.date
where dea.continent is not null
order by 2,3


--Using CTE
with PopvsVac (continent , location,date,population,new_vaccination,RollingPeopleVaccinated) as (
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint))
over(partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from covidvaccination vac
join coviddeaths dea 
    on dea.location=vac.location
    and dea.date=vac.date
where dea.continent is not null
)
select * from PopvsVac
