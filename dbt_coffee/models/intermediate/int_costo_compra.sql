WITH compras AS (
    SELECT
        DATE_TRUNC('week', p.purchase_date) ::date AS semana, --nota1 
        p.ingredient_id,
        SUM(p.purchase_quantity) AS cantidad_comprada,
        SUM(p.purchase_quantity * p.unit_purchase_cost) AS costo_real_total
    FROM {{ ref('stg_purchases') }} AS p
    GROUP BY 1, 2
)

SELECT
    c.semana,
    c.ingredient_id,
    c.cantidad_comprada,
    c.costo_real_total,
    c.cantidad_comprada * i.standard_unit_cost AS costo_estandar_total,
    c.costo_real_total / NULLIF(c.cantidad_comprada, 0) AS costo_promedio_real --Nota 2
FROM compras AS c
JOIN {{ ref('stg_ingredients') }} AS i
    ON c.ingredient_id = i.ingredient_id


-- Nota 1: aunque purchase_date ya es tipo date, DATE_TRUNC siempre devuelve un timestamp (por ejemplo, Si le pasas 2025-03-05, regresa 2025-03-03 00:00:00)
-- Nota 2: NULLIF evita la división por cero. Si cantidad_comprada es 0, el resultado será NULL en lugar de un error.