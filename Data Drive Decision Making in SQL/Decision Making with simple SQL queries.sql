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
