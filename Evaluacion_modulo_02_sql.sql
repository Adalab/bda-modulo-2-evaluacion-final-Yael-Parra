USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT DISTINCT title, rating AS Classification
FROM film
WHERE rating = "PG-13";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT DISTINCT title, description
FROM film
WHERE description LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT DISTINCT title, length
FROM film
WHERE length >= 120;

-- 5. Recupera los nombres de todos los actores.
SELECT CONCAT (first_name, " ", last_name) AS "Full Actor Name"
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT CONCAT (first_name, " ", last_name) AS "Full Actor Name"
FROM actor
WHERE last_name LIKE "%Gibson%";

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT CONCAT (first_name, " ", last_name) AS "Full Actor Name"
FROM actor
WHERE actor_id >= 10 AND WHERE actor_id <=20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title, rating AS Classification
FROM film
WHERE rating NOT IN ('R', 'PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT rating AS Classification, COUNT(title) AS Qty
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT customer.customer_id, CONCAT(customer.first_name, " ",customer.last_name) AS "Full Customer Name", COUNT(rental.rental_id) AS  "Qty of rented movies"
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
/* Las tablas necesarias para obtener la información son category y rental. Visto que estas no se pueden unir de forma directa, se busca un camino
que las pueda unir. Para esto, se revisan las columnas y sus datos y restricciones con la mira de unir todos los puntos necesarios hasta llegar a 
poder unir category con rental*/
SELECT category.category_id, category.name, COUNT(rental.rental_id) AS "Qty of rented movies"
FROM category
JOIN  film_category ON category.category_id = film_category.category_id 
JOIN inventory ON film_category.film_id = inventory.film_id
JOIN  rental ON inventory.inventory_id = rental.inventory_id
GROUP BY category.category_id, category.name;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
/*El resultado ha sido redondeado para facilitar la lectura del mismo*/
SELECT film.rating AS Classification, ROUND(AVG(film.length), 2) AS "Average Length in Minutes"
FROM film
GROUP BY film.rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
/*Las tablas necesarias para obtener la información son actor y film. Dado que no se pueden unir entre sí de forma natural, se busca un camino para
poder unirlas, este se hizo a través de film_actor ya que contenía las columnas adecuadas para unir actor con film */
SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS "Full Actor Name"
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film.film_id = film_actor.film_id
WHERE film.title LIKE '%Indian Love%';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT film.title
FROM film
WHERE title LIKE "%dog%" OR "%cat%";

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
SELECT title, description
FROM film
WHERE description LIKE "%dog%" OR  description LIKE "%cat%";

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title, release_year
FROM film
WHERE release_year >=2005 AND release_year <=2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT DISTINCT film.title,  category.name
FROM film
JOIN film_category ON film_category.film_id= film.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = "Family";

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
/*Las tablas que contienen la información necesaria para la consulta son actor y film. Visto que son tablas distintas y para esta consulta se
requeren ambas, se deben de unir, para esto utilizamos el operador join. Ya que las tablas no se pueden unir unicamente entre sí, se hace un segundo
JOIN buscando una tabla que pueda unir a actor y film, esta tabla es actor_film y para poder unirlas se buscan los puntos que las pueden unir y 
conla palabra reservada ON, se efectúa la unión. Igualmente es necesaria una cláusula GROUP BY para poder agrupar el resultado por actores ya que
es lo que nos han solicitado, también ha sido necesaria la cláusula HAVING para filtrar el resultado obtenido con GROUP BY que indica sólo los que
son superiores a 10.*/
SELECT CONCAT (actor.first_name, " ", actor.last_name) AS "Full Actor Name",  COUNT(film.film_id) AS "Qty of movies"
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film.film_id = film_actor.film_id
GROUP BY CONCAT (actor.first_name, " ", actor.last_name)
HAVING COUNT(film.film_id) >10;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title AS Movie, rating AS Classification, length AS Length
FROM film
WHERE rating = "R" AND length >120;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
/* Las tablas que contienen la información necesaria son category y film. Puesto que no se pueden unir entre sí, se busca una tercera tabla que pueda unirlas,
para esto usamos dos operadores JOIN buscando la columna con los datos apropiados que las puedan unir. Igualmente visto que contamos con una función de agregación
en el selector, usamos la cláusula GROUP BY así como su cláusa de filtro HAVING*/
SELECT category.name, ROUND(AVG(film.length),2) AS "Length Avarage"
FROM category
JOIN film_category ON film_category.film_id= category.category_id
JOIN film ON film.film_id = film_category.film_id
GROUP BY category.name
HAVING AVG(film.length) >120;
 
-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
/*La info necesaria está en las tablas actor y film_actor. Visto que son tablas distintas, para unirlas se usa el operador JOIN. Igualmente nos
piden el conteo de las películas, esto hace que haya una función de agregación en el selector por lo que la cláusla de GROUP BY es necesaria. Para 
poder dar el resultado de mayor igual al conteo, debemos de filtrar el resultado del grupaje y esto se hace con la cláusula HAVING*/
SELECT CONCAT(actor.first_name, " ", actor.last_name) AS "Full Actor Name", COUNT(film_actor.film_id) AS "Qty of Movies"
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY CONCAT(actor.first_name, " ", actor.last_name)
HAVING COUNT(film_id) >= 5;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
/* Para calcular el número de días que se ha alquilado, se usa la función DATEDIFF. Debido a que las tablas de donde se debe de obtener la información,
no se pueden relacionar directamente, se busca relacionarlas a través de la tabla inventory. Al final, se le añade una subconsulta para indicar
que muestre los datos únicamente de los alquileres superiores a 5 días.*/
SELECT film.film_id, film.title, DATEDIFF(rental.return_date, rental.rental_date) AS "Days rented"
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IN (
    SELECT rental_id
    FROM rental
    WHERE DATEDIFF(return_date, rental_date) > 5
);


-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
/*Debido a que los datos están en tablas no relacionadas de forma natural (actor y categoría [horror] ), buscando los puntos de conexión entre 
actor y categoría, se determina que se debe de buscar mediante actor_id y se hacen las uniones necesarias para conectarlos.*/
SELECT CONCAT(actor.first_name, " ", actor.last_name) AS "Actor Name"
FROM actor
WHERE actor.actor_id NOT IN (
							SELECT DISTINCT film_actor.actor_id
							FROM film_actor
							JOIN film ON film_actor.film_id = film.film_id
							JOIN film_category ON film.film_id = film_category.film_id
							JOIN category ON film_category.category_id = category.category_id
							WHERE category.name = "Horror");

-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
SELECT film.title, category.name, film.length
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON category.category_id = film_category.category_id
WHERE category.name = "Comedy" AND film.length >180;

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
