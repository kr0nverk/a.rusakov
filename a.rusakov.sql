SET client_encoding = 'UTF8';
SET client_min_messages = warning;

DROP DATABASE IF EXISTS "a.rusakov";

CREATE DATABASE "a.rusakov" WITH ENCODING = 'UTF8';

SET client_encoding = 'UTF8';
SET client_min_messages = warning;

CREATE TABLE movies (
    id integer NOT NULL,
	name varchar(50) NOT NULL,
	genre_id integer NOT NULL,
	country_id integer NOT NULL,
	release_date date CONSTRAINT movies_release_date_check CHECK (release_date >= DATE '1800-01-01'),
    directors_id integer NOT NULL,
	rating_id integer NOT NULL,
	box_office float CONSTRAINT movies_box_office_check CHECK (box_office >= 0)
);

CREATE SEQUENCE movies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE movies_id_seq OWNED BY movies.id;



CREATE TABLE genre (
	id integer NOT NULL,
	name varchar(20) NOT NULL
);

CREATE SEQUENCE genre_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE genre_id_seq OWNED BY genre.id;


ALTER TABLE ONLY movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);

ALTER TABLE ONLY genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (id);


ALTER TABLE ONLY movies
    ADD CONSTRAINT movies_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES genre(id) ON UPDATE RESTRICT ON DELETE RESTRICT;




CREATE TABLE directors (
    id integer NOT NULL,
	name varchar(50) NOT NULL,
	born_date date CONSTRAINT directors_born_date_check CHECK (born_date >= DATE '1600-01-01'),
	death_date date CONSTRAINT directors_death_date_check CHECK (death_date >= DATE '1600-01-01'),
	country_id integer NOT NULL,
	information varchar(1000)
);

CREATE SEQUENCE directors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE directors_id_seq OWNED BY directors.id;

ALTER TABLE ONLY directors
    ADD CONSTRAINT directors_pkey PRIMARY KEY (id);

ALTER TABLE ONLY movies
    ADD CONSTRAINT movies_directors_id_fkey FOREIGN KEY (directors_id) REFERENCES directors(id) ON UPDATE RESTRICT ON DELETE RESTRICT;





CREATE TABLE rating (
    id integer NOT NULL,
	IMDb float CONSTRAINT rating_IMDb_check CHECK (IMDb >= 0)
);

CREATE SEQUENCE rating_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE rating_id_seq OWNED BY rating.id;

ALTER TABLE ONLY rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (id);

ALTER TABLE ONLY movies
    ADD CONSTRAINT movies_rating_id_fkey FOREIGN KEY (rating_id) REFERENCES rating(id) ON UPDATE RESTRICT ON DELETE RESTRICT;



CREATE TABLE actors (
    id integer NOT NULL,
	name varchar(50) NOT NULL,
	born_date date CONSTRAINT actors_born_date_check CHECK (born_date >= DATE '1600-01-01'),
	death_date date CONSTRAINT actors_death_date_check CHECK (death_date >= DATE '1600-01-01'),
	country_id integer NOT NULL,
	height float NOT NULL CONSTRAINT actors_height_check CHECK (height >= 0),
	complexion varchar(15) NOT NULL,
	information varchar(1000)
);

CREATE SEQUENCE actors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE actors_id_seq OWNED BY actors.id;

ALTER TABLE ONLY actors
    ADD CONSTRAINT actors_pkey PRIMARY KEY (id);



CREATE TABLE movies_actors_relations (
	movies_id integer NOT NULL,
	actors_id integer NOT NULL
);

ALTER TABLE ONLY movies_actors_relations
    ADD CONSTRAINT movies_actors_relations_pkey PRIMARY KEY (movies_id, actors_id);

ALTER TABLE ONLY movies_actors_relations
    ADD CONSTRAINT movies_relations_id_fkey FOREIGN KEY (movies_id) REFERENCES movies(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY movies_actors_relations
    ADD CONSTRAINT actors_relations_id_fkey FOREIGN KEY (actors_id) REFERENCES actors(id) ON UPDATE RESTRICT ON DELETE RESTRICT;




CREATE TABLE country (
    id integer NOT NULL,
	name varchar(20) NOT NULL
);

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE country_id_seq OWNED BY country.id;


ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);

ALTER TABLE ONLY movies
    ADD CONSTRAINT movies_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY actors
    ADD CONSTRAINT actors_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY directors
    ADD CONSTRAINT directors_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


ALTER TABLE ONLY movies
	ADD CONSTRAINT movies_ukey UNIQUE (name);

ALTER TABLE ONLY genre
	ADD CONSTRAINT genre_ukey UNIQUE (name);

ALTER TABLE ONLY directors
	ADD CONSTRAINT directors_ukey UNIQUE (name);

ALTER TABLE ONLY actors
	ADD CONSTRAINT actors_ukey UNIQUE (name);

ALTER TABLE ONLY country
	ADD CONSTRAINT country_ukey UNIQUE (name);





INSERT INTO country VALUES ('1', 'USA');
INSERT INTO country VALUES ('2', 'New Zealand');
INSERT INTO country VALUES ('3', 'Italy');
INSERT INTO country VALUES ('4', 'Japan');
INSERT INTO country VALUES ('5', 'Brazil');
INSERT INTO country VALUES ('6', 'United Kingdom');
INSERT INTO country VALUES ('7', 'Germany');

SELECT pg_catalog.setval('country_id_seq', 7, true);


INSERT INTO genre VALUES ('1', 'Drama');
INSERT INTO genre VALUES ('2', 'Thriller');
INSERT INTO genre VALUES ('3', 'Black comedy');
INSERT INTO genre VALUES ('4', 'Fantasy');
INSERT INTO genre VALUES ('5', 'Spaghetti Western');
INSERT INTO genre VALUES ('6', 'Tragicomedy');
INSERT INTO genre VALUES ('7', 'Space opera');
INSERT INTO genre VALUES ('8', 'Science fiction');
INSERT INTO genre VALUES ('9', 'Gangster film');

SELECT pg_catalog.setval('genre_id_seq', 9, true);


INSERT INTO directors VALUES ('1', 'Frank Darabont',                   '1959-01-01', 'infinity', '1', 'text');
INSERT INTO directors VALUES ('2', 'Francis Ford Coppola',             '1939-01-01', 'infinity', '1', 'text');
INSERT INTO directors VALUES ('3', 'Christopher Jonathan James Nolan', '1970-01-01', 'infinity', '6', 'text');
INSERT INTO directors VALUES ('4', 'Sidney Lumet',                     '1924-01-01', 'infinity', '1', 'text');
INSERT INTO directors VALUES ('5', 'Steven Allan Spielberg',           '1946-01-01', 'infinity', '1', 'text');
INSERT INTO directors VALUES ('6', 'Quentin Jerome Tarantino',         '1963-01-01', 'infinity', '1', 'text');
INSERT INTO directors VALUES ('7', 'Sir Peter Robert Jackson',         '1961-01-01', 'infinity', '2', 'text');
INSERT INTO directors VALUES ('8', 'Sergio Leone',                     '1929-01-01', '1989-01-01', '3', 'text');
INSERT INTO directors VALUES ('9', 'David Andrew Leo Fincher',         '1962-01-01', 'infinity', '1', 'text');
INSERT INTO directors VALUES ('10', 'Robert Lee Zemeckis',             '1952-01-01', 'infinity', '1', 'text');
INSERT INTO directors VALUES ('11', 'Irvin Kershner',                  '1923-01-01', '2010-01-01', '1', 'text');
INSERT INTO directors VALUES ('12', 'Jan Tomas Forman',                '1932-01-01', 'infinity', '1', 'text');
INSERT INTO directors VALUES ('13', 'Martin Charles Scorsese',         '1942-01-01', 'infinity', '1', 'text');
INSERT INTO directors VALUES ('14', 'Andrew Paul Wachowski',           '1965-01-01', 'infinity', '1', 'text');
INSERT INTO directors VALUES ('15', 'Akira Kurosawa',                  '1910-01-01', 'infinity', '4', 'text');
INSERT INTO directors VALUES ('16', 'George Walton Lucas',             '1944-01-01', 'infinity', '1', 'text');
INSERT INTO directors VALUES ('17', 'Fernando Meirelles',              '1955-01-01', 'infinity', '5', 'text');
INSERT INTO directors VALUES ('18', 'Jonathan Demme',                  '1944-01-01', '2017-01-01', '1', 'text');
INSERT INTO directors VALUES ('19', 'Frank Capra',                     '1897-01-01', '1991-01-01', '1', 'text');
INSERT INTO directors VALUES ('20', 'Roberto Benigni',                 '1952-01-01', 'infinity', '3', 'text');

SELECT pg_catalog.setval('directors_id_seq', 20, true);


INSERT INTO rating VALUES ('1', '9.114');
INSERT INTO rating VALUES ('2', '8.737');
INSERT INTO rating VALUES ('3', '8.546');
INSERT INTO rating VALUES ('4', '8.502');
INSERT INTO rating VALUES ('5', '8.510');
INSERT INTO rating VALUES ('6', '8.816');
INSERT INTO rating VALUES ('7', '8.622');
INSERT INTO rating VALUES ('8', '8.612');
INSERT INTO rating VALUES ('9', '8.544');
INSERT INTO rating VALUES ('10', '8.656');
INSERT INTO rating VALUES ('11', '8.558');
INSERT INTO rating VALUES ('12', '8.921');
INSERT INTO rating VALUES ('13', '8.132');
INSERT INTO rating VALUES ('14', '8.665');
INSERT INTO rating VALUES ('15', '8.556');
INSERT INTO rating VALUES ('16', '8.556');
INSERT INTO rating VALUES ('17', '7.076');
INSERT INTO rating VALUES ('18', '8.491');
INSERT INTO rating VALUES ('19', '8.153');
INSERT INTO rating VALUES ('20', '8.115');
INSERT INTO rating VALUES ('21', '8.013');
INSERT INTO rating VALUES ('22', '8.297');
INSERT INTO rating VALUES ('23', '8.338');
INSERT INTO rating VALUES ('24', '8.472');
INSERT INTO rating VALUES ('25', '8.625');

SELECT pg_catalog.setval('rating_id_seq', 25, true);


INSERT INTO movies VALUES ('1',  'The Shawshank Redemption',                          '1',             '1',         '1994-01-01', '1',             '1', '59.8');
INSERT INTO movies VALUES ('2',  'The Godfather',                                     '1',             '1',         '1972-01-01', '2',             '2', '245');
INSERT INTO movies VALUES ('3',  'The Godfather Part 2',                              '1',             '1',         '1974-01-01', '2',             '3', '102.6');
INSERT INTO movies VALUES ('4',  'The Dark Knight',                                   '2',             '1',         '2008-01-01', '3',             '4', '100.4');
INSERT INTO movies VALUES ('5',  '12 Angry Men',                                      '1',             '1',         '1957-01-01', '4',             '5', '0');
INSERT INTO movies VALUES ('6',  'Schindlers List',                                   '1',             '1',         '1993-01-01', '5',             '6', '321.2');
INSERT INTO movies VALUES ('7',  'Pulp Fiction',                                      '3',             '1',         '1994-01-01', '6',             '7', '213.9');
INSERT INTO movies VALUES ('8',  'The Lord of the Rings: The Return of the King',     '4',             '2',         '2003-01-01', '7',             '8', '1119.1');
INSERT INTO movies VALUES ('9',  'The Good, the Bad and the Ugly',                    '5',             '3',         '1966-01-01', '8',             '9', '25.1');
INSERT INTO movies VALUES ('10', 'Fight Club',                                        '1',             '1',         '1999-01-01', '9',             '10', '100.8');
INSERT INTO movies VALUES ('11', 'The Lord of the Rings: The Fellowship of the Ring', '4',             '2',         '2001-01-01', '7',             '11', '871.5');
INSERT INTO movies VALUES ('12', 'Forrest Gump',                                      '6',             '1',         '1994-01-01', '10',            '12', '677.9');
INSERT INTO movies VALUES ('13', 'Star Wars: Episode V The Empire Strikes Back',      '7',             '1',         '1980-01-01', '11',            '13', '538.3');
INSERT INTO movies VALUES ('14', 'Inception',                                         '8',             '1',         '2010-01-01', '3',             '14', '825.5');
INSERT INTO movies VALUES ('15', 'The Lord of the Rings: The Two Towers',             '4',             '2',         '2002-01-01', '7',             '15', '926');
INSERT INTO movies VALUES ('16', 'One Flew Over the Cuckoos Nest',                    '1',             '1',         '1975-01-01', '12',            '16', '108.9');
INSERT INTO movies VALUES ('17', 'Goodfellas',                                        '9',             '1',         '1990-01-01', '13',            '17', '62.7');
INSERT INTO movies VALUES ('18', 'The Matrix',                                        '8',             '1',         '1999-01-01', '14',            '18', '463.5');
INSERT INTO movies VALUES ('19', 'Seven Samurai',                                     '1',             '4',         '1954-01-01', '15',            '19', '125');
INSERT INTO movies VALUES ('20', 'Star Wars. Episode IV: A New Hope',                 '7',             '1',         '1977-01-01', '16',            '20', '775.3');
INSERT INTO movies VALUES ('21', 'City of God',                                       '1',             '5',         '2002-01-01', '17',            '21', '27.3');
INSERT INTO movies VALUES ('22', 'Seven',                                             '2',             '1',         '1995-01-01', '9',             '22', '327.3');
INSERT INTO movies VALUES ('23', 'The Silence of the Lambs',                          '2',             '1',         '1991-01-01', '18',            '23', '272.7');
INSERT INTO movies VALUES ('24', 'Its a Wonderful Life',                              '4',             '1',         '1946-01-01', '19',            '24', '0');
INSERT INTO movies VALUES ('25', 'Life Is Beautiful',                                 '6',             '3',         '1997-01-01', '20',            '25', '229.1');

SELECT pg_catalog.setval('movies_id_seq', 25, true);



INSERT INTO actors VALUES ('1', 'Elijah Wood','1981-01-28','infinity','1','1.68','Light skin','text');
INSERT INTO actors VALUES ('2', 'Orlando Bloom','1977-01-13','infinity','6','1.80','Light skin','text');
INSERT INTO actors VALUES ('3', 'Morgan Freeman','1937-06-01','infinity','1','1.88','Tan brown skin','text');
INSERT INTO actors VALUES ('4', 'Al Pacino','1940-04-25','infinity','1','1.70','Fair skin','text');
INSERT INTO actors VALUES ('5', 'Christian Bale','1974-01-30','infinity','6','1.83','Fair skin','text');
INSERT INTO actors VALUES ('6', 'Martin Balsam','1919-11-04','1996-02-13','1','1.70','Fair skin','text');
INSERT INTO actors VALUES ('7', 'Liam Neeson','1952-06-07','infinity','6','1.93','Light skin','text');
INSERT INTO actors VALUES ('8', 'John Travolta','1954-02-18','infinity','1','1.88','Fair skin','text');
INSERT INTO actors VALUES ('9', 'Bruce Willis','1955-03-19','infinity','7','1.83','Fair skin','text');

SELECT pg_catalog.setval('actors_id_seq', 9, true);


INSERT INTO movies_actors_relations VALUES ('8','1');
INSERT INTO movies_actors_relations VALUES ('11','1');
INSERT INTO movies_actors_relations VALUES ('15','1');
INSERT INTO movies_actors_relations VALUES ('8','2');
INSERT INTO movies_actors_relations VALUES ('11','2');
INSERT INTO movies_actors_relations VALUES ('15','2');
INSERT INTO movies_actors_relations VALUES ('1','3');
INSERT INTO movies_actors_relations VALUES ('22','3');
INSERT INTO movies_actors_relations VALUES ('2','4');
INSERT INTO movies_actors_relations VALUES ('3','4');
INSERT INTO movies_actors_relations VALUES ('4','5');
INSERT INTO movies_actors_relations VALUES ('5','6');
INSERT INTO movies_actors_relations VALUES ('6','7');
INSERT INTO movies_actors_relations VALUES ('7','8');
INSERT INTO movies_actors_relations VALUES ('7','9');



ALTER TABLE ONLY movies
	ALTER id SET DEFAULT nextval('movies_id_seq');

ALTER TABLE ONLY genre
	ALTER id SET DEFAULT nextval('genre_id_seq');

ALTER TABLE ONLY directors
	ALTER id SET DEFAULT nextval('directors_id_seq');

ALTER TABLE ONLY rating
	ALTER id SET DEFAULT nextval('rating_id_seq');

ALTER TABLE ONLY actors
	ALTER id SET DEFAULT nextval('actors_id_seq');

ALTER TABLE ONLY country
	ALTER id SET DEFAULT nextval('country_id_seq');