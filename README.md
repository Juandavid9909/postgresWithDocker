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