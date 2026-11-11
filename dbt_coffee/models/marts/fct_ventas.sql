select
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    o.branch_id,
    cast(o.created_at as date) as order_date,
    o.created_at,
    o.in_or_out,
    o.payment_method,
    oi.quantity,
    oi.sale_price,
    oi.line_total
from {{ ref('stg_order_items') }} as oi
join {{ ref('stg_orders') }} as o
    on oi.order_id = o.order_id