#  Tipos de bases de datos

## SQL

Son parecidas a una hoja de Excel, tienen columnas, valores, tipos de datos y tiene una estructura fija.


## No SQL

Almacenan la información en objetos que suelen ser llamados documentos, y colecciones que agrupan dichos documentos. Este tipo de información luce similar a los objetos JSON.


# Terminología

## DDL

Sus siglas significan Data Definition Language, e incluye todo lo que sea Create, Alter, Drop y Truncate.


## DML

Sus siglas significan Data Manipulation Languate, e incluye todo lo que sea Insert, Delete y Update.


## TCL

Sus siglas significan Transaction Control Language, e incluye los Commit y Rollback.


## DQL

Sus siglas significan Data Query Language e incluye el Select.


## Funciones agregadas

- Count.
- Sum.
- Max.
- Min.
- Group By.
- Having.
- Order By.


## Filtrando data

- Like.
- In.
- Is Null.
- Is Not Null.
- Where.
- And.
- Or.
- Between.


# Comandos básicos

## Crear tabla

```sql
CREATE TABLE users (
	name VARCHAR(10) UNIQUE
);
```


## Insertar registros

```sql
INSERT INTO users (name)
	VALUES('Fernando');
```


## Actualizar registros

```sql
UPDATE users
	SET name = 'Test'
	WHERE name = 'Juan David';
```


## Obtener registros

```sql
SELECT *
	FROM users
	WHERE nombre = 'Juan David';

-- Estructura general
SELECT distinct *, campos, alias, funciones
	WHERE Condición, condiciones, and, or, in, like
	JOINS
	GROUP BY Campo agrupador, ALL
	HAVING Condición
	ORDER BY Expresión, ASC, DESC
	LIMIT Valor, ALL
	OFFSET Punto de inicio
```


## Eliminar registros

```sql
DELETE FROM users
	WHERE nombre = 'Juan David';
```


## DROP vs Truncate Table

Para eliminar una tabla que estamos seguros que no necesitaremos más (es irrevertible) podemos ejecutar el siguiente comando:

```sql
DROP TABLE users;
```

Y con el truncate podemos eliminar los datos de una tabla, es importante tener claro que los borra sin restricción.

```sql
TRUNCATE TABLE users;
```


## Operadores de strings y funciones

Estas funciones cuando se utilizan en sentencias SELECT no afectan la base de datos, sólo los resultados.

### UPPER
Se utiliza para transformar un string en mayúsculas:

```sql
SELECT id, UPPER(name) AS upper_name, name
	FROM users;
```

### LOWER
Se utiliza para transformar un string en minúsculas:

```sql
SELECT id, LOWER(name) AS lower_name, name
	FROM users;
```

### LENGTH
Nos da la longitud de un texto:

```sql
SELECT id, LENGTH(name) AS length
	FROM users;
```

### Operadores matemáticos
Se pueden hacer operaciones numéricas constantes en el SELECT:

```sql
SELECT id, (20 * 2) AS constante
	FROM users;
```

### CONCAT
Podemos concatenar n columnas o textos y retornarlos en una sola:

```sql
SELECT CONCAT(id, ' ', name) AS concatenacion, id || '-' || name AS concatenacion2
	FROM users;
```

### SUBSTRING
Permite recortar un string en las posiciones de caracteres que nosotros indiquemos:

```sql
SELECT name, SUBSTRING(name, 0, 5)
	FROM users;
```

### POSITION
Nos retorna el index del caracter que estamos buscando, su posición inicial siempre será 1, si retorna 0 es porque la letra no existe en el string:

```sql
SELECT name, POSITION(' ' in name)
	FROM users;
```

### TRIM
Quita los espacios en blanco sobrantes de un texto:

```sql
SELECT name, TRIM(name)
	FROM users;

-- Ejemplo de TRIM con POSITION y SUBSTRING
SELECT
	name,
	SUBSTRING(name, 0, POSITION(' ' in name)) AS first_name,
	SUBSTRING(name, POSITION(' ' in name) + 1) AS last_name,
	TRIM(SUBSTRING(name, POSITION(' ' in name))) AS trimmed_last_name
	FROM users;
```


# Funciones agregadas - agrupaciones y ordenamiento


## BETWEEN

Permite hacer el filtro en un rango de valores especificado.

```sql
SELECT first_name, last_name, followers
	FROM users
	-- WHERE followers >= 4600 AND followers <= 4700
	WHERE followers BETWEEN 4600 AND 4700;
```


## ORDER BY

Permite hacer el ordenamiento basado en una columna de forma ascendente o descendente.

```sql
SELECT first_name, last_name, followers
	FROM users
	WHERE followers BETWEEN 4600 AND 4700
	ORDER BY followers ASC;
```


## Funciones agregadas

### COUNT
Nos retorna la cantidad de registros que cumplen con nuestra consulta.

```sql
SELECT COUNT(*) AS total_users
	FROM users;
```

### MIN
Nos retorna el valor mínimo de una columna en una tabla.

```sql
SELECT MIN(followers) AS min_followers
	FROM users;
```

### MAX
Nos retorna el valor máximo de una columna en una tabla.

```sql
SELECT MAX(followers) AS max_followers
	FROM users;
```

### AVG
Calcula el promedio de los valores en una columna de una tabla.

```sql
SELECT AVG(followers) AS avg_followers
	FROM users;
```

### SUM
Suma todos los valores de una columna.

```sql
SELECT SUM(followers) AS sum_followers, SUM(followers) / COUNT(*) AS avg_manual
	FROM users;
```

### ROUND
Redondea un valor decimal y lo transforma en un entero.

```sql
SELECT ROUND(AVG(followers)) AS avg_followers
	FROM users;
```


## GROUP BY

Permite agrupar los resultados de un query por columnas.

```sql
SELECT COUNT(*), followers
	FROM users
	-- WHERE followers BETWEEN 4500 AND 4999
	WHERE followers = 4 OR followers = 4999
	GROUP BY followers
	ORDER BY followers DESC;
```


## HAVING

Son condiciones que se ponen usualmente a las funciones agregadas.

```sql
SELECT COUNT(*) AS total, country
	FROM users
	GROUP BY country
	HAVING COUNT(*) BETWEEN 2 AND 5
	ORDER BY COUNT(*) DESC;

SELECT COUNT(*), SUBSTRING(email, POSITION('@' in email) + 1) AS domain
	FROM users
	GROUP BY SUBSTRING(email, POSITION('@' in email) + 1)
	HAVING COUNT(*) > 1
	ORDER BY SUBSTRING(email, POSITION('@' in email) + 1) ASC;
```


## DISTINCT

Permite obtener los datos únicos de una columna.

```sql
SELECT DISTINCT country
	FROM users;
```


## SUBQUERIES

Nos permite sacar datos de consultas de otra tabla.

```sql
SELECT domain, total
	FROM (
		SELECT COUNT(*) AS total, SUBSTRING(email, POSITION('@' in email) + 1) AS domain
			FROM users
			GROUP BY SUBSTRING(email, POSITION('@' in email) + 1)
			HAVING COUNT(*) > 1
			ORDER BY SUBSTRING(email, POSITION('@' in email) + 1) ASC
	) AS email_domains;
```


# Intermedio - Relaciones, Llaves y Constraints

## Relaciones

- **Uno a Uno** - One to One.
- **Uno a muchos** - One to many.
- **Relaciones a si mismas** - Self joining relationships
- **Muchos a Muchos** - Many to Many.


## Llaves

Son recomendadas para hacer las relaciones con las tablas de nuestra base de datos. Esto garantiza la integridad de los datos.

Hay varios tipos de llaves:

- **Primary Key:** Identifica un registro de forma única. Una tabla puede tener varios identificadores únicos. La llave primaria está basada en los requerimientos.
- **Super Key:** Es un conjunto de atributos que puede identificar de forma única. Es un superconjunto de una clave candidata.
- **Canditate Key:** Un atributo o conjunto de ellos que identifican de forma única. Menos la llave primario, los demás se consideran claves candidatas.
- **Foreign Key:** Llaves foráneas son usadas para apuntar a la llave primaria de otra tabla. Por ejemplo al tener una columna department_id en 2 tablas, ambas deben de ser del mismo tipo de datos y longitud.
- **Composite Key:** Cuando una clave primaria consta de más de un atributo, se conoce como una clave compuesta.

### Primary Key
```sql
ALTER TABLE country
	ADD PRIMARY KEY(code);
```

### Constraint - Check
Nos permite colocar restricciones de data en nuestras columnas

```sql
ALTER TABLE country
	ADD CHECK(
		surfacearea >= 0
	);

ALTER TABLE country
	ADD CHECK(
		continent = 'Asia' OR 
		continent = 'South America' OR
		continent = 'North America' OR
		continent = 'Oceania' OR
		continent = 'Antarctica' OR
		continent = 'Africa' OR
		continent = 'Europe'
	);

ALTER TABLE country
	ADD CHECK(
		continent = 'Asia'::text OR 
		continent = 'South America'::text OR
		continent = 'North America'::text OR
		continent = 'Oceania'::text OR
		continent = 'Antarctica'::text OR
		continent = 'Africa'::text OR
		continent = 'Europe'::text
	);
```

Si queremos agregar un nuevo CHECK a alguno existente podemos borrar el check y volverlo a crear:

```sql
-- Eliminar constraint
ALTER TABLE country
	DROP CONSTRAINT "country_continent_check";

ALTER TABLE country
	ADD CHECK(
		continent = 'Asia'::text OR 
		continent = 'South America'::text OR
		continent = 'North America'::text OR
		continent = 'Central America'::text OR
		continent = 'Oceania'::text OR
		continent = 'Antarctica'::text OR
		continent = 'Africa'::text OR
		continent = 'Europe'::text
	);
```

### Foreign Keys
```sql
ALTER TABLE city
	ADD CONSTRAINT fk_country_code
	FOREIGN KEY (countrycode)
	REFERENCES country(code);
```


## Índices

Le dice a la base de datos que se vaya preparando porque se van a hacer consultas basadas en dicho índice. Nos ayudan a mejorar la velocidad de las consultas de nuestras bases de datos.

```sql
-- Índice único
CREATE UNIQUE INDEX "unique_country_name" ON country(
	name
);

-- Índice
CREATE INDEX "country_continent" ON country(
	continent
);

-- Índice compuesto
CREATE UNIQUE INDEX "unique_name_countrycode_district" ON city(
	name, countrycode, district
);
```


## ON DELETE - CASCADE

Esto habilita la eliminación de datos conectados a alguna tabla cuando se borra algún registro.

```sql
ALTER TABLE city
	DROP CONSTRAINT fk_country_code;

ALTER TABLE city
	ADD CONSTRAINT fk_country_code
	FOREIGN KEY (countrycode)
	REFERENCES country(code)
	ON DELETE CASCADE;
```


# Separación de data en otras tablas

## Insertar datos utilizando un query SELECT

```sql
INSERT INTO continent(name)
	SELECT DISTINCT continent
		FROM country
		ORDER BY continent ASC;

INSERT INTO country_back
	SELECT *
		FROM country;
```


## Crear una copia de una tabla (backup)

Se puede generar el Script con nuestra interfaz de administración de base de datos y luego crear una tabla copia, y después insertar la información tal como lo vimos en la anterior sección.

Luego para hacer una actualización masiva utilizando un subquery podemos hacer algo como lo siguiente:

```sql
UPDATE country a
	SET continent = (SELECT code FROM continent b WHERE b.name = a.continent);
```


## Cambiar tipo de dato de columna para crear una llave foránea con columna existente

```sql
ALTER TABLE country
	ALTER COLUMN continent TYPE int4
	USING continent::integer;

-- Otras alternativas para convertir columnas de tipo text a integer
ALTER TABLE country
	ALTER COLUMN continent TYPE int4
	USING CAST(continent AS integer)::integer;

ALTER TABLE country
	ALTER COLUMN continent TYPE int4
	USING continent / 1;
```


## Crear tabla con auto incrementable automáticamente

```sql
CREATE SEQUENCE IF NOT EXISTS language_code_seq;

CREATE TABLE language(
	code int4 NOT NULL DEFAULT nextval('language_code_seq'::regclass),
	name text NOT NULL,
	PRIMARY KEY(code)
);
```


# Uniones

## Cláusula UNION

Nos permite unir dos o más consultas, es importante tener claro que las consultas deben tener el mismo número de columnas para que no se produzca un error. Además, el orden de las columnas deben ser iguales para que no se presente un error, las uniones se hacen normalmente para 2 consultas en la misma tabla.

```sql
SELECT *
	FROM continent
	WHERE name LIKE '%America%'
UNION
SELECT *
	FROM continent
	WHERE code in (3, 5)
	ORDER BY name;
```


## Unión de tablas con WHERE

Podemos hacer uniones (simular JOINs) utilizando varias tablas en el FROM y configurando las restricciones en el WHERE.

```sql
SELECT a.name AS country, b.name AS continent
	FROM country a, continent b
	WHERE a.continent = b.code
	ORDER BY a.name asc;
```


## INNER JOIN

```sql
SELECT a.name AS country, b.name AS continent
	FROM country a
	INNER JOIN continent b
		ON a.continent = b.code
	ORDER BY a.name ASC;
```


## Alterar secuencias de autoincrementables

Si queremos que se devuelva el número de la secuencia de una columna autoincrementable podemos hacer lo siguiente:

```sql
ALTER SEQUENCE continent_code_seq RESTART with 10;
```


## FULL OUTER JOIN

Este tipo de JOIN nos permite obtener todos los registros que se encuentren en ambas tablas, independientemente de si hay relación o no entre ellas.

```sql
SELECT a.name AS country, a.continent AS continentCode, b.name AS continentName
	FROM country a
	FULL OUTER JOIN continent b
		ON a.continent = b.code
	ORDER BY a.name;
```


## RIGHT OUTER JOIN

Esto traerá los datos de la tabla B que no tienen ningún tipo de relación con alguno de los datos de la tabla A.

```sql
SELECT a.name AS country, a.continent AS continentCode, b.name AS continentName
	FROM country a
	RIGHT JOIN continent b
		ON a.continent = b.code
	WHERE a.continent IS NULL
	ORDER BY b.name;
```


## Aggregations + JOINS

```sql
SELECT COUNT(*), b.name AS continent
	FROM country a
	INNER JOIN continent b
		ON a.continent = b.code
	GROUP BY b.name
	ORDER BY COUNT(*) ASC;

-- Ejemplo con JOIN
SELECT COUNT(a.*), b.name AS continent
	FROM country a
	FULL OUTER JOIN continent b
		ON a.continent = b.code
	GROUP BY b.name
	ORDER BY COUNT(a.*) ASC;

-- Ejemplo con UNION
(SELECT COUNT(*) AS count, b.name
	FROM country a
	INNER JOIN continent b
		ON a.continent = b.code
	GROUP BY b.name
	ORDER BY COUNT(*) ASC)
UNION
(SELECT 0 AS count, b.name
	FROM country a
	RIGHT JOIN continent b
		ON a.continent = b.code
	WHERE a.continent IS NULL
	GROUP BY b.name)
ORDER BY count;
```


## Múltiples JOINS con agrupaciones

```sql
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
```