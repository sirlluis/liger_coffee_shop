SELECT * FROM {{ source('raw', 'orders') }}
WHERE created_at IS NOT NULL
