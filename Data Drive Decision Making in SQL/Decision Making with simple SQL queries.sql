-- First account for each country.
-- Conduct an analysis to see when the first customer accounts were created for each country.
SELECT country, -- For each country report the earliest date when an account was created
	min(date_account_start) AS first_account
FROM customers
GROUP BY country
ORDER BY first_account;

