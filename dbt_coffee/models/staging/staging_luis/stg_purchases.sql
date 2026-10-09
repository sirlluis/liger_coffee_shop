SELECT
    purchase_id,
    ingredient_id,
    branch_id,
    quantity AS purchase_quantity, 
    unit_cost_real AS unit_purchase_cost,
    quantity * unit_cost_real AS purchase_total_cost, --La varianza de precio se calcula sobre el gasto total, así que tener esa columna desde staging evita repetir la multiplicación en cada modelo posterior.
    trim(supplier_name) AS supplier_name, --la función TRIM() elimina los espacios iniciales y finales de una cadena.
    cast(purchased_at AS date) as purchase_date --CAST() convierte un valor (de cualquier tipo) en un tipo de dato específico.
FROM {{source('raw', 'purchases')}}