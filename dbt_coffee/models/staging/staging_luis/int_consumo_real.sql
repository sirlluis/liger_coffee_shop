select
    im.movement_week,
    oi.product_id,
    sum(im.movement_quantity)*(-1) as consumo_real
from {{ref('stg_inventory_movements')}} as im
left join {{ref('stg_order_items')}} as oi
    on im.order_item_id=oi.order_item_id
where im.movement_type in ('sale', 'waste')
group by
    im.movement_week,
    oi.product_id