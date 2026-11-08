select
    ingredient_id,
    ingredient_name,
    ingredient_category,
    unit_of_measure,
    standard_unit_cost,
    par_level,
    is_active
from {{ ref('stg_ingredients') }}