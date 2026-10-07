select
    purchase_id,
    ingredient_id,
    branch_id,
    quantity,
    unit_cost_real as unitary_purchase_cost,
    trim(supplier_name) as supplier_name,
    cast(purchased_at as date) as purchase_date
from {{source('raw', 'purchases')}}