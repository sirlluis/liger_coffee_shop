# Varianza de mezcla (ventas por producto)

## Qué es

Mide cuánto cambia el margen total **solo por cómo se reparten las unidades vendidas entre productos**, sin considerar cuántas unidades se vendieron en total ni cambios de precio o costo.

Pregunta que responde: *con el mismo volumen real, ¿el reparto que ocurrió generó más o menos margen que el reparto de referencia?*

## Fórmula

$$
\text{Var. mezcla}_i = \left(Q^{real}_i - Q^{real}_{total}\cdot m^{ref}_i\right)\cdot MC^{ref}_i
$$

Varianza de mezcla total = suma de $\text{Var. mezcla}_i$ sobre todos los productos.

## Variables

| Símbolo | Significado | Periodo de origen |
|---|---|---|
| $i$ | Producto (latte, americano, pan...) | n/a |
| $Q^{real}_i$ | Unidades vendidas del producto $i$ | Periodo analizado |
| $Q^{real}_{total}$ | Unidades vendidas de todos los productos | Periodo analizado |
| $m^{ref}_i$ | Proporción del producto $i$ en la referencia: $Q^{ref}_i / Q^{ref}_{total}$ | Referencia |
| $MC^{ref}_i$ | Margen de contribución unitario: precio − costo variable unitario | Referencia |

- **Real** = lo que pasó en el periodo que se evalúa.
- **Referencia** (antes "presupuestado") = contra qué se compara: presupuesto formal, mismo mes del año anterior, promedio de los últimos meses o un pronóstico. **Es una decisión del análisis y debe quedar declarada.**
- El margen se toma de la referencia para que esta varianza no se contamine con cambios de precio o costo.
- Costo variable = insumos de la receta + empaque + comisiones por unidad. No incluye renta, nómina fija ni luz.

## Cómo leer la fórmula

- $Q^{real}_{total}\cdot m^{ref}_i$ = unidades que habría vendido del producto $i$ con mi volumen real pero con la mezcla de referencia.
- El paréntesis = diferencia en unidades: positivo si vendí más de lo esperado, negativo si vendí menos.
- Multiplicar por $MC$ convierte esa diferencia en dinero.
- Las diferencias en unidades de todos los productos suman 0: es una redistribución, no un cambio de tamaño.

## Ejemplo

| Producto | Margen/u | Unid. ref. | Mezcla ref. | Unid. reales | Esperadas con mezcla ref. (1,100 × m) | Diferencia | Var. mezcla |
|---|---|---|---|---|---|---|---|
| Latte | $40 | 500 | 50% | 450 | 550 | −100 | −$4,000 |
| Americano | $30 | 300 | 30% | 330 | 330 | 0 | $0 |
| Pan | $20 | 200 | 20% | 320 | 220 | +100 | +$2,000 |
| **Total** | | 1,000 | | 1,100 | 1,100 | 0 | **−$2,000** |

Interpretación: con las mismas 1,100 unidades, el reparto real generó $2,000 menos de margen que el de referencia ($34,300 vs $36,300). El latte (mayor margen) perdió participación (50% → 40.9%) y el pan (menor margen) ganó (20% → 29.1%). Se pierde la diferencia de márgenes en las unidades redistribuidas: 100 × ($40 − $20) = $2,000.

## Relación con otras varianzas

- Varianza de volumen = ($Q^{real}_{total} - Q^{ref}_{total}$) × margen promedio de referencia = 100 × $33 = +$3,300
- Varianza de mezcla = −$2,000
- Variación total del margen = +$3,300 − $2,000 = **+$1,300** ($34,300 − $33,000)

Esto se cumple solo si ambas varianzas usan el margen de referencia. Los cambios de precio y de costo caen en sus propias varianzas.

## Qué NO dice el número

- No dice que los clientes sustituyeron un producto por otro; describe el resultado, no el mecanismo.
- No dice que el periodo fue malo (el total puede ser favorable por el volumen).
- No explica la causa: señala dónde investigar (promociones, precios, disponibilidad, estacionalidad).
- Depende de la referencia elegida: otra referencia puede dar otro valor, incluso de signo contrario.
- Si todos los productos tuvieran el mismo margen, la varianza sería 0 por construcción.

## Planteamiento en SQL (sin código)

Meta: una tabla con **un renglón por producto** con todas las piezas de la fórmula.

1. **Ventas reales por producto**: filtrar el periodo analizado, agrupar por producto, sumar unidades → $Q^{real}_i$.
2. **Referencia por producto**: lo mismo con el periodo de referencia → $Q^{ref}_i$.
3. **Margen unitario de referencia**: recetas × costo de insumos (agrupado por producto) + empaque; precio del periodo de referencia; margen = precio − costo variable → $MC^{ref}_i$.
4. **Unir todo por producto** con un join que conserve ambos lados (full outer join) y rellenar vacíos con 0. Un join normal elimina en silencio productos nuevos o descontinuados.
5. **Totales en cada renglón** con función de ventana (suma de toda la columna sin colapsar filas) → $Q^{real}_{total}$ y $Q^{ref}_{total}$.
6. **Calcular por renglón**, en orden: proporción de referencia → cantidad esperada → diferencia en unidades → varianza (diferencia × margen).
7. **Sumar** la columna de varianza para el total; por producto indica quién la causa.

## Validaciones

- Las proporciones de referencia suman 1.
- La suma de las diferencias en unidades es 0.
- Volumen + mezcla = variación total del margen.

## Errores típicos

- Comparar periodos de distinta duración (mes completo vs parcial).
- Duplicar filas por unir ventas con recetas antes de agregar; agregar cada fuente por separado y unir al final.
- No decidir cómo tratar devoluciones y descuentos (¿restan unidades o precio?).
- No definir qué precio cuenta como referencia si cambió durante el periodo.
- No declarar ni limpiar la referencia (estacionalidad, promociones, eventos atípicos, productos nuevos).