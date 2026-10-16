select
    cast(movement_week as date) as movement_week,
    ingredient_id,
    -sum(movement_quantity) as consumo_real --el (-1) es por que originalmente las salidas de inventario se denotan con signo negativ
from {{ref('stg_inventory_movements')}}
where movement_type in ('sale', 'waste')
group by
    movement_week,
    ingredient_id