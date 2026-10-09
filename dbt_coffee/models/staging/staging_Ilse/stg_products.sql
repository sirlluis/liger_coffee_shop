SELECT
    product_id, 
    name AS product_name, --before name (ingredientes and branches have a column called name)
    category AS product_category, --before category (only products have a column called category)
    unit_price AS product_unit_price, --before unit_price
    is_active
FROM {{ source('raw', 'products') }}