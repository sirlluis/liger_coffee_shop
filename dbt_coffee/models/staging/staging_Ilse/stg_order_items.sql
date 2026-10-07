SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    sale_price,
    quantity * sale_price AS line_total --New line
FROM {{ source('raw', 'order_items') }}