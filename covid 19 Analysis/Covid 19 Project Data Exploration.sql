Select *
From PortfolioProject..CovidDeath 
order by 3,4 

-- Select Data  
Select location , date ,total_cases,total_deaths, Population
From CovidDeath
Order by 1,2

-- shows the percentage of dying with covid in u country if u contract with it 

Select location , date, total_cases , total_deaths ,
(total_deaths /total_cases)*100 as DeathPercentage  
From CovidDeath
Where location ='Algeria'
order by 1,2 

-- Shows the percentage of total cases  from  wordly popylation 

Select  sum(new_cases) as totalcasewordly, SUM(Population)as  sumPop ,(sum(new_cases) /SUM(Population) )
From CovidDeath
where continent is  null


--Show the percentage of covid death  from the population 

Select Location , date, total_deaths, Population, (total_deaths/Population)*100 as covdeathPerbyPO
From CovidDeath
where location like '%state%'

-- Looking at Contries with the highest infection rate compard to Population 

Select location,  Population  ,max(total_cases) as MaxCases, max(total_cases/Population)*100 as MaxInfRateCompPop
From CovidDeath 
Group by location , Population
order by  MaxInfRateCompPop Desc 

--  Showing the countrie with th death  count per population

Select location ,  max(cast (total_deaths as int )) as MaxDeath -- cast for the type 
From CovidDeath
Where continent is null 
Group by location 
order by MaxDeath Desc

-- PoPulation vs New Vacsination per Date 

Select Dea.continent, Dea.location, Dea.date, Dea.Population, Vac.new_vaccinations
From PortfolioProject..CovidDeath as Dea
Join PortfolioProject..CovidVaccination as Vac
   On Dea.location = Vac.location 
   and Dea.date = Vac.date
Where Dea.continent is not null 
order by 1,2  

-- Looking  PoPulation vs New Vacsination per Date and Total Vacc 

Select Dea.continent,Dea.location,Dea.date,Dea.Population,Vac.new_vaccinations,
Sum(Convert(int,Vac.new_vaccinations)) OVER (Partition by dea.location Order by Dea.location,
Dea.date ) as Rolling_poeple_Vacc
From CovidDeath as Dea 
Join CovidVaccination as Vac 
     ON Dea.location = Vac.location  
	 and Dea.date =  Vac.date
Where Dea.continent is not null 
Order by  1,2  

-- Looking  PoPulation vs New Vacsination per Date and Total Vacc  and percentage of people vacc wth CTE

with  PerOfP_Vac (continet,Location,date,Population,new_vaccinations, Rolling_poeple_Vacc)
as(
Select Dea.continent,Dea.location,Dea.date,Dea.Population,Vac.new_vaccinations,
Sum(Convert(int,Vac.new_vaccinations)) OVER (Partition by dea.location Order by Dea.location,
Dea.date ) as Rolling_poeple_Vacc
From CovidDeath as Dea 
Join CovidVaccination as Vac 
     ON Dea.location = Vac.location  
	 and Dea.date =  Vac.date
Where Dea.continent is not null 

)
Select *, (Rolling_poeple_Vacc / Population )*100 as PerOfP_Vac 
From PerOfP_Vac 



-- Looking  PoPulation vs New Vacsination per Date and Total Vacc  and percentage of people vacc wth Tomparary tables 

Drop Table if Exists  #PersentagePepopleVacc
Create Table #PersentagePepopleVacc (
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric ,
New_vaccinations numeric,
Rolling_poeple_Vacc numeric 
)
Insert into #PersentagePepopleVacc
Select Dea.continent,Dea.location,Dea.date,Dea.Population,Vac.new_vaccinations,
Sum(Convert(int,Vac.new_vaccinations)) OVER (Partition by dea.location Order by Dea.location,
Dea.date ) as Rolling_poeple_Vacc
From CovidDeath as Dea 
Join CovidVaccination as Vac 
     ON Dea.location = Vac.location  
	 and Dea.date =  Vac.date
Where Dea.continent is not null 
Order by 2,3

Select *, (Rolling_poeple_Vacc / Population )*100 as PerOfP_Vac 
From #PersentagePepopleVacc 

-- Creat View For Later Visualization 
Create View  PersentagePepopleVacc as 
Select Dea.continent,Dea.location,Dea.date,Dea.Population,Vac.new_vaccinations,
Sum(Convert(int,Vac.new_vaccinations)) OVER (Partition by dea.location Order by Dea.location,
Dea.date ) as Rolling_poeple_Vacc
From CovidDeath as Dea 
Join CovidVaccination as Vac 
     ON Dea.location = Vac.location  
	 and Dea.date =  Vac.date
Where Dea.continent is not null 
 









