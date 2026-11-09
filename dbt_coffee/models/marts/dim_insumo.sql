select
    ingredient_id,
    ingredient_name,
    ingredient_category,
    unit_of_measure,
    standard_unit_cost,
    par_level,
    is_active
from {{ ref('stg_ingredients') }}

--Nota: dbt run --select +dim_producto +dim_insumo. El + es un operador de grafo de dbt: le dice “incluye también los modelos de los que depende este”. Se pone pegado al nombre, sin espacio.
      --dbt sabe de qué depende cada modelo porque lee los ref()