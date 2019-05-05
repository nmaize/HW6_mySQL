use sakila;

-- 1a. Display the first and last names of all actors from the table `actor`.

select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

select concat_ws(" ", first_name, last_name) as "Actor Name" from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id, first_name, last_name from actor
where first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters `GEN`:

select first_name, last_name from actor
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

select actor_id, first_name, last_name from actor
where last_name like '%LI%'
order by last_name, first_name;

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

select country_id, country from country
where country in ("Afghanistan", "Bangladesh", "China");

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description`
-- and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).  Will get instruction to use BLOB/Changes needed in preferences

alter table actor
add column description int
after last_name;
select * from actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.

alter table actor drop description;

-- 4a. List the last names of actors, as well as how many actors have that last name.

select last_name,count(*) from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select last_name,count(*) from actor
group by last_name
having count(*)>1;

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

update actor
set first_name = "HARPO" 
where first_name = "GROUCHO" and last_name = "WILLIAMS";

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! 
-- In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

update actor
set first_name = "GROUCHO" 
where first_name = "HARPO" and last_name = "WILLIAMS";

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
  -- * Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)
  
show create table address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

SELECT s.first_name, s.last_name, a.address
FROM staff s JOIN address a 
ON s.address_id = a.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`:

SELECT s.first_name, s.last_name, SUM(p.amount) AS "Total Amount"
FROM staff s JOIN payment p  
ON s.staff_id = p.staff_id AND payment_date LIKE "2005-08%"
GROUP BY s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

SELECT f.title, COUNT(a.actor_id) AS "Total Number of Actors"
FROM film f INNER JOIN film_actor a ON f.film_id = a.film_id
GROUP BY f.title;


-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system? (Movie title and count)

SELECT f.title AS "Movie Title", COUNT(i.film_id) AS "Inventory Count"
FROM film f JOIN inventory i ON i.film_id= f.film_id
WHERE f.title = "Hunchback Impossible";

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
  -- ![Total amount paid](Images/total_payment.png)
  
SELECT first_name, last_name, SUM(p.amount) AS "Total Amount Paid by Customer"
FROM customer c JOIN payment p ON c.customer_id = p.customer_id
GROUP BY first_name, last_name
ORDER BY last_name;

-- 7a.The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` 
-- have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

SELECT title AS "Movie Title (Begins with K and Q" FROM film
WHERE title LIKE "K%" OR title LIKE "Q%"
AND language_id=(SELECT language_id FROM language WHERE name="English");

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT first_name, last_name FROM actor
WHERE actor_id IN (SELECT actor_id FROM film_actor 
WHERE film_id IN (SELECT film_id FROM film WHERE title="Alone Trip"));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information:

SELECT name, email
FROM customer c JOIN customer_list cl ON cl.ID = c.customer_id
WHERE country = "Canada";
 
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films:

SELECT title FROM film
WHERE film_id IN (SELECT film_id FROM film_category
WHERE category_id IN (SELECT category_id FROM category WHERE name = "Family" ));
 
 -- 7f. Write a query to display how much business, in dollars, each store brought in:

SELECT store, total_sales FROM sales_by_store;

-- 7g. Write a query to display for each store its store ID, city, and country:

SELECT store_id, city, country FROM store s
JOIN address a ON a.address_id = s.address_id
JOIN city c ON c.city_id = a.city_id
JOIN country co ON co.country_id = c.country_id;