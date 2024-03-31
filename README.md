#  Tipos de bases de datos

## SQL

Son parecidas a una hoja de Excel, tienen columnas, valores, tipos de datos y tiene una estructura fija.


## No SQL

Almacenan la información en objetos que suelen ser llamados documentos, y colecciones que agrupan dichos documentos. Este tipo de información luce similar a los objetos JSON.


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