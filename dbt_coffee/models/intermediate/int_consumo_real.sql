select
    date_trunc('week', im.movement_date)::date as semana,
    im.ingredient_id,
    -sum(im.movement_quantity) filter (where im.movement_type = 'sale')  as consumo_ventas,
    -sum(im.movement_quantity) filter (where im.movement_type = 'waste') as merma,
    -sum(im.movement_quantity) as consumo_real
from {{ ref('stg_inventory_movements') }} as im
where im.movement_type in ('sale', 'waste') --Nota 1
group by 1, 2

--Nota 1. Volvemos a colocar where porque sin ese filtro, consumo_real sumaría todos los tipos de movimiento, y dos de ellos no son consumo (purchase y adjustment)



