--1 запрос
--¬ыбрать режисЄра, дату рождени€ и дату смерти, им€ которого равно заданному значению.

SELECT d.name, d.born_date, d.death_date
	FROM
		directors d
	WHERE
		d.name = 'Sidney Lumet';


--2 запрос
--¬ыбрать название фильма, дату релиза и кассовый сбор выпущенный после заданной даты и сбор которого больше заданного, вывести первый 10.

SELECT m.name, m.release_date, m.box_office
	FROM
		movies m
	WHERE
		m.release_date > '2000-01-01'
		AND
		m.box_office > 100
	ORDER BY
		m.release_date DESC NULLS LAST
	LIMIT 10;


--3 запрос
--¬ыбрать им€ актера его рост, который задан, и комплекцию и отсортировать по имени.

SELECT a.name, a.height, a.complexion
	FROM
		actors a
	WHERE
		a.height>=1.70
		AND
		a.height<1.90
	ORDER BY
		a.name;

--4 запрос
--¬ыбрать фильмы и сборы, где сборы больше заданного, отсортировать по длине названи€ и показать первые 10.

SELECT m.name, m.box_office
	FROM
		movies m
	WHERE
		m.box_office > 100
	ORDER BY
		char_length(m.name) DESC NULLS LAST
	LIMIT 10;


--5 запрос
--¬ыбрать фильм, режисера и страну, страна которой задана.

SELECT movies.name AS movie, directors.name AS directors, country.name AS country
    FROM movies INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	INNER JOIN directors
		ON (movies.directors_id = directors.id);

--8 запрос
--¬ыбрать фильм, жанр, дату релиза и им€ режисера, жанр которого задан и дата релиза больше заданной.

SELECT movies.name AS movie, genre.name AS genre, movies.release_date AS release_date, directors.name AS directors
    FROM movies INNER JOIN genre
		ON (movies.genre_id = genre.id) AND (genre.name = 'Thriller')
	INNER JOIN directors
		ON (movies.directors_id = directors.id)
	WHERE movies.release_date >= '1994-01-01';

--7 запрос
--¬ыбрать фильм, режиссЄра, возраст режиссера когда он выпустил фильм, страну. —ортировать по возрасту.
  
SELECT movies.name AS movie, directors.name AS directors, (movies.release_date - directors.born_date)/365 AS age, country.name AS country
    FROM movies INNER JOIN directors
		ON (movies.directors_id = directors.id)
	INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	ORDER BY
		(movies.release_date - directors.born_date)/365 DESC NULLS LAST;