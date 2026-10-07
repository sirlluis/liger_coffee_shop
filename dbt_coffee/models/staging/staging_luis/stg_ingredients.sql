select
    ingredient_id,
    name as ingredient_name,
    unit_of_measure,
    unit_cost,
    category as ingredient_category,
    par_level,
    is_active
from {{source('raw', 'ingredients')}}
