WITH ventas AS (
    SELECT
        DATE_TRUNC('week', o.created_at) ::date AS semana, --conteo de ordenes por semana
        oi.product_id, --Nota 1
        SUM(oi.quantity) AS unidades_vendidas
    FROM {{ ref('stg_order_items') }} AS oi
    JOIN {{ ref('stg_orders')}} AS o 
        ON oi.order_id = o.order_id
    GROUP BY 1, 2 --o GROUP BY semana, oi.product_id (las filas con la misma combinación de semana y producto se juntan en una)
)

SELECT
    v.semana,
    r.ingredient_id,
    SUM(v.unidades_vendidas * r.quantity_required) AS consumo_teorico
FROM ventas AS v
JOIN {{ ref('stg_recipes') }} AS r
    ON v.product_id = r.product_id
GROUP BY 1, 2

--Nota 1: --la relación entre venta e ingrediente no es directa, los une product_id y a su vez recipe_id. Por eso se hace un join con la tabla de recetas (stg_recipes) para obtener el ingredient_id
--DATE_TRUNC recorta una fecha hasta cierta unidad de tiempo. Es decir, todos los dias de la semana, de lunes a domingo, los marca como si pertenecieran al
           --dia lunes de esa semana. Por ejemplo, la fecha 2023-06-05 (lunes), DATE_TRUNC('week', '2023-06-05') nos devolverá 2023-06-05. Pero si tenemos la 
           --fecha 2023-06-07 (miércoles), DATE_TRUNC('week', '2023-06-07') nos devolverá 2023-06-05 también, ya que pertenece a la misma semana que el lunes 2023-06-05.
-- "::" es el operador de conversión de tipo (cast) de Postgres. Convierte un valor de un tipo de dato a otro. Es igual a colocar cast(DATE_TRUNC('week', o.created_at) as date)