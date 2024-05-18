

-- Count Union - Tarea
-- Total |  Continent
-- 5	  | Antarctica
-- 28	  | Oceania
-- 46	  | Europe
-- 51	  | America
-- 51	  | Asia
-- 58	  | Africa

(SELECT COUNT(*) AS Total, b.name
	FROM country a
	INNER JOIN continent b
		ON a.continent = b.code
	WHERE b.name NOT LIKE '%America%'
	GROUP BY b.name)
UNION
(SELECT COUNT(*) AS Total, 'America'
	FROM country a
	INNER JOIN continent b
		ON a.continent = b.code
	WHERE b.name LIKE '%America%')
ORDER BY Total;


(SELECT COUNT(*) AS Total, b.name
	FROM country a
	INNER JOIN continent b
		ON a.continent = b.code
	WHERE b.code IN (1, 2, 3, 5, 7, 9, 10, 11)
	GROUP BY b.name)
UNION
(SELECT COUNT(*) AS Total, 'America'
	FROM country a
	INNER JOIN continent b
		ON a.continent = b.code
	WHERE b.code IN (4, 6, 8))
ORDER BY Total;


(SELECT COUNT(*) AS Total, b.name
	FROM country a
	INNER JOIN continent b
		ON a.continent = b.code
	WHERE b.code NOT IN (4, 6, 8)
	GROUP BY b.name)
UNION
(SELECT COUNT(*) AS Total, 'America'
	FROM country a
	INNER JOIN continent b
		ON a.continent = b.code
	WHERE b.code IN (4, 6, 8))
ORDER BY Total;


-- Quiero que me muestren el país con más ciudades
-- Campos: Total de ciudades y el nombre del país
-- usar INNER JOIN
SELECT COUNT(*) AS total, b.name AS country
	FROM city a
	INNER JOIN country b
		ON a.countrycode = b.code
	GROUP BY b.name
	ORDER BY COUNT(*) DESC
	LIMIT 1;


-- Quiero saber los idiomas oficiales que se hablan por continente
SELECT DISTINCT a.language, c.name
	FROM countrylanguage a
	INNER JOIN country b
		ON a.countrycode = b.code
	INNER JOIN continent c
		ON b.continent = c.code
	WHERE a.isofficial IS TRUE;


-- ¿Cuántos idiomas oficiales se hablan por continente?
SELECT COUNT(*), continent FROM (
	SELECT DISTINCT d.name, c.name AS continent
		FROM countrylanguage a
		INNER JOIN country b
			ON a.countrycode = b.code
		INNER JOIN continent c
			ON b.continent = c.code
		INNER JOIN language d
			ON a.languagecode = d.code
		WHERE a.isofficial IS TRUE
) AS totales
GROUP BY continent;