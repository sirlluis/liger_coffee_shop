select
    branch_id,
    branch_name
from {{ref('stg_branches')}}