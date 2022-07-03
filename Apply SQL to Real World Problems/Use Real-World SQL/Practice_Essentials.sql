/***Transform numeric & strings
For this exercise you are planning to run a 50% off promotion for films released prior to 2006. 
To prepare for this promotion you will need to return the films that qualify for this promotion, 
to make these titles easier to read you will convert them all to lower case. 
You will also need to return both the original_rate and the sale_rate.
***/

SELECT lower(title) AS title, 
  rental_rate AS original_rate, 
  rental_rate * 0.5 AS sale_rate 
FROM film
-- Filter for films prior to 2006
where release_year < 2006;

/***
Aggregating finances
In this exercise you would like to learn more about the differences in payments between the customers who are active and those who are not.
***/

SELECT active, 
       count(p.payment_id) AS num_transactions, 
       avg(p.amount) AS avg_amount, 
       sum(p.amount) AS total_amount
FROM payment AS p
INNER JOIN customer AS c
  ON p.customer_id = c.customer_id
GROUP BY active;

/***
Aggregating strings
You are planning to update your storefront window to demonstrate how family-friendly and multi-lingual your DVD collection is. 
To prepare for this you need to prepare a comma-separated list G-rated film titles by language released in 2010
***/

SELECT l.name, 
	string_agg(f.title,',') AS film_titles
FROM film AS f
INNER JOIN language AS l
  ON f.language_id = l.language_id
WHERE f.rating = 'G'
  AND f.release_year = 2010
GROUP BY l.name ;
