select  * from covideaths;

select  location,date,total_cases,new_cases,total_deaths,population from covideaths
order by 1,2;

--Total cases vs Total deaths
--Showa the likelihood of dying if you contract covid 
select  location,date,total_cases,total_deaths,population,(total_deaths/total_cases)*100 as DeathPercentage
from covideaths
where location like 'India'
order by 1,2;

-- looking at the Total cases vs population
--showa what percentage got in covid
select  location,date,total_cases,population,(total_cases/population)*100 as PercentagePopulationInfected
from covideaths
where location like '%States%'
order by 1,2;


--Countries with Highest Infection Rate
select  location,population,max(total_cases)as HighestInfections_count,max((total_cases/population)*100) as PercentagePopulationInfected
from covideaths
group by population,location

order by PercentagePopulationInfected desc NUlls last;

-- Showing Highest deathcount Population

select  location,max(total_deaths) as TotalDeathCount
from covideaths
where continent is not null
group by location
order by TotalDeathCount desc nulls last;

-- Showing Highest deathcount by Continent

select  location,max(total_deaths) as TotalDeathCount
from covideaths
where continent is  null
group by location
order by TotalDeathCount desc nulls last;

-- SHowing which country had highest Death Count by Contienet

SELECT DISTINCT ON (continent) 
    continent, 
    location AS country, 
    total_deaths AS TotalDeathCount
FROM covideaths
WHERE continent IS NOT NULL 
ORDER BY continent, total_deaths DESC nulls last;

-- Global Numbers

select  date,sum(new_cases) as Total_cases,sum(new_deaths) as Total_deaths,(sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from covideaths
where continent is not null
group by date
order by 1;

-- Looking Total population vs Vaccination

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location,dea.date) as Cummulative_vaccination
From covideaths as dea
join covidvaccinations as vac
on dea.location = vac.location and  dea.date = vac.date
where dea.continent is not null
order by 2,3;

--Percentage by which people getting vaccinated  
with data as (
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location,dea.date) as Cummulative_vaccination
From covideaths as dea
join covidvaccinations as vac
on dea.location = vac.location and  dea.date = vac.date
where dea.continent is not null
order by 2,3)

select continent,location,date,population,new_vaccinations,Cummulative_vaccination,(Cummulative_vaccination/population)* 100 PercentPeopleVaccinated 
from data;

Create view  Percentpeoplevaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location,dea.date) as Cummulative_vaccination
From covideaths as dea
join covidvaccinations as vac
on dea.location = vac.location and  dea.date = vac.date
where dea.continent is not null
order by 2,3;

select * from Percentpeoplevaccinated


