--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  1 запрос
--%%  Выбрать режисёра, дату рождения и дату смерти, имя которого равно заданному значению.
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SELECT d.name, d.born_date, d.death_date
	FROM
		directors d
	WHERE
		d.name = 'Sidney Lumet';

--Оптимизация
--==================================================================================================

CREATE INDEX ON directors(name text_pattern_ops);
EXPLAIN (ANALYZE) SELECT d.name, d.born_date, d.death_date
	FROM
		directors d
	WHERE
		d.name = 'Sidney Lumet';

	                                                   QUERY PLAN
 Seq Scan on directors d  (cost=0.00..1.25 rows=1 width=126) (actual time=0.013..0.015 rows=1 loops=1)
  Filter: ((name)::text = 'Sidney Lumet'::text)
  Rows Removed by Filter: 19
Planning time: 0.327 ms
Execution time: 0.029 ms

--==================================================================================================

SET enable_seqscan TO off;
EXPLAIN (ANALYZE) SELECT d.name, d.born_date, d.death_date
	FROM
		directors d
	WHERE
		d.name = 'Sidney Lumet';

	                                                   QUERY PLAN
 Index Scan using directors_name_idx2 on directors d  (cost=0.14..8.15 rows=1 width=126) (actual time=0.021..0.022 rows=1 loops=1)
   Index Cond: ((name)::text = 'Sidney Lumet'::text)
 Planning time: 0.292 ms
 Execution time: 0.038 ms


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  2 запрос
--%%  Выбрать название фильма, дату релиза и кассовый сбор выпущенный после заданной даты и сбор которого больше заданного, вывести первый 10.
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

--Оптимизация
--==================================================================================================

CREATE INDEX ON movies(release_date, box_office);
EXPLAIN (ANALYZE) SELECT m.name, m.release_date, m.box_office
	FROM
		movies m
	WHERE
		m.release_date > '2000-01-01'
		AND
		m.box_office > 100
	ORDER BY
		m.release_date DESC NULLS LAST
	LIMIT 10;

	                                                   QUERY PLAN
 Limit  (cost=1.40..1.41 rows=3 width=130) (actual time=0.023..0.024 rows=5 loops=1)
   ->  Sort  (cost=1.40..1.41 rows=3 width=130) (actual time=0.023..0.024 rows=5 loops=1)
         Sort Key: release_date DESC NULLS LAST
         Sort Method: quicksort  Memory: 25kB
         ->  Seq Scan on movies m  (cost=0.00..1.38 rows=3 width=130) (actual time=0.013..0.016 rows=5 loops=1)
               Filter: ((release_date > '2000-01-01'::date) AND (box_office > '100'::double precision))
               Rows Removed by Filter: 20
 Planning time: 0.426 ms
 Execution time: 0.041 ms

--==================================================================================================

SET enable_seqscan TO off;
EXPLAIN (ANALYZE) SELECT m.name, m.release_date, m.box_office
	FROM
		movies m
	WHERE
		m.release_date > '2000-01-01'
		AND
		m.box_office > 100
	ORDER BY
		m.release_date DESC NULLS LAST
	LIMIT 10;

	                                                   QUERY PLAN
 Limit  (cost=8.27..8.28 rows=3 width=130) (actual time=0.054..0.055 rows=5 loops=1)
   ->  Sort  (cost=8.27..8.28 rows=3 width=130) (actual time=0.054..0.055 rows=5 loops=1)
         Sort Key: release_date DESC NULLS LAST
         Sort Method: quicksort  Memory: 25kB
         ->  Index Scan using movies_release_date_box_office_idx on movies m  (cost=0.14..8.25 rows=3 width=130) (actual
 time=0.043..0.045 rows=5 loops=1)
               Index Cond: ((release_date > '2000-01-01'::date) AND (box_office > '100'::double precision))
 Planning time: 0.090 ms
 Execution time: 12.784 ms


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  3 запрос
--%%  Выбрать имя актера его рост, который задан, и комплекцию и отсортировать по имени.
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

	                                                   QUERY PLAN
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

	                                                   QUERY PLAN
 Sort  (cost=8.16..8.17 rows=1 width=174) (actual time=0.059..0.059 rows=7 loops=1)
   Sort Key: name
   Sort Method: quicksort  Memory: 25kB
   ->  Index Scan using actors_height_idx1 on actors a  (cost=0.14..8.15 rows=1 width=174) (actual time=0.038..0.040 rows=7 loops=1)
         Index Cond: ((height >= '1.7'::double precision) AND (height < '1.9'::double precision))
 Planning time: 0.102 ms
 Execution time: 0.082 ms


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  4 запрос
--%%  Выбрать фильмы и сборы, где сборы больше заданного, отсортировать по длине названия и показать первые 10.
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SELECT m.name, m.box_office
	FROM
		movies m
	WHERE
		m.box_office > 100
	ORDER BY
		char_length(m.name) DESC NULLS LAST
	LIMIT 10;

--Оптимизация
--==================================================================================================

CREATE INDEX ON movies(box_office);
EXPLAIN (ANALYZE) SELECT m.name, m.box_office
	FROM
		movies m
	WHERE
		m.box_office > 100
	ORDER BY
		char_length(m.name) DESC NULLS LAST
	LIMIT 10;

		                                                   QUERY PLAN
 Limit  (cost=1.45..1.47 rows=8 width=130) (actual time=0.035..0.036 rows=10 loops=1)
   ->  Sort  (cost=1.45..1.47 rows=8 width=130) (actual time=0.035..0.035 rows=10 loops=1)
         Sort Key: (char_length((name)::text)) DESC NULLS LAST
         Sort Method: quicksort  Memory: 26kB
         ->  Seq Scan on movies m  (cost=0.00..1.33 rows=8 width=130) (actual time=0.015..0.020 rows=19 loops=1)
               Filter: (box_office > '100'::double precision)
               Rows Removed by Filter: 6
 Planning time: 0.235 ms
 Execution time: 0.053 ms

--==================================================================================================

SET enable_seqscan TO off;
EXPLAIN (ANALYZE) SELECT m.name, m.box_office
	FROM
		movies m
	WHERE
		m.box_office > 100
	ORDER BY
		char_length(m.name) DESC NULLS LAST
	LIMIT 10;

	                                                   QUERY PLAN
 Limit  (cost=8.42..8.44 rows=8 width=130) (actual time=0.078..0.080 rows=10 loops=1)
   ->  Sort  (cost=8.42..8.44 rows=8 width=130) (actual time=0.077..0.078 rows=10 loops=1)
         Sort Key: (char_length((name)::text)) DESC NULLS LAST
         Sort Method: quicksort  Memory: 26kB
         ->  Index Scan using movies_box_office_idx on movies m  (cost=0.14..8.30 rows=8 width=130) (actual time=0.049..0.061 rows=19 loops=1)
               Index Cond: (box_office > '100'::double precision)
 Planning time: 0.153 ms
 Execution time: 0.117 ms


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  5 запрос
--%%  Выбрать фильм, режисера и страну, страна которой задана.
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SELECT movies.name AS movie, directors.name AS directors, country.name AS country
    FROM movies INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	INNER JOIN directors
		ON (movies.directors_id = directors.id);


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  6 запрос
--%%  Выбрать фильм, жанр, дату релиза и имя режисера, жанр которого задан и дата релиза больше заданной.
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SELECT movies.name AS movie, genre.name AS genre, movies.release_date AS release_date, directors.name AS directors
    FROM movies INNER JOIN genre
		ON (movies.genre_id = genre.id) AND (genre.name = 'Thriller')
	INNER JOIN directors
		ON (movies.directors_id = directors.id)
	WHERE movies.release_date >= '1994-01-01';


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  7 запрос
--%%  Выбрать фильм, режиссёра, возраст режиссера когда он выпустил фильм, страну. Сортировать по возрасту.
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SELECT movies.name AS movie, directors.name AS directors, (movies.release_date - directors.born_date)/365 AS age, country.name AS country
    FROM movies INNER JOIN directors
		ON (movies.directors_id = directors.id)
	INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	ORDER BY
		(movies.release_date - directors.born_date)/365 DESC NULLS LAST;


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  8 запрос
--%%  
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  9 запрос
--%%  
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  10 запрос
--%%  
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
