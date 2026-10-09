SELECT
    branch_id,
    name AS branch_name
FROM {{source('raw', 'branches')}}