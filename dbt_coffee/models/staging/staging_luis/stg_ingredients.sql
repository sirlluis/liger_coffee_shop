SELECT
    ingredient_id,
    name AS ingredient_name,
    unit_of_measure,
    unit_cost AS standard_unit_cost, 
    par_level,
    is_active
FROM {{source('raw', 'ingredients')}}


--Extra: En contabilidad de costos, los costos estándar se fijan una vez por periodo de presupuesto, que casi siempre es el año fiscal, y se mantienen congelados todo ese periodo.