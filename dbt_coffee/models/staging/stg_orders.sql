SELECT
    order_id,
    branch_id,
    created_at,
    in_or_out,
    payment_method
FROM {{ source('raw', 'orders') }}
WHERE created_at IS NOT NULL