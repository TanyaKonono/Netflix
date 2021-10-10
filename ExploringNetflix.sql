/*
EXPLORING NETFLIX
10 OCTOBER 2021
TANYARADZWA KONONO

tags: Inner Joins; Group By Statement, Aggregate functions 
*/
--------


Use Netfix
Go

/********************************************** EXPLORE THE SHOWS **************************************************/
-- Investigating the relationships
Select 
	M.title,
	Max(M.duration_seasons) as NumberOfSeasons,
	Sum(M.duration_minutes) as TotalRunTime,
	Count(Distinct Ctry.Country) NumberOfCountries,
	Count(Distinct M.type)	as NumberOfTypes, 
	Count(distinct M.rating) as NumberOfRatings, 
	Count(distinct M.show_id) as NumberOfIds,
	Count(distinct D.director) as NumberOfDirectors,
	Count(distinct Ctg.listed_in) as NumberOfCategories,
	Count(distinct Cst.Cast) as NumberOfActors
from MainTable M
	Inner Join DirectorTable D on M.show_id = D.show_id
	Inner Join CountryTable Cty on M.show_id = Cty.show_id
	Inner Join CategoryTable Ctg on M.show_id = Ctg.show_id
	Inner Join CastTable Cst on Cst.show_id = M.show_id
	Inner Join CountryTable Ctry on Ctry.show_id = M.show_id
Group By title


/************************************* EXPLORE THE DIRECTORS ***************************************/

-- Director Creativity: A director's creativity = f(number of Genres). The higher the number the more creative a director is.
Select D.Director, Count(Distinct C.listed_in) as NumberOfGenres
from DirectorTable D inner Join CategoryTable C on D.show_id = C.show_id
Group by Director

-- Director Experience in Years
Select D.Director, Min(M.release_year) as [Started], Max(M.release_year) - Min(M.release_year) as  YearsExperience   
From DirectorTable D inner Join MainTable M 
On M.show_id = D.show_id
Group By director
Order by YearsExperience Desc

-- Director Output: The more number of shows the director has produced the better
Select D.director, count(distinct M.show_id) as NumberOfShows 
From DirectorTable D inner Join MainTable M 
On M.show_id = D.show_id
Group By director
Order by NumberOfShows Desc

-- Director People Skills: We can say the more the different people the director has worked with, the better people skills he has.
Select D.director, count(distinct Cs.cast) as PeopleScore 
From DirectorTable D inner Join CastTable Cs 
On Cs.show_id = D.show_id
Group By director
Order by PeopleScore Desc


-- Director Score
Select 
	D.Director, 
	(Count(Distinct C.listed_in) + Count(distinct Cs.cast) + count(distinct M.show_id))/(Max(M.release_year) - Min(M.release_year) + 1) as DirectorScore 
from DirectorTable D 
	Inner Join CategoryTable C on D.show_id = C.show_id
	Inner join MainTable M on M.show_id = C.show_id
	Inner Join CastTable Cs on M.show_id = Cs.show_id
Group by Director
Order By DirectorScore Desc


-- Combined Director Table
Select 
	D.Director, 
	Count(Distinct C.listed_in) as NumberOfGenres, 
	Count(distinct M.show_id) as NumberOfShows, 
	Count(distinct Cs.cast) as PeopleScore,
	Max(M.release_year) - Min(M.release_year) as  Duration,
	(Count(Distinct C.listed_in) + Count(distinct Cs.cast) + count(distinct M.show_id))/(Max(M.release_year) - Min(M.release_year) + 1) as DirectorScore 
from DirectorTable D 
	Inner Join CategoryTable C on D.show_id = C.show_id
	Inner join MainTable M on M.show_id = C.show_id
	Inner Join CastTable Cs on M.show_id = Cs.show_id
Group by Director
Order By DirectorScore Desc


/********************************************** EXPLORE THE CAST **************************************************/
Select 
	Cs.[cast], 
	Count(Distinct C.listed_in) as NumberOfGenres, 
	Count(Distinct M.show_id) as NumberOfShows, 
	Count(Distinct D.director) as DirectorsWorkedWith,	
	Max(M.release_year) - Min(M.release_year) as  Duration,
	(Count(Distinct C.listed_in) + Count(Distinct M.show_id))/(Max(M.release_year) - Min(M.release_year) + 1) as CastScore
from CastTable Cs 
	Inner Join CategoryTable C on Cs.show_id = C.show_id
	Inner join MainTable M on M.show_id = C.show_id
	Inner join DirectorTable D on D.show_id = Cs.show_id
Group by Cs.[cast]
Order By CastScore Desc

/********************************************** EXPLORE THE COUNTRIES **************************************************/
Select
	Ctry.country,
	Count(Distinct C.listed_in) as NumberOfGenres,
	Count(Distinct M.show_id) as NumberOfShows,
	Sum(M.duration_minutes) as TotalMinutes,
	Count(Distinct Cs.[cast]) as Actors
from CountryTable Ctry
	Inner Join CategoryTable C on Ctry.Show_id = C.show_id
	Inner join MainTable M on M.show_id = C.show_id
	Inner join DirectorTable D on D.show_id = Ctry.show_id
	Inner Join CastTable Cs on Cs.show_id = Ctry.show_id
	Where M.duration_minutes is not null
Group by Ctry.country


/*********************************OTHER FIGURES FROM THE DATA**************************************/
Select 
	Max(M.duration_seasons) as NumberOfSeasons,
	Sum(M.duration_minutes) as TotalRunTime,
	Count(Distinct Ctry.Country) NumberOfCountries,
	Count(Distinct M.type)	as NumberOfTypes, 
	Count(distinct M.rating) as NumberOfRatings, 
	Count(distinct M.show_id) as NumberOfIds,
	Count(distinct D.director) as NumberOfDirectors,
	Count(distinct Ctg.listed_in) as NumberOfCategories,
	Count(distinct Cst.Cast) as NumberOfActors
from MainTable M
	Inner Join DirectorTable D on M.show_id = D.show_id
	Inner Join CountryTable Cty on M.show_id = Cty.show_id
	Inner Join CategoryTable Ctg on M.show_id = Ctg.show_id
	Inner Join CastTable Cst on Cst.show_id = M.show_id
	Inner Join CountryTable Ctry on Ctry.show_id = M.show_id