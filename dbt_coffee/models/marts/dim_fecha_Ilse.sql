with fechas as (
    select generate_series(
        '2024-09-01'::date,
        '2026-08-31'::date,
        interval '1 day'
    )::date as fecha
)

select
    fecha,
    extract(year from fecha)::int as anio,
    extract(quarter from fecha)::int as trimestre,
    extract(month from fecha)::int as mes,
    (array['enero','febrero','marzo','abril','mayo','junio','julio',
           'agosto','septiembre','octubre','noviembre','diciembre'])
        [extract(month from fecha)::int] as nombre_mes,
    date_trunc('week', fecha)::date as semana,
    extract(isodow from fecha)::int as dia_semana,
    (array['lunes','martes','miércoles','jueves','viernes','sábado','domingo'])
        [extract(isodow from fecha)::int] as nombre_dia,
    extract(isodow from fecha) in (6, 7) as es_fin_de_semana
from fechas