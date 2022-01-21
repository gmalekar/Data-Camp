-- First account for each country.
-- Conduct an analysis to see when the first customer accounts were created for each country.
SELECT country, -- For each country report the earliest date when an account was created
	min(date_account_start) AS first_account
FROM customers
GROUP BY country
ORDER BY first_account;

--Average movie ratings
--For each movie the average rating, the number of ratings and the number of views has to be reported. Generate a table with meaningful column names.
SELECT movie_id, 
       AVG(rating) AS avg_rating,
       COUNT(rating) AS number_ratings,
       COUNT(*) AS number_renting
FROM renting
GROUP BY movie_id
ORDER BY avg_rating DESC; -- Order by average rating in decreasing order

--Average rating per customer
/*** 
Similar to what you just did, you will now look at the average movie ratings, this time for customers. 
So you will obtain a table with the average rating given by each customer. 
Further, you will include the number of ratings and the number of movie rentals per customer. 
You will report these summary statistics only for customers with more than 7 movie rentals and order them in ascending order by the average rating. 
***/
SELECT customer_id, -- Report the customer_id
      avg(rating),  -- Report the average rating per customer
      count(rating),  -- Report the number of ratings per customer
      count(renting_id)  -- Report the number of movie rentals per customer
FROM renting
GROUP BY customer_id
HAVING count(renting_id)>7  -- Select only customers with more than 7 movie rentals
ORDER BY 2; -- Order by the average rating in ascending order

--Join renting and customers
SELECT AVG(rating) -- Average ratings of customers from Belgium
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
WHERE c.country='Belgium';

/***
Aggregating revenue, rentals and active customers
The management of MovieNow wants to report key performance indicators (KPIs) for the performance of the company in 2018. 
They are interested in measuring the financial successes as well as user engagement. 
Important KPIs are, therefore, the profit coming from movie rentals, the number of movie rentals and the number of active customers.
***/
SELECT 
	SUM(m.renting_price), 
	COUNT(*), 
	COUNT(DISTINCT r.customer_id)
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
-- Only look at movie rentals in 2018
WHERE date_trunc('year',date_renting) =date'2018-01-01'  ;

/***
Movies and actors
You are asked to give an overview of which actors play in which movie.
***/

SELECT m.title, -- Create a list of movie titles and actor names
       a.name
FROM actsin as ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
LEFT JOIN actors AS a
ON a.actor_id = ai.actor_id;

/***
Income from movies
How much income did each movie generate? To answer this question subsequent SELECT statements can be used.
***/
SELECT title -- Report the income from movie rentals for each movie 
       ,SUM(renting_price) AS income_movie
FROM
       (SELECT m.title,  
               m.renting_price
       FROM renting AS r
       LEFT JOIN movies AS m
       ON r.movie_id=m.movie_id) AS rm
GROUP BY 1
ORDER BY 2 DESC; -- Order the result by decreasing income

/***
Age of actors from the USA
Now you will explore the age of American actors and actresses. Report the date of birth of the oldest and youngest US actor and actress.
***/

SELECT gender
,min(year_of_birth)
,max(year_of_birth)
   FROM
   actors
   WHERE nationality = 'USA'
   GROUP BY 1

/***
Identify favorite movies for a group of customers
Which is the favorite movie on MovieNow? Answer this question for a specific group of customers: for all customers born in the 70s.
***/
SELECT m.title, 
COUNT(*),
AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title
HAVING COUNT(*) > 1 -- Remove movies with only one rental
ORDER BY 3 DESC; -- Order with highest rating first
