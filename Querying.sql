--1 ������
--������� �������, ���� �������� � ���� ������, ��� �������� ����� ��������� ��������.

SELECT d.name, d.born_date, d.death_date
	FROM
		directors d
	WHERE
		d.name = 'Sidney Lumet';


--2 ������
--������� �������� ������, ���� ������ � �������� ���� ���������� ����� �������� ���� � ���� �������� ������ ���������, ������� ������ 10.

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


--3 ������
--������� ��� ������ ��� ����, ������� �����, � ���������� � ������������� �� �����.

SELECT a.name, a.height, a.complexion
	FROM
		actors a
	WHERE
		a.height>=1.70
		AND
		a.height<1.90
	ORDER BY
		a.name;

--4 ������
--������� ������ � �����, ��� ����� ������ ���������, ������������� �� ����� �������� � �������� ������ 10.

SELECT m.name, m.box_office
	FROM
		movies m
	WHERE
		m.box_office > 100
	ORDER BY
		char_length(m.name) DESC NULLS LAST
	LIMIT 10;


--5 ������
--������� �����, �������� � ������, ������ ������� ������.

SELECT movies.name AS movie, directors.name AS directors, country.name AS country
    FROM movies INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	INNER JOIN directors
		ON (movies.directors_id = directors.id);

--8 ������
--������� �����, ����, ���� ������ � ��� ��������, ���� �������� ����� � ���� ������ ������ ��������.

SELECT movies.name AS movie, genre.name AS genre, movies.release_date AS release_date, directors.name AS directors
    FROM movies INNER JOIN genre
		ON (movies.genre_id = genre.id) AND (genre.name = 'Thriller')
	INNER JOIN directors
		ON (movies.directors_id = directors.id)
	WHERE movies.release_date >= '1994-01-01';

--7 ������
--������� �����, ��������, ������� ��������� ����� �� �������� �����, ������. ����������� �� ��������.
  
SELECT movies.name AS movie, directors.name AS directors, (movies.release_date - directors.born_date)/365 AS age, country.name AS country
    FROM movies INNER JOIN directors
		ON (movies.directors_id = directors.id)
	INNER JOIN country
		ON (movies.country_id = country.id) AND (country.name = 'New Zealand')
	ORDER BY
		(movies.release_date - directors.born_date)/365 DESC NULLS LAST;