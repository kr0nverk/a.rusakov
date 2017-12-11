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

--Оптимизация
--==================================================================================================

CREATE INDEX ON country(name);
EXPLAIN (ANALYZE) SELECT movies.name AS movie, directors.name AS directors, country.name AS country
    FROM movies INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	INNER JOIN directors
		ON (movies.directors_id = directors.id);

	                                                   QUERY PLAN
 Hash Join  (cost=2.50..3.81 rows=4 width=294) (actual time=0.081..0.083 rows=3 loops=1)
   Hash Cond: (directors.id = movies.directors_id)
   ->  Seq Scan on directors  (cost=0.00..1.20 rows=20 width=122) (actual time=0.018..0.019 rows=20 loops=1)
   ->  Hash  (cost=2.45..2.45 rows=4 width=180) (actual time=0.037..0.037 rows=3 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 9kB
         ->  Hash Join  (cost=1.10..2.45 rows=4 width=180) (actual time=0.030..0.034 rows=3 loops=1)
               Hash Cond: (movies.country_id = country.id)
               ->  Seq Scan on movies  (cost=0.00..1.25 rows=25 width=126) (actual time=0.007..0.008 rows=25 loops=1)
               ->  Hash  (cost=1.09..1.09 rows=1 width=62) (actual time=0.015..0.015 rows=1 loops=1)
                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
                     ->  Seq Scan on country  (cost=0.00..1.09 rows=1 width=62) (actual time=0.011..0.011 rows=1 loops=1)
                           Filter: ((name)::text = 'New Zealand'::text)
                           Rows Removed by Filter: 6
 Planning time: 153.591 ms
 Execution time: 0.143 ms

--==================================================================================================

SET enable_seqscan TO off;
EXPLAIN (ANALYZE) SELECT movies.name AS movie, directors.name AS directors, country.name AS country
    FROM movies INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	INNER JOIN directors
		ON (movies.directors_id = directors.id);

	                                                   QUERY PLAN
 Nested Loop  (cost=10000000000.27..10000000012.36 rows=4 width=294) (actual time=0.081..0.089 rows=3 loops=1)
   ->  Nested Loop  (cost=10000000000.13..10000000009.78 rows=4 width=180) (actual time=0.075..0.080 rows=3 loops=1)
         Join Filter: (movies.country_id = country.id)
         Rows Removed by Join Filter: 22
         ->  Seq Scan on movies  (cost=10000000000.00..10000000001.25 rows=25 width=126) (actual time=0.013..0.013 rows=25 loops=1)
         ->  Materialize  (cost=0.13..8.16 rows=1 width=62) (actual time=0.002..0.002 rows=1 loops=25)
               ->  Index Scan using country_name_idx on country  (cost=0.13..8.15 rows=1 width=62) (actual time=0.052..0.053 rows=1 loops=1)
                     Index Cond: ((name)::text = 'New Zealand'::text)
   ->  Index Scan using directors_pkey on directors  (cost=0.14..0.64 rows=1 width=122) (actual time=0.002..0.002 rows=1 loops=3)
         Index Cond: (id = movies.directors_id)
 Planning time: 0.238 ms
 Execution time: 0.134 ms


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

--Оптимизация
--==================================================================================================

CREATE INDEX ON movies(release_date);
CREATE INDEX ON genre(name);
EXPLAIN (ANALYZE) SELECT movies.name AS movie, genre.name AS genre, movies.release_date AS release_date, directors.name AS directors
    FROM movies INNER JOIN genre
		ON (movies.genre_id = genre.id) AND (genre.name = 'Thriller')
	INNER JOIN directors
		ON (movies.directors_id = directors.id)
	WHERE movies.release_date >= '1994-01-01';

	                                                   QUERY PLAN
 Hash Join  (cost=2.49..3.78 rows=1 width=298) (actual time=0.038..0.040 rows=2 loops=1)
   Hash Cond: (directors.id = movies.directors_id)
   ->  Seq Scan on directors  (cost=0.00..1.20 rows=20 width=122) (actual time=0.007..0.008 rows=20 loops=1)
   ->  Hash  (cost=2.48..2.48 rows=1 width=184) (actual time=0.025..0.025 rows=2 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 9kB
         ->  Hash Join  (cost=1.13..2.48 rows=1 width=184) (actual time=0.020..0.023 rows=2 loops=1)
               Hash Cond: (movies.genre_id = genre.id)
               ->  Seq Scan on movies  (cost=0.00..1.31 rows=8 width=130) (actual time=0.006..0.009 rows=13 loops=1)
                     Filter: (release_date >= '1994-01-01'::date)
                     Rows Removed by Filter: 12
               ->  Hash  (cost=1.11..1.11 rows=1 width=62) (actual time=0.008..0.008 rows=1 loops=1)
                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
                     ->  Seq Scan on genre  (cost=0.00..1.11 rows=1 width=62) (actual time=0.005..0.006 rows=1 loops=1)
                           Filter: ((name)::text = 'Thriller'::text)
                           Rows Removed by Filter: 8
 Planning time: 0.464 ms
 Execution time: 0.083 ms

--==================================================================================================

SET enable_seqscan TO off;
EXPLAIN (ANALYZE) SELECT movies.name AS movie, genre.name AS genre, movies.release_date AS release_date, directors.name AS directors
    FROM movies INNER JOIN genre
		ON (movies.genre_id = genre.id) AND (genre.name = 'Thriller')
	INNER JOIN directors
		ON (movies.directors_id = directors.id)
	WHERE movies.release_date >= '1994-01-01';

	                                                   QUERY PLAN
 Nested Loop  (cost=0.41..18.20 rows=1 width=298) (actual time=0.077..0.081 rows=2 loops=1)
   ->  Nested Loop  (cost=0.27..16.53 rows=1 width=184) (actual time=0.073..0.076 rows=2 loops=1)
         Join Filter: (movies.genre_id = genre.id)
         Rows Removed by Join Filter: 11
         ->  Index Scan using genre_name_idx on genre  (cost=0.14..8.15 rows=1 width=62) (actual time=0.043..0.043 rows=1 loops=1)
               Index Cond: ((name)::text = 'Thriller'::text)
         ->  Index Scan using movies_release_date_idx on movies  (cost=0.14..8.28 rows=8 width=130) (actual time=0.024..0.027 rows=13 loops=1)
               Index Cond: (release_date >= '1994-01-01'::date)
   ->  Index Scan using directors_pkey on directors  (cost=0.14..1.66 rows=1 width=122) (actual time=0.002..0.002 rows=1 loops=2)
         Index Cond: (id = movies.directors_id)
 Planning time: 0.210 ms
 Execution time: 0.121 ms


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  7 запрос
--%%  Выбрать фильм, режиссёра, возраст режиссера когда он выпустил фильм, страну. Сортировать по возрасту.
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SELECT movies.name AS movie, directors.name AS directors, age(movies.release_date, directors.born_date) AS age, country.name AS country
    FROM movies INNER JOIN directors
		ON (movies.directors_id = directors.id)
	INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	ORDER BY
		age(movies.release_date, directors.born_date) DESC NULLS LAST;

--Оптимизация
--==================================================================================================

CREATE INDEX ON country(name);
EXPLAIN (ANALYZE) SELECT movies.name AS movie, directors.name AS directors, age(movies.release_date, directors.born_date) AS age, country.name AS country
    FROM movies INNER JOIN directors
		ON (movies.directors_id = directors.id)
	INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	ORDER BY
		age(movies.release_date, directors.born_date) DESC NULLS LAST;

	                                                   QUERY PLAN
 Sort  (cost=3.88..3.89 rows=4 width=310) (actual time=19.489..19.489 rows=3 loops=1)
   Sort Key: (age((movies.release_date)::timestamp with time zone, (directors.born_date)::timestamp with time zone)) DESC NULLS LAST
   Sort Method: quicksort  Memory: 25kB
   ->  Hash Join  (cost=2.50..3.84 rows=4 width=310) (actual time=19.457..19.463 rows=3 loops=1)
         Hash Cond: (directors.id = movies.directors_id)
         ->  Seq Scan on directors  (cost=0.00..1.20 rows=20 width=126) (actual time=0.008..0.010 rows=20 loops=1)
         ->  Hash  (cost=2.45..2.45 rows=4 width=184) (actual time=0.033..0.033 rows=3 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 9kB
               ->  Hash Join  (cost=1.10..2.45 rows=4 width=184) (actual time=0.023..0.027 rows=3 loops=1)
                     Hash Cond: (movies.country_id = country.id)
                     ->  Seq Scan on movies  (cost=0.00..1.25 rows=25 width=130) (actual time=0.003..0.005 rows=25 loops=1)
                     ->  Hash  (cost=1.09..1.09 rows=1 width=62) (actual time=0.014..0.014 rows=1 loops=1)
                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                           ->  Seq Scan on country  (cost=0.00..1.09 rows=1 width=62) (actual time=0.007..0.008 rows=1 loops=1)
                                 Filter: ((name)::text = 'New Zealand'::text)
                                 Rows Removed by Filter: 6
 Planning time: 0.455 ms
 Execution time: 19.544 ms

--==================================================================================================

SET enable_seqscan TO off;
EXPLAIN (ANALYZE) SELECT movies.name AS movie, directors.name AS directors, age(movies.release_date, directors.born_date) AS age, country.name AS country
    FROM movies INNER JOIN directors
		ON (movies.directors_id = directors.id)
	INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	ORDER BY
		age(movies.release_date, directors.born_date) DESC NULLS LAST;

	                                                   QUERY PLAN
 Sort  (cost=10000000012.43..10000000012.44 rows=4 width=310) (actual time=0.089..0.090 rows=3 loops=1)
   Sort Key: (age((movies.release_date)::timestamp with time zone, (directors.born_date)::timestamp with time zone)) DESC NULLS LAST
   Sort Method: quicksort  Memory: 25kB
   ->  Nested Loop  (cost=10000000000.27..10000000012.39 rows=4 width=310) (actual time=0.072..0.083 rows=3 loops=1)
         ->  Nested Loop  (cost=10000000000.13..10000000009.78 rows=4 width=184) (actual time=0.061..0.066 rows=3 loops=1)
               Join Filter: (movies.country_id = country.id)
               Rows Removed by Join Filter: 22
               ->  Seq Scan on movies  (cost=10000000000.00..10000000001.25 rows=25 width=130) (actual time=0.011..0.013 rows=25 loops=1)
               ->  Materialize  (cost=0.13..8.16 rows=1 width=62) (actual time=0.002..0.002 rows=1 loops=25)
                     ->  Index Scan using country_name_idx1 on country  (cost=0.13..8.15 rows=1 width=62) (actual time=0.041..0.041 rows=1 loops=1)
                           Index Cond: ((name)::text = 'New Zealand'::text)
         ->  Index Scan using directors_pkey on directors  (cost=0.14..0.64 rows=1 width=126) (actual time=0.002..0.002 rows=1 loops=3)
               Index Cond: (id = movies.directors_id)
 Planning time: 0.222 ms
 Execution time: 0.126 ms


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  8 запрос
--%%  Вывести все страны, количество фильмов снятых в них и эти фильмы, через запятую, сортировать по имени страны.
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SELECT cou.name AS country, count(mov.name) AS count_movies, string_agg(mov.name, ', ' ORDER BY mov.name) AS movies
	FROM (SELECT id, name
			FROM country) AS cou
		INNER JOIN
		(SELECT name, country_id
			FROM movies) AS mov
		ON mov.country_id = cou.id
GROUP BY cou.name;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  9 запрос
--%%  Вывести всех режисеров и фильмы которые они сняли, с суммой прибыли этих фильмов, сортировать по имени режисёра.
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SELECT dir.name AS directors, string_agg(mov.name, ', ' ORDER BY mov.name) AS movies, sum(mov.box_office) AS sum_box_office
	FROM (SELECT id, name
			FROM directors) AS dir
		INNER JOIN
		(SELECT name, directors_id, box_office
			FROM movies) AS mov ON mov.directors_id = dir.id
GROUP BY dir.name;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%  10 запрос
--%%  Вывести все фильмы и актеров снимающихся в них перечислив через запятую, сортировать по имени фильма.
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SELECT mov.name AS movies, string_agg(act.name, ', ' ORDER BY act.name) AS actors
	FROM (SELECT movies_id, actors_id
			FROM movies_actors_relations) AS movact
		INNER JOIN
		(SELECT id, name
			FROM movies) AS mov ON movact.movies_id = mov.id
		INNER JOIN
		(SELECT id, name
			FROM actors) AS act ON movact.actors_id = act.id
 GROUP BY mov.name;