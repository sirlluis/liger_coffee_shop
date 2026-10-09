SELECT
    order_id,
    branch_id,
    created_at,
    cast(created_at as date) as order_date,
    extract(hour from created_at) as order_hour,
    in_or_out,
    payment_method
FROM {{ source('raw', 'orders') }}
WHERE created_at IS NOT NULL --condición ya creada en la tabla de postgres