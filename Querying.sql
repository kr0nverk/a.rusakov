--==================================================================================================
--1 запрос
--Выбрать режисёра, дату рождения и дату смерти, имя которого равно заданному значению.
--==================================================================================================

SELECT d.name, d.born_date, d.death_date
	FROM
		directors d
	WHERE
		d.name = 'Sidney Lumet';

--Оптимизация
--==================================================================================================
CREATE INDEX ON directors(name);
EXPLAIN (ANALYZE) SELECT d.name, d.born_date, d.death_date
	FROM
		directors d
	WHERE
		d.name = 'Sidney Lumet';

 Seq Scan on directors d  (cost=0.00..1.25 rows=1 width=126) (actual time=0.020..0.022 rows=1 loops=1)
   Filter: ((name)::text = 'Sidney Lumet'::text)
   Rows Removed by Filter: 19
 Planning time: 29.638 ms
 Execution time: 0.037 ms

--==================================================================================================
SET enable_seqscan TO off;
EXPLAIN (ANALYZE) SELECT d.name, d.born_date, d.death_date
	FROM
		directors d
	WHERE
		d.name = 'Sidney Lumet';

Index Scan using directors_name_idx on directors d  (cost=0.14..8.15 rows=1 width=126) (actual time=0.082..0.084 rows=1 loops=1)
  Index Cond: ((name)::text = 'Sidney Lumet'::text)
Planning time: 0.132 ms
Execution time: 0.110 ms

--==================================================================================================
--2 запрос
--Выбрать название фильма, дату релиза и кассовый сбор выпущенный после заданной даты и сбор которого больше заданного, вывести первый 10.
--==================================================================================================

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
--==================================================================================================
--==================================================================================================

--==================================================================================================
--3 запрос
--Выбрать имя актера его рост, который задан, и комплекцию и отсортировать по имени.
--==================================================================================================

SELECT a.name, a.height, a.complexion
	FROM
		actors a
	WHERE
		a.height>=1.70
		AND
		a.height<1.90
	ORDER BY
		a.name;

--Оптимизация
--==================================================================================================

CREATE INDEX ON actors(height);
EXPLAIN (ANALYZE) SELECT a.name, a.height, a.complexion
	FROM
		actors a
	WHERE
		a.height>=1.70
		AND
		a.height<1.90
	ORDER BY
		a.name;


Sort  (cost=1.15..1.15 rows=1 width=174) (actual time=0.030..0.030 rows=7 loops=1)
  Sort Key: name
  Sort Method: quicksort  Memory: 25kB
  ->  Seq Scan on actors a  (cost=0.00..1.14 rows=1 width=174) (actual time=0.010..0.012 rows=7 loops=1)
        Filter: ((height >= '1.7'::double precision) AND (height < '1.9'::double precision))
        Rows Removed by Filter: 2
Planning time: 0.269 ms
Execution time: 0.046 ms

--==================================================================================================
SET enable_seqscan TO off;
EXPLAIN (ANALYZE) SELECT a.name, a.height, a.complexion
	FROM
		actors a
	WHERE
		a.height>=1.70
		AND
		a.height<1.90
	ORDER BY
		a.name;


 Sort  (cost=8.16..8.17 rows=1 width=174) (actual time=0.059..0.059 rows=7 loops=1)
   Sort Key: name
   Sort Method: quicksort  Memory: 25kB
   ->  Index Scan using actors_height_idx1 on actors a  (cost=0.14..8.15 rows=1 width=174) (actual time=0.038..0.040 rows=7 loops=1)
         Index Cond: ((height >= '1.7'::double precision) AND (height < '1.9'::double precision))
 Planning time: 0.102 ms
 Execution time: 0.082 ms


 --==================================================================================================
--4 запрос
--Выбрать фильмы и сборы, где сборы больше заданного, отсортировать по длине названия и показать первые 10.
--==================================================================================================

SELECT m.name, m.box_office
	FROM
		movies m
	WHERE
		m.box_office > 100
	ORDER BY
		char_length(m.name) DESC NULLS LAST
	LIMIT 10;

--==================================================================================================
--==================================================================================================

--==================================================================================================
--5 запрос
--Выбрать фильм, режисера и страну, страна которой задана.
--==================================================================================================

SELECT movies.name AS movie, directors.name AS directors, country.name AS country
    FROM movies INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	INNER JOIN directors
		ON (movies.directors_id = directors.id);

--==================================================================================================
--6 запрос
--Выбрать фильм, жанр, дату релиза и имя режисера, жанр которого задан и дата релиза больше заданной.
--==================================================================================================

SELECT movies.name AS movie, genre.name AS genre, movies.release_date AS release_date, directors.name AS directors
    FROM movies INNER JOIN genre
		ON (movies.genre_id = genre.id) AND (genre.name = 'Thriller')
	INNER JOIN directors
		ON (movies.directors_id = directors.id)
	WHERE movies.release_date >= '1994-01-01';

--==================================================================================================
--7 запрос
--Выбрать фильм, режиссёра, возраст режиссера когда он выпустил фильм, страну. Сортировать по возрасту.
--==================================================================================================
  
SELECT movies.name AS movie, directors.name AS directors, (movies.release_date - directors.born_date)/365 AS age, country.name AS country
    FROM movies INNER JOIN directors
		ON (movies.directors_id = directors.id)
	INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	ORDER BY
		(movies.release_date - directors.born_date)/365 DESC NULLS LAST;