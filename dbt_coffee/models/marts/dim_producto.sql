select
    product_id,
    product_name,
    product_category,
    unit_price,
    is_active
from {{ ref('stg_products') }}