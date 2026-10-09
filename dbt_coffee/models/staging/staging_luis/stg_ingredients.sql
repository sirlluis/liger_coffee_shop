select
    ingredient_id,
    name as ingredient_name,
    unit_of_measure,
    unit_cost, -- recomendación: llamarlo standard_unit_cost para distinguirlo del unit_cost_real de las compras. La diferencia entre esos dos costos es la base de la varianza de precio.
    category as ingredient_category,
    par_level,
    is_active
from {{source('raw', 'ingredients')}}


--Extra: En contabilidad de costos, los costos estándar se fijan una vez por periodo de presupuesto, que casi siempre es el año fiscal, y se mantienen congelados todo ese periodo.