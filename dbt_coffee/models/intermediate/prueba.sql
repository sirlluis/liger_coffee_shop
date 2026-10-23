SELECT
    DATE_TRUNC('week', o.created_at) ::date AS semana, --conteo de ordenes por semana
    oi.product_id,
    SUM(oi.quantity) AS unidades_vendidas
FROM {{ ref('stg_order_items') }} AS oi
JOIN {{ ref('stg_orders')}} AS o 
    ON oi.order_id = o.order_id
GROUP BY 1, 2
