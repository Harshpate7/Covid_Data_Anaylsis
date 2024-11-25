/*

Queries used for Tableau Project

*/

--1)

select  sum(new_cases) as Total_cases,sum(new_deaths) as Total_deaths,(sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
from covideaths
where continent is not null
order by 1,2;

--2)
--European Union is part of Europe


select  location,max(total_deaths) as TotalDeathCount
from covideaths
where continent is  null and location not in ('World','European Union','International')
group by location
order by TotalDeathCount desc nulls last;

--3)

select  location,population,max(total_cases)as HighestInfections_count,max((total_cases/population)*100) as PercentagePopulationInfected
from covideaths
group by population,location
order by PercentagePopulationInfected desc NUlls last;

--4)

select  location,population,date,max(total_cases)as HighestInfections_count,max((total_cases/population)*100) as PercentagePopulationInfected
from covideaths
group by population,location,date
order by PercentagePopulationInfected desc NUlls last;

--5)

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location,dea.date) as Cummulative_vaccination
From covideaths as dea
join covidvaccinations as vac
on dea.location = vac.location and  dea.date = vac.date
where dea.continent is not null
order by 2,3;

--6)

select  location,population,date,total_cases,total_deaths 
from covideaths
where continent is not null
order by 1,2;

--7)

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

