select
    semana,
    ingredient_id,
    cantidad_comprada,
    costo_real_total,
    costo_estandar_total,
    costo_real_total - costo_estandar_total as varianza_precio --Nota 1
from {{ ref('int_costo_compra') }}

--Nota 1: Un signo positivo: pagaste más que el estándar (desfavorable). - signo negativo: pagaste menos que el estándar (favorable).