select
    purchase_id,
    ingredient_id,
    branch_id,
    quantity as purchase_quantity, --se me hace más limpio tener un orden, si en inventory_movement nombraste la columna como movement_quantity, aquí la llamaría purchase_quantity.
    unit_cost_real as unitary_purchase_cost, --En inglés suena más natural decir "unit_purchase_cost" que "unit_cost_real"
    --quantity * unit_cost_real as total_cost, --La varianza de precio se calcula sobre el gasto total, así que tener esa columna desde staging evita repetir la multiplicación en cada modelo posterior.
    trim(supplier_name) as supplier_name, --la función TRIM() elimina los espacios iniciales y finales de una cadena.
    cast(purchased_at as date) as purchase_date --CAST() convierte un valor (de cualquier tipo) en un tipo de dato específico.
from {{source('raw', 'purchases')}}