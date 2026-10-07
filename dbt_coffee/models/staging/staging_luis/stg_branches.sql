select
    branch_id,
    name as branch_name
from {{source('raw', 'branches')}}