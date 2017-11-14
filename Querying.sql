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
