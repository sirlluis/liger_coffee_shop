SELECT
    recipe_id,
    product_id,
    ingredient_id,
    quantity_required
FROM {{ source('raw','recipes') }}

--Extra: la diferencia entre source y ref es que source hace referencia a una tabla externa (no generada con dbt) 
       --mientras que ref hace referencia a una tabla interna de dbt (es decir, llamas a un modelo que dbt generó).