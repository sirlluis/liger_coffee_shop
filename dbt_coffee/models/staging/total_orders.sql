select
    count(order_id) as total_orders
from {{source('raw', 'orders')}}