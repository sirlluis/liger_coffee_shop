SELECT
    COALESCE(r.semana, t.semana) AS semana,
    COALESCE(r.ingredient_id, t.ingredient_id) as ingredient_id,
    insumo.ingredient_name,
    insumo.unit_of_measure,
    COALESCE(r.consumo_real, 0)-COALESCE(t.consumo_teorico, 0) as varianza_cantidad,
FROM {{ref("int_consumo_real")}} AS r
FULL JOIN {{ref("int_consumo_teorico")}} as t
    ON r.semana=t.semana AND r.ingredient_id=t.ingredient_id
JOIN {{ref("dim_insumo")}} as insumo
    ON r.ingredient_id=insumo.ingredient_id