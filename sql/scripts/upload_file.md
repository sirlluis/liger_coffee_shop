# Subir los registros a la base de datos
Para enlazar los archivos `.csv` a la base de datos en PostgreSQL se ejecuta la siguiente línea de comandos en la terminal de `psql`:
```sql
\copy schema.table_name(column_name_1, column_name_2)
FROM 'csv_file_path.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8')
```
Esta acción se debe efectuar para cada tabla de la estructura de la base de datos.