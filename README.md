# Un proyecto para el análisis de una cafetería

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

# Introducción
La operación de una cafetería genera valiosa información que puede ser analizada para extraer datos relevantes sobre su dinámica de consumo. En este proyecto se explora el comportamiento de un comercio de bebidas y alimentos usando datos sintéticos que emulan de manera realista la arquitectura operativa de un establecimiento que lleva un control de las ventas y su inventario.

# Objetivo
- Emular la arquitectura de una base de datos operativa para un negocio de venta de bebidas y alimentos.
- Elaborar un análisis de datos para extraer indicadores clave del desempeño del establecimiento que permitan tomar decisiones informadas.

# Datos
Se generaron datos sintéticos para una cafetería que cubre 2 años de operacion (104 semanas), se contempló estacionalidad para implementar un modelo de predicción de demanda. Los patrones de estacionalidad incluidos son:

  1. Estacional por categoría: bebidas frías suben en primavera/verano,
     bebidas calientes suben en otoño/invierno (hemisferio norte, México).
  2. Día de la semana: viernes/sábado son los días de mayor tráfico,
     lunes el más bajo.
  3. Hora del día: picos en desayuno (7-10am) y tarde-café (4-6pm).
  4. Eventos/temporadas altas: regreso a clases (ago-sep), Día de Muertos,
     temporada navideña (dic), Día de las Madres (mayo).
  5. Tendencia de crecimiento: el negocio crece ~12% anual de forma gradual.

## Archivos CSV

### Conteo de registros
| Archivo | Registros |
| --- | ---: |
| `data/raw/branches.csv` | 2 |
| `data/raw/ingredients.csv` | 18 |
| `data/raw/products.csv` | 12 |
| `data/raw/recipes.csv` | 39 |
| `data/raw/orders.csv` | 43,267 |
| `data/raw/order_items.csv` | 66,924 |
| `data/raw/purchases.csv` | 3,780 |
| `data/raw/inventory_movements.csv` | 221,941 |
| `data/processed/orders.csv` | 43,267 |

### Datos crudos (`data/raw/`)
| Archivo | Descripción | Columnas |
| --- | --- | --- |
| `branches.csv` | Catálogo de sucursales. | `branch_id`, `name` |
| `ingredients.csv` | Catálogo de insumos/ingredientes con costo y unidad de medida. | `ingredient_id`, `name`, `unit_of_measure`, `unit_cost`, `category` |
| `products.csv` | Catálogo de productos vendidos (bebidas/alimentos) y su precio unitario. | `product_id`, `name`, `category`, `unit_price` |
| `recipes.csv` | Receta/BOM: relación entre productos e ingredientes con cantidad requerida. | `recipe_id`, `product_id`, `ingredient_id`, `quantity_required` |
| `orders.csv` | Encabezado de órdenes/ventas por sucursal. | `order_id`, `branch_id`, `created_at`, `in_or_out`, `payment_method` |
| `order_items.csv` | Detalle de productos vendidos en cada orden. | `order_item_id`, `order_id`, `product_id`, `quantity`, `sale_price` |
| `purchases.csv` | Compras de insumos por sucursal y proveedor (costo real). | `purchase_id`, `ingredient_id`, `branch_id`, `quantity`, `unit_cost_real`, `supplier_name`, `purchased_at` |
| `inventory_movements.csv` | Movimientos de inventario de insumos (entradas/salidas) y su referencia. | `movement_id`, `ingredient_id`, `movement_type`, `quantity`, `order_item_id`, `purchase_id`, `occurred_at`, `notes` |

### Datos procesados (`data/processed/`)
| Archivo | Descripción | Columnas |
| --- | --- | --- |
| `orders.csv` | Versión procesada/exportada de órdenes con la misma estructura base. | `order_id`, `branch_id`, `created_at`, `in_or_out`, `payment_method` | # Metodología

## La base de datos
Se utilizó Neon Postgres como base de datos <em>serverless</em> PostgreSQL, con el objetivo de trabajar de forma colaborativa de manera remota, además de aprender como se administra una base de datos en la nube.

Los datos iniciales se cargaron a Neon desde los archivos `.csv` de `data/` usando el comando `\copy` de `psql`:

``` bash
psql "$DATABASE_URL$" -c "\copy usuarios FROM 'data/usuarios.csv' WITH (FORMAT csv, HEADER true)"
``` 

Se enviaron de acuerdo al esquema de la base de datos ya que este contiene las dependencias entre las llaves foráneas, reestricciones y disparadores.

# Metodología
# Resultados
# Tecnologías utilizadas
Para el desarrollo de este proyecto se utilizó:
- *Python* para el análisis de datos y modelos de aprendizaje.
- *PostgreSQL* como el motor de base de datos.
- *Neon* como la versión PostgreSQL <em>serverless</em> para administrar la base de datos y trabajar de forma colaborativa.
- *PowerBI* para la creación de <em>dashboards</em> donde se muestran los indicadores clave del negocio.

# Conclusiones
# Referencias
