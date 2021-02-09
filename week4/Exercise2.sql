--1--
CREATE OR REPLACE VIEW HorrorFilms AS
SELECT film_id, title FROM (SELECT films.film_id, films.title FROM film AS films, category AS categories, film_category AS fc
							WHERE films.film_id = fc.film_id AND fc.category_id = categories.category_id
							AND categories.name = 'Horror') AS horror_films;

CREATE OR REPLACE VIEW PG13Films AS
SELECT film_id, title FROM film WHERE rating = 'PG-13';

--2--

SELECT hf.title FROM HorrorFilms as hf, PG13Films as pg WHERE hf.film_id = pg.film_id;

--3--

CREATE OR REPLACE FUNCTION refresh_views() RETURNS TRIGGER AS $$
BEGIN
    CREATE OR REPLACE VIEW HorrorFilms AS
		SELECT film_id, title FROM (SELECT films.film_id, films.title FROM film AS films, category AS categories, film_category AS fc
							WHERE films.film_id = fc.film_id AND fc.category_id = categories.category_id
							AND categories.name = 'Horror') AS horror_films;

	CREATE OR REPLACE VIEW PG13Films AS
		SELECT film_id, title FROM film WHERE rating = 'PG-13';
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS views_updater ON film;

CREATE TRIGGER views_updater
AFTER INSERT OR UPDATE OR DELETE ON film EXECUTE PROCEDURE refresh_views();