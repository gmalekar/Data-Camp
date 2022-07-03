/***
Find Your Data
How do you find the data you need in your database in order to answer real-world business questions? 
Here you will learn how to use system tables to explore your database. 
You will use these tables to create a new tool that contains a list of all tables and columns in your database. 
Finally, you will create an Entity Relationship Diagram (ERD) which will help you connect multiple tables.
***/

/***
Determine the monthly income
Now that you know how to find the table that you need to answer a question and how to use SQL to answer that question let's practice these skills end-to-end.
How much does this business make per month?
First, you will need to use pg_catalog.pg_tables to find the possible tables and determine which tables & columns you need to answer that question. 
Second, you will leverage the tools you learned in the previous chapter to prepare the answer.
***/

-- List all tables in the public schema
SELECT * 
FROM pg_catalog.pg_tables
WHERE schemaname = 'public';

-- Explore the tables and fill in the correct one
SELECT * 
FROM payment 
LIMIT 10;

-- Prepare the result
SELECT EXTRACT(MONTH FROM payment_date) AS month, 
       SUM(amount) AS total_payment
FROM payment
GROUP BY 1;



/***
What columns are in your database?
Just like pg_catalog.pg_tables can be incredibly helpful for listing all the tables in your database, information_schema.columns 
can be used to list the columns of these tables. In this exercise, you will combine these system tables to get a list of all of the 
columns for all your tables (in the 'public' schema).

Note: These system tables are specific to PostgreSQL but similar tables exist for other databases (see slides).***/

-- Select all columns from the information_schema.columns table
select * from information_schema.columns
where table_schema = 'public'

/***
A VIEW of all your columns
In this exercise you will create a new tool for finding the tables and columns you need. 
Using the system table information_schema.columns you will concatenate the list of each table's columns into a single entry.
Once you've done this you will make this query easily reusable by creating a new VIEW for it called table_columns.
***/

-- Create a new view called table_columns
CREATE view table_columns AS
SELECT table_name, 
	   STRING_AGG(column_name, ', ') AS columns
FROM information_schema.columns
WHERE table_schema = 'public'
GROUP BY table_name;

-- Query the newly created view table_columns
select * from table_columns;


/***
The average length of films by category
From the previous exercise you've learned that the tables film and category have the necessary 
information to calculate the average movie length for every category. 
You've also learned that they share a common field film_id which can be used to join these tables. 
Now you will use this information to query a list of average length for each category. ***/
-- Calculate the average_length for each category
SELECT category, 
	   avg(length) AS average_length
FROM film AS f
-- Join the tables film & category
INNER JOIN category AS c
  ON f.film_id = c.film_id
GROUP BY 1
-- Sort the results in ascending order by length
order by 2 desc;


/***
Which films are most frequently rented?
Now that you've figured out the relationships between the tables and their columns, you are ready to answer the question we started with:

Which films are most frequently rented?
***/
SELECT title, COUNT(title)
FROM film AS f
INNER JOIN inventory AS i
  ON f.film_id = i.film_id
INNER JOIN rental AS r
  ON i.inventory_id = r.inventory_id
GROUP BY title
ORDER BY count DESC;
