select
    m.movement_id,
    m.movement_type,
    i.ingredient_name,
    m.movement_quantity,
    m.movement_date,
    f.nombre_dia,
    f.es_fin_de_semana
from {{ref('stg_inventory_movements')}} as m
left join {{ref('dim_insumo')}} as i on m.ingredient_id=i.ingredient_id
left join {{ref('dim_fecha')}} as f on m.movement_date=f.fecha

