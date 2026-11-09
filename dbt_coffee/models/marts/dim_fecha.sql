select
    created_at,
    extract(hour  from created_at) as order_hour,
    extract(day   from created_at) as order_day,
    extract(month from created_at) as order_month,
    extract(year  from created_at) as order_year,
    extract(isodow   from created_at) as day_of_week
    -- isodow: día de la semana según ISO 8601 (1 = lunes ... 7 = domingo)
from {{ ref('stg_orders') }}