#previewing the data and checking for duplicates and nulls
select * from museums;

select `Museum ID`, count(`Museum ID`) from museums group by `Museum ID` having count(`Museum ID`) >1 ; 
#no duplicates found

select * from museums where `Museum ID` = null or "";
#no empty rows found 


#joining all tables together
SELECT 
        a.abbreviation, p.state, p.`2018 Population` AS population
    FROM
        museums.state_abbr_name AS a
    JOIN museums.state_populations AS p ON a.name = p.state 
        LEFT JOIN
    museums.museums ON museums.`State (Administrative Location)` = p.abbreviation;

#creating new table
CREATE TABLE museums.new_museum AS (SELECT * FROM
    (SELECT 
        a.abbreviation, p.state, p.`2018 Population` AS population
    FROM
        museums.state_abbr_name AS a
    JOIN museums.state_populations AS p ON a.name = p.state) AS populations
        LEFT JOIN
    museums.museums ON museums.`State (Administrative Location)` = populations.abbreviation);

SELECT * FROM museums.new_museum;
 alter table new_museum rename column`City (Administrative Location)` to city;
 alter table new_museum drop column `State (Administrative Location)`;
 alter table new_museum rename column abbreviation to state_abbr;
 
 
 #top states with the highest museum per capita 
SELECT 
    state,
    population,
    state,
    COUNT(`Museum ID`),
    COUNT(`Museum ID`) / population AS per_capita
FROM
    new_museum
GROUP BY state
ORDER BY per_capita DESC;


#top cities with the highest museum
select count(`Museum ID`) as museum_count, city  from new_museum group by city order by museum_count desc ;

#top states with the highest museum
select count(`Museum ID`) as museum_count, city  from new_museum group by city order by museum_count desc ;

#state with the highest revenue
select `Museum ID`,`Museum Name`,City, max(revenue) from new_museum ;

# types of museums
select distinct(`Museum Type`) from new_museum group by `Museum Type`;

#total number of for each type
select`Museum Type`, count(`Museum ID`) as museum_count from new_museum group by `Museum Type` order by museum_count desc ;

#number of university owned museums
select count(`Museum ID`) from new_museum where `Institution Name` <> "";

#universities with the top number of museums
select count(`Museum ID`) as inst_count, `Institution Name` from new_museum group by `Institution Name` order by inst_count desc ;
