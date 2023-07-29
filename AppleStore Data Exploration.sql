create table appleStore_decription_combined AS

select * from appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4;



**EXPLORATOTY DATA ANALYST (EDA)**

-- check the number of unique apps in both tablesAppleStore

SELECT COUNT(distinct id) as UniqueAppIDs
from AppleStore;

select count(DISTINCT id) as UniqueAppsIDs
from appleStore_decription_combined;

-- check for any missing values in key fields

SELECT count(*) as MissingValues
from AppleStore
where track_name is null or user_rating is null;

SELECT count(*) as MissingValues
from appleStore_decription_combined
where app_desc is null;

-- find out the number of apps per genre

SELECT prime_genre, count(*) as NumApps
from AppleStore
group by prime_genre
order by NumApps DESC;

-- get an overview of the apps rating

select min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore;

-- get the distribution of app prices

select 
	(price / 2) *2 as PriceBinStart,
    ((price / 2) *2) +2 as PriceBinEnd,
    count(*) as NumApps
from AppleStore
GROUP by PriceBinStart;

** DATA ANALYSIS**

-- determine whether paid apps have higher ratings that free apps

select CASE
		when price > 0 then 'Paid'
        ELSE 'Free'
       end as App_Type,
       avg(user_rating) as AvgRating
from AppleStore
group by App_Type;


-- check if apps with more supported languages have higher ratings

select CASE
			when lang_num < 10 then '<10 languages'
            when lang_num between 10 and 30 then '10-30 languages'
            else '>30 languages'
          end as language_bucket,
          avg(user_rating) as AvgRating
from AppleStore
group by language_bucket
ORDER BY AvgRating DESC;



-- check genres with low ratings

select prime_genre,
	   avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
ORDER BY Avg_Rating ASC
LIMIT 10;


-- check if there is correlation between the length of the app and the user rating

SELECT CASE
			when length(b.app_desc) <500 then 'Short'
            when length(b.app_desc) between 500 and 1000 then 'Medium'
            else 'Long'
          end as description_length_bucket,
          avg(a.user_rating) as AvgRating
from 
	AppleStore as A
JOIN
	appleStore_decription_combined as b
ON
	a.id = b.id

GROUP by description_length_bucket
order by AvgRating DESC;


-- check the top-rated apps for each genre

SELECT
	prime_genre,
    track_name,
    user_rating
from (
  		SELECT
  		prime_genre,
  		track_name,
  		user_rating,
  		RANK() OVER(PARTITION BY prime_genre order by user_rating desc, rating_count_tot desc) as rank
		FROM
  		appleStore
  	)AS a
WHERE
a.rank = 1;



