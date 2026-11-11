select
    movement_id,
    ingredient_id,
    order_item_id,
    movement_quantity,
    occurred_at,
    movement_date,
    extract(hour from occurred_at) as movement_hour
from {{ref('stg_inventory_movements')}}
