--1--
SELECT * FROM (SELECT * FROM country ORDER BY country_id ASC) AS ordered
	WHERE ordered.country_id >= 12 AND ordered.country_id <= 17;
--2--
SELECT * FROM (SELECT * FROM city AS cities, address AS addresses
	WHERE cities.city_id = addresses.city_id) AS cities_addresses
	WHERE SUBSTRING(cities_addresses.city, 1, 1) = 'A';
--3--
SELECT first_name, last_name, city FROM 
	(SELECT * FROM customer AS customers, address as addresses, city as cities 
	WHERE customers.address_id = addresses.address_id AND addresses.city_id = cities.city_id) 
	AS cities_addresses_customers;
--4--
SELECT DISTINCT * FROM
	(SELECT * FROM customer AS customers, payment AS payments 
	WHERE customers.customer_id = payments.customer_id) AS customers_payments WHERE amount > 11;
--5--
SELECT DISTINCT c1.first_name FROM customer AS c1, customer AS c2
	WHERE c1.first_name = c2.first_name AND c1.customer_id != c2.customer_id;

