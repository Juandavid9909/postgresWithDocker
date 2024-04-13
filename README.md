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