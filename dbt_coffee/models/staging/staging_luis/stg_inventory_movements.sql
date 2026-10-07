select
    movement_id,
    ingredient_id,
    movement_type,
    order_item_id,
    quantity as movement_quantity,
    purchase_id,
    occurred_at,
    cast(occurred_at as date) as movement_date,
    extract(hour from occurred_at) as movement_hour,
    notes as movement_notes
from {{source('raw', 'inventory_movements')}}
