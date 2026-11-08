select
    product_id,
    product_name,
    product_category,
    product_unit_price,
    is_active
from {{ ref('stg_products') }}