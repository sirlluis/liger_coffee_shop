with margen as (
    select
        p.product_id,
        p.product_unit_price - sum(r.quantity_required * i.standard_unit_cost) as margen_estandar
    from {{ ref('dim_producto') }} p
    join {{ ref('stg_recipes') }} r on r.product_id = p.product_id
    join {{ ref('dim_insumo') }} i on i.ingredient_id = r.ingredient_id
    group by p.product_id, p.product_unit_price
),

ventas_semana as (
    select
        date_trunc('week', order_date)::date as semana,
        product_id,
        sum(quantity) as unidades
    from {{ ref('fct_ventas') }}
    group by 1, 2
),

mezcla_esperada as (
    select
        product_id,
        sum(quantity)::numeric / sum(sum(quantity)) over () as proporcion
    from {{ ref('fct_ventas') }}
    where order_date < '2025-09-01'   -- periodo base: primer año
    group by product_id
),

totales as (
    select semana, sum(unidades) as total_unidades
    from ventas_semana
    group by semana
)

select
    v.semana,
    v.product_id,
    v.unidades,
    t.total_unidades * e.proporcion as unidades_esperadas,
    m.margen_estandar,
    (v.unidades - t.total_unidades * e.proporcion) * m.margen_estandar as varianza_mezcla
from ventas_semana v
join totales t on t.semana = v.semana
join mezcla_esperada e on e.product_id = v.product_id
join margen m on m.product_id = v.product_id