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


# Fechas, intervalos y funciones

## Funciones básicas de fechas

Si se quiere ver más detalles de las funciones básicas de fechas se pueden encontrar en el siguiente [link](https://www.postgresql.org/docs/8.1/functions-datetime.html).

```sql
-- Obtener la fecha actual (con hora) de la BD
SELECT NOW();

-- Obtener la fecha actual
SELECT CURRENT_DATE;

-- Obtener la hora actual
SELECT CURRENT_TIME;

-- Obtener parte de la fecha y hora actual
SELECT DATE_PART('hours', NOW()) AS hours;
SELECT DATE_PART('minutes', NOW()) AS minutes;
SELECT DATE_PART('seconds', NOW()) AS seconds;
SELECT DATE_PART('days', NOW()) AS days;
SELECT DATE_PART('months', NOW()) AS months;
SELECT DATE_PART('years', NOW()) AS years;
```


## Consultas sobre fechas

```sql
-- Filtrar con fechas en cláusula WHERE
SELECT *
	FROM employees
	WHERE hire_date > '1998-02-05'
	ORDER BY hire_date ASC;

-- O esta otra alternativa
SELECT *
	FROM employees
	WHERE hire_date > DATE('1998-02-05')
	ORDER BY hire_date ASC;

-- Obtener la fecha más alta
SELECT MAX(hire_date) AS mas_nuevo
	FROM employees;

-- Obtener a fecha más baja
SELECT MIN(hire_date) AS mas_nuevo
	FROM employees;

-- Filtros con BETWEEN
SELECT *
	FROM employees
	WHERE hire_date BETWEEN '1999-01-01' AND '2000-01-04'
	ORDER BY hire_date DESC;
```


## Intérvalos

```sql
-- Sumar días en fechas
SELECT MAX(hire_date) + 1 AS mas_nuevo
	FROM employees;

-- Otra opción (más eficaz)
SELECT MAX(hire_date), MAX(hire_date) + INTERVAL '1 days'
	FROM employees;

-- Intérvalos para otros datos
SELECT MAX(hire_date),
	MAX(hire_date) + INTERVAL '1 days' AS days,
	MAX(hire_date) + INTERVAL '1 month' AS months,
	MAX(hire_date) + INTERVAL '1 year' AS years,
	MAX(hire_date) + INTERVAL '1.1 year' AS one_year_one_month,
	MAX(hire_date) + INTERVAL '1.1 year' + INTERVAL '1 day' AS one_year_one_month_one_day
	FROM employees;

-- Otra forma de agregar tiempo a las fechas
SELECT DATE_PART('year', NOW()),
	MAKE_INTERVAL(YEARS := DATE_PART('year', NOW())::integer)
	max(hire_date) + MAKE_INTERVAL(YEARS := 23)
	FROM employees;
```


## Diferencia entre fechas y actualizaciones

```sql
-- Diferencia en años
SELECT hire_date,
	MAKE_INTERVAL(YEARS := 2024 - EXTRACT(YEARS FROM hire_date)::integer) AS manual,
	MAKE_INTERVAL(YEARS := DATE_PART('years', CURRENT_DATE)::integer - EXTRACT(YEARS FROM hire_date)::integer) AS computed
	FROM employees
	ORDER BY hire_date DESC;

-- Sumar años en una actualización
UPDATE employees
	SET hire_date = hire_date + INTERVAL '24 years';
```


## Cláusula CASE - THEN

```sql
SELECT first_name,
	last_name,
	hire_date,
	CASE
		WHEN hire_date > NOW() - INTERVAL '1 year'
			THEN '1 año o menos'
		WHEN hire_date > NOW() - INTERVAL '3 year'
			THEN '1 a 3 años'
		WHEN hire_date > NOW() - INTERVAL '6 year'
			THEN '3 a 6 años'
			ELSE '+ de 6 años'
	END AS rango_antiguedad
	FROM employees
	ORDER BY hire_date DESC;
```


# Generación de llaves primarias

## SERIAL vs IDENTITY

Si utilizamos SERIAL e insertamos datos indicando de forma manual los seriales no va a reconocer el autoincrementable, lo que nos generará errores. Mientras que el IDENTITY tiene beneficios ya que puedes usar otros tipos de datos (no sólo integers), además de que podemos forzar a que nadie coloque los IDs de forma manual.

```sql
-- Crear llave con SERIAL
CREATE TABLE users(
	user_id SERIAL PRIMARY KEY,
	username VARCHAR
);

-- Crear IDENTITY y dejar que se registren los IDs de forma manual
CREATE TABLE users2(
	user_id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
	username VARCHAR
);

-- Crear IDENTITY y bloquear que se registre el ID de forma manual
CREATE TABLE users2(
	user_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	username VARCHAR
);

-- Crear IDENTITY y bloquear que se registre el ID de forma manual, además de indicar el número de inicio y la cantidad por la que queremos que se haga el incremento
CREATE TABLE users2(
	user_id INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 100 INCREMENT BY 2),
	username VARCHAR
);
```


## Llave primaria compuesta

Sirve para utilizar 2 o más columnas combinadas como la llave primaria, esto quiere decir que sólo se validará que el valor combinado sea único, no se validaría por cada columna por separado.

```sql
CREATE TABLE usersDual(
	id1 INT,
	id2 INT,
	PRIMARY KEY(id1, id2)
);
```


## UUIDs

Genera un GUID que podemos usar en nuestras tablas.

```sql
SELECT gen_random_uuid();

-- Utilizar una librería (crear funciones locales en nuestra bd)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Y para usarla
SELECT uuid_generate_v4();

-- Y para eliminar la extensión
DROP EXTENSION "uuid-ossp";

-- Crear base de datos para usar la función UUID
CREATE TABLE users5(
	user_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
	username VARCHAR
);
```


## Secuencias

```sql
-- Crear sequencia
CREATE SEQUENCE user_sequence;

-- Eliminar secuencia
DROP SEQUENCE user_sequence;

-- currval retorna el valor actual de la secuencia, y el nextval el siguiente haciendo el autoincrementable
SELECT currval('user_sequence'), nextval('user_sequence'), currval('user_sequence');

-- Utilizar la secuencia en una creación de tabla
CREATE TABLE user6(
	user_id INTEGER PRIMARY KEY DEFAULT nextval('user_sequence'),
	username VARCHAR
);
```


# MER con DB-Diagram

```
Table users {
	user_id integer [primary key,  increment]
	username varchar [not  null,  unique]
	email varchar [not  null,  unique]
	password varchar [not  null]
	name varchar [not  null]
	role varchar [not  null]
	gender varchar(10) [not  null]
	created_at timestamp [default:  "now()"]
}

Table posts {
	post_id integer [primary key,  increment]
	title varchar(200) [default:  ""]
	body text [default:  ""]
	og_image varchar
	slug varchar [not  null,  unique]
	published boolean
	created_by integer
	created_at timestamp [default:  "now()"]
}

Table claps {
	clap_id integer [primary key,  increment]
	post_id integer
	user_id integer
	counter integer [default:  0]
	created_at timestamp
	Indexes {
		(post_id, user_id) [unique]
		(post_id)
	}
}

Table comments {
	comment_id integer [primary key,  increment]
	post_id integer
	user_id integer
	content text
	created_at timestamp
	visible boolean
	comment_parent_id integer
	Indexes {
		(post_id)
		(visible)
	}
}

Table user_lists {
	user_list_id integer [primary key,  increment]
	user_id integer
	title varchar(100)
	Indexes {
		(user_id, title) [unique]
		(user_id)
	}
}


Table user_list_entry {
	user_list_entry integer [primary key,  increment]
	user_list_id integer
	post_id integer
}

Ref:  "users"."user_id" < "posts"."createdBy"
Ref:  "posts"."post_id" < "claps"."post_id"
Ref:  "users"."user_id" < "claps"."user_id"
Ref:  "posts"."post_id" < "comments"."post_id"
Ref:  "users"."user_id" < "comments"."user_id"
Ref:  "comments"."comment_id" < "comments"."comment_parent_id"
Ref:  "users"."user_id" < "user_lists"."user_id"
Ref:  "user_lists"."user_list_id" < "user_list_entry"."user_list_id"
Ref:  "posts"."post_id" < "user_list_entry"."post_id"
```


# Funciones

Hay algunas funciones por defecto en PostgreSQL que permiten por ejemplo generar un JSON como el valor de salida de una consulta.

```sql
-- Armar el JSON y retornar cada elemento en una fila
SELECT json_build_object(
		'user', user_id,
		'comment', content
	)
	FROM comments
	WHERE comment_parent_id = 1;

-- El json_agg permite unir varios valores JSON en un arreglo
SELECT json_agg(
		json_build_object(
			'user', user_id,
			'comment', content
		)
	)
	FROM comments
	WHERE comment_parent_id = 1;

-- Otro ejemplo
SELECT a.*, (
		SELECT json_agg(
			json_build_object(
				'user', b.user_id,
				'comment', b.content
			)
		)
		FROM comments b
		WHERE b.comment_parent_id = a.comment_id
	) AS replies
	FROM comments a
	WHERE comment_parent_id IS NULL;
```

Aún así podemos crear nuestras propias funciones como se ve a continuación:

```sql
CREATE OR REPLACE FUNCTION sayHello()
	RETURNS varchar
	AS
	$$
	BEGIN
	
		return 'Hola Mundo';

	END;
	$$
	LANGUAGE plpgsql;

-- Crear una función que recibe argumentos
CREATE OR REPLACE FUNCTION sayHello(user_name varchar)
	RETURNS varchar
	AS
	$$
	BEGIN
	
		return 'Hola ' || user_name;

	END;
	$$
	LANGUAGE plpgsql;

-- Un ejemplo con declaración de variables
CREATE OR REPLACE FUNCTION comment_replies(id integer)
	RETURNS json
	AS
	$$
	DECLARE result json;
	
	BEGIN
		SELECT json_agg(
			json_build_object(
				'user', user_id,
				'comment', content
			)
		) INTO result
		FROM comments
		WHERE comment_parent_id = id;

		return result;
	END;
	$$
	LANGUAGE plpgsql;

-- Otro ejemplo
CREATE OR REPLACE FUNCTION comment_replies(id integer)
	RETURNS json
	AS $function$
	DECLARE result json;
	
	BEGIN
		SELECT json_agg(
			json_build_object(
				'user', user_id,
				'comment', content
			)
		) INTO result
		FROM comments
		WHERE comment_parent_id = id;

		return result;
	END;
	$function$
	LANGUAGE plpgsql;
```

Hay que tener en cuenta que aunque le indicamos a Postgres que reemplace la función que ya existía con ese nombre, este va a duplicar o crear más funciones, por lo que tendremos que limpiar manualmente cada una de ellas si es lo que realmente queremos.


# Buenas prácticas

Es importante plantearnos estas dos preguntas:

1. ¿Cuál es el objetivo de la misma?
2. ¿Cómo usaremos la base de datos?

Esto nos permitirá saber si nuestra base de datos está bien estructurada. En general una base de datos cumple con los siguientes objetivos:

1. Minimizar la redundancia.
2. Proteger la precisión.
3. Ser accesible.
4. Cumplir las expectativas.

Y como recomendaciones podríamos tener en cuenta:

1. Investigar previamente sobre diseños similares.
2. Traiga las partes interesadas.
3. Empápate del tema objetivo.


## Principios y/o buenas prácticas

- Mantenla simple.
- Usa estandarización.
- Considera futuras modificaciones.
- Mantén la deuda técnica a raya.
- Normalizar la data.
- Diseña a largo plazo.
- Crea documentación y diagramas.
- Prueba tu diseño.
- No uses abreviaturas (hay excepciones pero lo ideal es evitarlo).
- Se recomienda nombres tablas en singular.
- No re-inventes la rueda.
- Usa lo que el motor de base de datos te ofrece.
- Reglas, checks, llaves, indices, para evitar basura.
- Mantén la privacidad como prioridad.
- Nombres en inglés y evitar caracteres especiales.
- Todo en minúscula sin espacios.
- Mantén la base de datos en su propio servidor.
- Mantén un modelado bajo versiones.
- Establece el tipo apropiado y precisión adecuada.
- No confíes en identificadores de terceros.
- Defina las llaves foráneas y relaciones.
- Si el esquema es muy grande, particiónalo.
- Evita nombres reservados "user", "table", "create".
- Los nombres de tablas y campos vivirán más que las aplicaciones.
- Los nombres son contratos.
- La base de datos gobierna sobre los demás.


## Relaciones en singular

Tablas, vistas y cualquier relación en singular.

- Es posible tener una relación uno a uno, ¿seguiría esto siendo plural?
- En inglés, hay palabras que no tienen forma plural, tales como "fish", "species", "series".
- Mucho software trabaja siguiendo esta regla de singular, y se usa mejor de esa forma.


## Nombrado explícito

Evitar redundancia y lectura adicional

- person_id vs id.
- Las llaves foráneas deben de ser una combinación.
- Índices deben de ser explícitos: person_idx_first_name_last_name.

Esto permite saber qué falló cuando surge algún error (PostgreSQL genera buenos nombres automáticamente).


## Ideas finales

- Si ya hay una estructura creada que sigue otras reglas, sigamos esas reglas.
- No mezclemos ideologías si no pensamos cambiar todo.
- Estos pasos son útiles para empezar nuevos diseños.


# Vistas

Las vistas nos permiten guardar queries en una tabla "temporal", esto nos permite evitar hacer queries repetitivamente ya que simplemente podemos guardarlo en una vista y simplemente hacer el SELECT a la misma.

```sql
-- Vista para obtener los comentarios truncados por semana, con el conteo de posts en cada una de esas semanas y los claps
CREATE OR REPLACE VIEW comments_per_week AS
	SELECT DATE_TRUNC('week', posts.created_at) AS weeks,
			COUNT(DISTINCT posts.post_id) AS number_of_posts,
			SUM(claps.counter) AS total_claps
		FROM posts
		INNER JOIN claps
			ON claps.post_id = posts.post_id
		GROUP BY weeks
		ORDER BY weeks DESC;

-- Llamar la vista
SELECT *
	FROM comments_per_week;

-- Eliminar vista
DROP VIEW comments_per_week;
```

Es ideal sólo ejecutar los queries de las vistas sin añadirles funciones, ya que esto puede ser extremadamente ineficiente al ejecutar primero el query de la vista y luego sí hacerle el calculado de las funciones a los datos del resultado de la vista.

También es importante tener en cuenta que podemos editar las vistas siempre y cuando sea para agregar o modificar los resultados (columnas en la vista), pero si deseamos eliminar una de las columnas seleccionadas en el SELECT no se podrá editar la vista. Para hacer esto se debe borrar primero la vista y luego volver a crearla.


## Vistas materializadas

Es una copia de una vista en memoria. Lo crea como una tabla en nuestra base de datos, esto permite evitar que se hagan las relaciones, conteos y demás ya que la información queda guardada una vez es cargada y ejecutada por primera vez la vista. Esto quiere decir que los datos estarán preprocesados cuando llamemos la vista.

Con esto tenemos un problema y es que la data no se actualiza en tiempo real, sino que toca decirle a la base de datos que actualice los datos específicamente, porque sino podremos tener siempre nuestra base de datos desactualizada. Esto se puede programar para generar dichas actualizaciones de información.

```sql
-- Crear vista materializada
CREATE MATERIALIZED VIEW comments_per_week_mat AS
	SELECT DATE_TRUNC('week', posts.created_at) AS weeks,
			SUM(claps.counter) AS total_claps,
			COUNT(DISTINCT posts.post_id) AS number_of_posts,
			COUNT(*) AS number_of_claps
		FROM posts
		INNER JOIN claps
			ON claps.post_id = posts.post_id
		GROUP BY weeks
		ORDER BY weeks DESC;

-- Actualizar datos de una vista materializada
REFRESH MATERIALIZED VIEW comments_per_week_mat;
```


## Actualizar los nombres de vistas y vistas materializadas

```sql
-- Renombrar vista
ALTER VIEW comments_per_week RENAME TO posts_per_week;

-- Renombrar vista materializada
ALTER MATERIALIZED VIEW comments_per_week_mat RENAME TO posts_per_week_mat;
```


# Common Table Expressions - CTE

Nos sirven para tratar de separar queries muy complejos en pequeños queries más sencillos. Son muy parecidos a las vistas pero no crean nada en la base de datos.

```sql
WITH posts_week_2024 AS (
	SELECT DATE_TRUNC('week'::text, posts.created_at) AS weeks,
		    SUM(claps.counter) AS total_claps,
		    COUNT(DISTINCT posts.post_id) AS number_of_posts,
		    COUNT(*) AS number_of_claps
		FROM posts
			JOIN claps ON claps.post_id = posts.post_id
		GROUP BY (DATE_TRUNC('week'::text, posts.created_at))
		ORDER BY (DATE_TRUNC('week'::text, posts.created_at)) DESC
)
SELECT *
	FROM posts_week_2024
	WHERE weeks BETWEEN '2024-01-01' AND '2024-12-31' AND total_claps >= 600;
```


## Múltiples CTEs

Si queremos generar varios CTEs podemos hacerlo en la declaración del mismo y luego utilizar INNER JOIN o subqueries para conectarlos.

```sql
WITH claps_per_post AS (
	SELECT post_id, SUM(counter)
		FROM claps
		GROUP BY post_id
), posts_from_2023 AS (
	SELECT *
		FROM posts
		WHERE created_at BETWEEN '2023-01-01' AND '2023-12-31'
)
SELECT *
	FROM claps_per_post
	WHERE claps_per_post.post_id IN (
		SELECT post_id
			FROM posts_from_2023
	);
```


## CTE recursivo

Son muy útiles cuando tenemos una estructura jerárquica en nuestros datos.

```sql
-- Ejemplo números descendentes desde 5 hasta 1
-- Nombre de la tabla en memoria
-- Campos que vamos a tener
WITH RECURSIVE countdown(val) AS (
	-- Inicialización => el primer nivel, o valores iniciales
	-- VALUES(5)
	SELECT 5 AS val
	UNION
	-- Query recursivo
	SELECT val - 1
		FROM countdown
		WHERE val > 1
)
-- Select de los campos
SELECT *
	FROM countdown;


-- Ejemplo números ascendentes desde 1 hasta 10
-- Nombre de la tabla en memoria
-- Campos que vamos a tener
WITH RECURSIVE counter(val) AS (
	-- Inicialización => el primer nivel, o valores iniciales
	-- VALUES(5)
	SELECT 1 AS val
	UNION
	-- Query recursivo
	SELECT val + 1
		FROM counter
		WHERE val < 10
)
-- Select de los campos
SELECT *
	FROM counter;


-- Ejemplo tabla de multiplicar
WITH RECURSIVE multiplication_table(base, val, result) AS (
	SELECT 5 AS base, 1 AS val, 5 AS result
	UNION
	SELECT 5 AS base, val + 1, (val + 1) * base
		FROM multiplication_table
		WHERE val < 10
)
SELECT *
	FROM multiplication_table;


-- Otro ejemplo de tabla de multiplicar con VALUES (otra forma de inicializar los datos)
WITH RECURSIVE multiplication_table(base, val, result) AS (
	VALUES(5, 1, 5)
	UNION
	SELECT 5 AS base, val + 1, (val + 1) * base
		FROM multiplication_table
		WHERE val < 20
)
SELECT *
	FROM multiplication_table;


-- Ejemplo de la vida real con CTE recursivos
WITH RECURSIVE bosses(id, name, reports_to, depth) AS (
	SELECT id, name, reports_to, 1 AS depth
		FROM employees
		WHERE id = 1
	UNION
	SELECT employees.id, employees.name, employees.reports_to, depth + 1
		FROM employees
		INNER JOIN bosses
			ON bosses.id = employees.reports_to
		WHERE depth < 10
)
SELECT bosses.*, employees.name AS reports_to_name
	FROM bosses
	LEFT JOIN employees ON employees.id = bosses.reports_to
	ORDER BY depth;


-- Ejemplo de queries sin recursividad
SELECT followers.*, leader.name AS leader, follower.name AS follower
	FROM followers
	INNER JOIN "user" leader
		ON followers.leader_id = leader.id
	INNER JOIN "user" follower
		ON follower.id = followers.follower_id;

SELECT *
	FROM followers
	WHERE leader_id IN (
		SELECT follower_id
			FROM followers
			WHERE leader_id = 1
	);
```


# Funciones personalizadas

Esto nos permite ejecutar instrucciones fácilmente con queries ya guardados y listos para correr. El nombre que colocamos entre los símbolos $ son el scope que definimos en dicha instrucción de la función.

```sql
CREATE OR REPLACE FUNCTION greet_employee(employee_name VARCHAR)
	RETURNS VARCHAR
	AS $function$
	
		BEGIN
		
			RETURN 'Hola ' || employee_name;
			
		END;
		
	$function$
	LANGUAGE plpgsql;


-- Ejemplos de uso
SELECT first_name, greet_employee(first_name) AS saludo
	FROM employees;

SELECT greet_employee();


-- Función con declaración de variables
CREATE OR REPLACE FUNCTION max_raise(empl_id int)
	RETURNS NUMERIC(8, 2)
	AS $max_raise_calculation$
		
		DECLARE
			possible_raise NUMERIC(8, 2);
	
		BEGIN
		
			SELECT max_salary - salary INTO possible_raise
				FROM employees
				INNER JOIN jobs
					ON jobs.job_id = employees.job_id
				WHERE employee_id = empl_id;

			RETURN possible_raise;
					
		END;

	$max_raise_calculation$
	LANGUAGE plpgsql;
```


## Múltiples queris y variables

Muchas veces requeriremos hacer más de un query en el cuerpo de nuestras funciones y declarar varias variables con un mismo query SELECT, y esto se puede hacer con el INTO como en el ejemplo anterior, y como se visualiza en el siguiente ejemplo:

```sql
CREATE OR REPLACE FUNCTION max_raise_2(empl_id int)
	RETURNS NUMERIC(8, 2)
	AS $max_raise_calculation$
		
		DECLARE
			employee_job_id int;
			current_salary NUMERIC(8, 2);
			job_max_salary NUMERIC(8, 2);
			possible_raise NUMERIC(8, 2);
	
		BEGIN
		
			-- Tomar el puesto de trabajo y el salario
			SELECT job_id, salary
					INTO employee_job_id, current_salary
				FROM employees
				WHERE employee_id = empl_id;

			-- Tomar el max salary, acorde a su job
			SELECT max_salary INTO job_max_salary
				FROM jobs
				WHERE job_id = employee_job_id;

			-- Cálculos
			possible_raise = job_max_salary - current_salary;

			RETURN possible_raise;
					
		END;

	$max_raise_calculation$
	LANGUAGE plpgsql;
```


## IF, THEN, ELSE, END IF

En varias ocasiones requeriremos lanzar excepcioes y/o hacer validaciones, para ello existen las instrucciones IF, THEN, ELSE, END IF en PostgreSQL.

```sql
-- Ejemplo 1: Validación de valores negativos
CREATE OR REPLACE FUNCTION max_raise_2(empl_id int)
	RETURNS NUMERIC(8, 2)
	AS $max_raise_calculation$
		
		DECLARE
			employee_job_id int;
			current_salary NUMERIC(8, 2);
			job_max_salary NUMERIC(8, 2);
			possible_raise NUMERIC(8, 2);
	
		BEGIN
		
			-- Tomar el puesto de trabajo y el salario
			SELECT job_id, salary
					INTO employee_job_id, current_salary
				FROM employees
				WHERE employee_id = empl_id;

			-- Tomar el max salary, acorde a su job
			SELECT max_salary INTO job_max_salary
				FROM jobs
				WHERE job_id = employee_job_id;

			-- Cálculos
			possible_raise = job_max_salary - current_salary;

			IF(possible_raise < 0) THEN
			
				possible_raise = 0;
			
			END IF;

			RETURN possible_raise;
					
		END;

	$max_raise_calculation$
	LANGUAGE plpgsql;


-- Ejemplo 2: Lanzar excepción personalizada
CREATE OR REPLACE FUNCTION max_raise_2(empl_id int)
	RETURNS NUMERIC(8, 2)
	AS $max_raise_calculation$
		
		DECLARE
			employee_job_id int;
			current_salary NUMERIC(8, 2);
			job_max_salary NUMERIC(8, 2);
			possible_raise NUMERIC(8, 2);
	
		BEGIN
		
			-- Tomar el puesto de trabajo y el salario
			SELECT job_id, salary
					INTO employee_job_id, current_salary
				FROM employees
				WHERE employee_id = empl_id;

			-- Tomar el max salary, acorde a su job
			SELECT max_salary INTO job_max_salary
				FROM jobs
				WHERE job_id = employee_job_id;

			-- Cálculos
			possible_raise = job_max_salary - current_salary;

			IF(possible_raise < 0) THEN
			
				RAISE EXCEPTION 'Persona con salario mayor max_salary: %', empl_id;
			
			END IF;

			RETURN possible_raise;
					
		END;

	$max_raise_calculation$
	LANGUAGE plpgsql;
```


## Rowtype

Nos permite almacenar toda una fila de la base de datos en una variable para sólo declarar una variable.

```sql
CREATE OR REPLACE FUNCTION max_raise_2(empl_id int)
	RETURNS NUMERIC(8, 2)
	AS $max_raise_calculation$
		
		DECLARE
			-- Declaración ROWTYPE
			selected_employee employees%rowtype;
			selected_job jobs%rowtype;
			possible_raise NUMERIC(8, 2);
	
		BEGIN
		
			-- Tomar el puesto de trabajo y el salario y asignar valor a ROWTYPE
			SELECT *
				FROM employees INTO selected_employee
				WHERE employee_id = empl_id;

			-- Tomar el max salary, acorde a su job
			SELECT *
				FROM jobs INTO selected_job
				WHERE job_id = selected_employee.job_id;

			-- Cálculos
			possible_raise = selected_job.max_salary - selected_employee.salary;

			IF(possible_raise < 0) THEN
			
				RAISE EXCEPTION 'Persona con salario mayor max_salary: id: %, %', selected_employee.employee_id, selected_employee.first_name;
			
			END IF;

			RETURN possible_raise;
					
		END;

	$max_raise_calculation$
	LANGUAGE plpgsql;
```


## Retornar tablas en funciones

Podemos hacer el retorno de una tabla (varios registros con varias columnas) en nuestras funciones según sea necesario.

```sql
CREATE OR REPLACE FUNCTION country_region()
	RETURNS TABLE(id CHARACTER(2), name VARCHAR(40), region VARCHAR(25))
	AS $$
	
		BEGIN
		
			RETURN query
				SELECT country_id, country_name, region_name
					FROM countries
					INNER JOIN regions
						ON countries.region_id = regions.region_id;
		
		END;
	
	$$ LANGUAGE plpgsql;
```


## Eliminar funciones

Si requerimos eliminar una función lo podemos lograr muy fácilmente ejecutando el siguiente comando:

```sql
DROP FUNCTION max_raise_2;
```


## Stored Procedures

Son de cierta forma funciones que no necesariamente retornan data, puede simplemente procesar data, hacer cálculos y demás.

```sql
-- Crear procedimiento almacenado (no aplicará cambios dado que siempre está haciend el ROLLBACK)
CREATE OR REPLACE PROCEDURE insert_region_proc(INT, VARCHAR)
	AS $$
		
		BEGIN
		
			INSERT INTO regions(region_id, region_name)
				VALUES($1, $2);

			RAISE NOTICE 'Variable 1: %', $1;

			ROLLBACK;
		
		END;
		
	$$ LANGUAGE plpgsql;


-- Ejecutar procedimiento
CALL insert_region_proc(5, 'Central America');
```

En los procedimientos almacenados podemos utilizar la instrucción ROLLBACK para decirle a PostgreSQL que si sucede algún error ejecutando nuestro procedimiento simplemente regrese los valores a su estado original antes de ejecutar el procedimiento. A su vez, el RAISE NOTICE sirve para hacer debug de nuestro procedimiento almacenado.

Si en vez hacer ROLLBACK queremos que guarde los cambios que se realizan en nuestro procedimiento almacenado podemos ejecutar la instrucción COMMIT.

```sql
CREATE OR REPLACE PROCEDURE insert_region_proc(INT, VARCHAR)
	AS $$
		
		BEGIN
		
			INSERT INTO regions(region_id, region_name)
				VALUES($1, $2);

			RAISE NOTICE 'Variable 1: %', $1;

			COMMIT;
		
		END;
		
	$$ LANGUAGE plpgsql;

CALL insert_region_proc(5, 'Central America');
```


## Insertar data con procedimientos almacenados

```sql
CREATE OR REPLACE PROCEDURE controlled_raise(percentage NUMERIC(4, 2))
	AS $$
		
		DECLARE
			real_percentage NUMERIC(8, 2);
			total_employees INT;
		
		BEGIN
		
			real_percentage = percentage / 100;

			-- Mantener el histórico
			INSERT INTO raise_history(date, employee_id, base_salary, amount, percentage)
				SELECT CURRENT_DATE AS "date",
					employee_id,
					salary,
					max_raise(employee_id) * real_percentage AS amount,
					percentage
				FROM employees;

			-- Impactar la tabla de empleados
			UPDATE employees
				SET salary = (max_raise(employee_id) * real_percentage) + salary;

			COMMIT;

			SELECT COUNT(*) INTO total_employees
				FROM employees;

			RAISE NOTICE 'Afectados % empleados', total_employees;
		
		END;
		
	$$ LANGUAGE plpgsql;

CALL controlled_raise(10);
```