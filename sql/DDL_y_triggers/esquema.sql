-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Nota 1: para agrgar un comentario corto se agrega "--" al inicio de la linea, para agregar un comentario largo se agrega "/*" al inicio y "*/" al final del comentario */
/* Nota 2: para definir una tabla se utiliza la sintaxis "CREATE TABLE nombre_tabla (columna1 tipo_dato, columna2 tipo_dato, ...)". En este caso usamos BIGINT y no INT (o incluso SMALLINT)
porque las otras tablas a las que estará conectada branch lo llevarán, entonces es para mantener la consistencia con el resto del esquema y no tener problemas de tipo de dato relacionales  */
/* Nota 3: PRIMARY KEY le dice a Postgres que esta columna identifica de forma única cada fila (RIMARY KEY incluye automáticamente NOT NULL y UNIQUEno puede repetirse, y no puede quedar vacía)*/
/* Nota 4: NOT NULL le dice a Postgres que esta columna no puede quedar vacía (no puede ser NULL) */
/* Nota 5: BIGSERIAL combina una  olumna BIGINT (mismo rango) con un generador automático de secuencias. Es decir, crear una columna que se incrementa automáticamente */
/* Nota 6: NUMERIC(10,2) define una columna de tipo numérico un número decimal con hasta 10 dígitos en total y 2 decimales despues del punto */
/* Nota 7: CHECK (condition o constraint) le dice a Postgres que esta columna debe cumplir con una condición específica */
/* Nota 8: BOOLEAN Almacena un valor de lógica binaria que indica si una condición se cumple o no. Valores posibles: Únicamente verdadero (true) o falso (false).*/
/* Nota 9: is_active permite "apagar" un insumo sin borrarlo de la base de datos. Por ejemplo, si dejas de usar un ingrediente (cambiaste de proveedor de jarabe, o descontinuaste un sabor), en
vez de hacer DELETE sobre esa fila, cambias is_active a false sin perder trazabilidad.*/
/* Nota 10: Al llamar nuevamente a ingrediente_id y product_id usamos ahora BIGINT en lugar de BIGSERIAL ya que no va agenerarse nada nuevo en esas columnas dentro de la tabla Recipes, solo 
se jalan los datos ya creados en sus tablas originales*/
/* Nota 11: REFERENCES le dice a Postgres que esta columna es una clave foránea que hace referencia a otra tabla */
/* Nota 12: ON DELETE RESTRICT le dice a Postgres que no se puede borrar un producto si tiene recetas asociadas. Esto es para mantener la integridad referencial de la base de datos.
Existe tambien ON DELETE CASCADE donde i elimina un registro en la tabla principal, la base de datos busca y elimina automáticamente todas las filas coincidentes en la tabla secundaria.*/
/* Nota 13: UNIQUE esta columna debe tener valores únicos sobre dos columnas juntas, no sobre una sola. Sí puede repetirse product_id solo (el latte tiene varias filas, una por cada insumo) 
o ingredient_id solo (el café en grano aparece en varias recetas distintas) — lo que no puede repetirse es la pareja exacta de los dos juntos. */
/* Nota 14: TIMESTAMP almacena fecha y hora en formato YYYY-MM-DD HH:MM:SS.*/
/* Nota 15: CHECK (namecolumn IN("categ1","categ2",..."categn")) da una lista cerrada de valores permitidos para una columna de texto.*/
/* Nota 16: A pesar de que ya existe el precio en products.unit_price, sale_price nos permite actualizar en tiempo real el precio de venta de un producto sin tener que modificar la tabla products,
que es más bien un catálogo de productos y precios base. Por ejemplo, si hay una promoción de 2x1 en un latte, se puede cambiar el sale_price a la mitad del unit_price sin afectar la tabla products.*/
/* Nota 17: adjustment es la categoría para corregir el inventario cuando el conteo físico no coincide con lo que la base de datos dice que debería haber — sin necesidad de saber la causa exacta de 
la diferencia. Si Postgres dice, sumando todos los movimientos, que deberían quedar 18 kg de café en grano, pero al contar físicamente solo hay 16.5 kg, insertas un movimiento de tipo adjustment con 
quantity = -1.5 para que el sistema quede alineado con la realidad.*/
/* Nota 18: order_item_id y purchase_id son ambas nullable (no llevan NOT NULL) porque ningún movimiento necesita las dos, y algunos (merma, ajuste) no necesitan ninguna. Cada fila usa como
máximo una de las dos, nunca ambas. Esto es porque o el movimiento es de venta (order_item_id) o de compra (purchase_id), o ninguno (merma,ajuste,etc.)*/
/*Nota 19: CHECK dentro de movements es necesario porque relacionas los tipos de movimiento con sus respectivas claves foráneas (por ejemplo sale unicamente con order_item_id). Así evitas que por
ejemplo en movement_type tengas "sale" pero con order_item_id vacío y purchase_id lleno */
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--DDL de la base de datos para el sistema de inventario y ventas de un restaurante.

------ Sucursales ------
CREATE TABLE branches (
    branch_id   BIGINT PRIMARY KEY,
    name        TEXT NOT NULL
);

------ Insumos (materia prima que se comprs y almacena) ------
CREATE TABLE ingredients (
    ingredient_id   BIGSERIAL PRIMARY KEY,
    name            TEXT NOT NULL,
    unit_of_measure TEXT NOT NULL,
    unit_cost       NUMERIC(10,2) NOT NULL CHECK (unit_cost >= 0),
    category        TEXT,
    par_level       NUMERIC(10,2) CHECK (par_level >= 0), --sirve para saber el minimo de inventario que se debe tener de cada insumo, para poder generar alertas de compra
    is_active       BOOLEAN NOT NULL DEFAULT true -- Nota 9
);

----- Productos (el menú) ------
CREATE TABLE products (
    product_id  BIGSERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    category    TEXT NOT NULL,
    unit_price  NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    is_active   BOOLEAN NOT NULL DEFAULT true
);

------ Recetas (una fila = un insumo dentro de la receta de un producto) ------
CREATE TABLE recipes (
    recipe_id           BIGSERIAL NOT NULL PRIMARY KEY,
    product_id          BIGINT NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,
    ingredient_id       BIGINT NOT NULL REFERENCES ingredients(ingredient_id) ON DELETE RESTRICT,
    quantity_required   NUMERIC(10,3) NOT NULL CHECK (quantity_required >= 0), --son tres decimales porque hay ingredientes que se miden en mililitros (ml) y gramos (g) y hay que ser precisos
    UNIQUE              (product_id, ingredient_id)
);

------ Pedidos ------
CREATE TABLE  orders (
    order_id        BIGSERIAL PRIMARY KEY,
    branch_id       BIGINT NOT NULL REFERENCES branches(branch_id) ON DELETE RESTRICT,
    created_at      TIMESTAMP NOT NULL,
    in_or_out       TEXT NOT NULL CHECK (in_or_out IN ("dine_in", "take_out")), --Nota 15 
    payment_method  TEXT NOT NULL CHECK (payment_method IN ("cash","card"))
);

------ items de cada pedido ------
CREATE TABLE order_items (
    order_item_id   BIGSERIAL PRIMARY KEY,
    order_id        BIGINT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id      BIGINT NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity        NUMERIC(10,2) NOT NULL CHECK (quantity >= 0),
    sale_price      NUMERIC(10,2) NOT NULL CHECK (sale_price >= 0) -- 
);

------ Compras a proveedores ------
CREATE TABLE purchases (
    purchase_id     BIGSERIAL PRIMARY KEY,
    ingredient_id   BIGINT NOT NULL REFERENCES ingredients(ingredient_id) ON DELETE RESTRICT,
    branch_id       BIGINT NOT NULL REFERENCES branches(branch_id) ON DELETE RESTRICT,
    quantity        NUMERIC(12,3) NOT NULL CHECK (quantity >= 0),
    unit_cost_real  NUMERIC(10,2) NOT NULL CHECK (unit_cost_real >= 0),
    supplier_name   TEXT, 
    purchased_at    TIMESTAMP NOT NULL
);

------ Movimientos de inventario ------
CREATE TABLE inventory_movements (
    movement_id     BIGSERIAL PRIMARY KEY,
    ingredient_id   BIGINT NOT NULL REFERENCES ingredients(ingredient_id) ON DELETE RESTRICT,
    movement_type   TEXT NOT NULL CHECK (movement_type IN ("sale","purchase","waste","adjustment")), --revisar nota 17
    quantity        NUMERIC(12,3) NOT NULL, --No ponemos CHECK (quantity >=0) porque puede ser negativo cuando sale inventario (venta, merma), o positivo cuando entra (compra).
    order_item_id   BIGINT REFERENCES order_items(order_item_id) ON DELETE RESTRICT, -- es nullable (no tiene not null) porque solo aplica para sale. 
    purchase_id     BIGINT REFERENCES purchases(purchase_id) ON DELETE RESTRICT, -- es nullable (no tiene not null) porque solo aplica para compras. 
    occurred_at     TIMESTAMP NOT NULL,
    notes           TEXT,
    CONSTRAINT chk_movement_origen CHECK (
        (movement_type = "sale"     AND order_item_id IS NOT NULL AND purchase_id IS NULL) OR
        (movement_type = "purchase" AND purchase_id IS NOT NULL AND order_item_id IS NULL) OR
        (movement_type IN ("waste", "adjustment") AND order_item_id IS NULL AND purchase_id IS NULL)
    )
);


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Nota 20: Los triggers son rutinas que se ejecutan automáticamente cuando ocurre un evento específico en la base de datos, como una inserción, actualización o eliminación de datos. */
/*Nota 21: La diferencia entre CREATE FUNCTION y CREATE OR REPLACE FUNCTION es que CREATE OR REPLACE FUNCTION permite redefinir una función existente sin tener que eliminarla primero, es decir, 
puede editarse con normalidad y simplemente correr de nuevo el código*/
/*Nota 22: La función (CREATE FUNCTION nombre_función()) define qué hacer; mientras que el trigger (CREATE TRIGGER trg_name) define cuándo dispararla.*/
/*Nota 23: RETURNS TRIGGER le dice a Postgres "esta función está pensada para ser usada como trigger", no como una función normal que se llamaría con SELECT*/
/*Nota 24: $$...$$ son delimitadores especiales para marcar dónde empieza y termina el cuerpo de la función, útiles porque el código adentro puede tener sus propios punto y coma sin confundir a
Postgres sobre dónde termina la función completa.*/
/*Nota 25: LANGUAGE plpgsql es el lenguaje de programación utilizado para escribir funciones y triggers en PostgreSQL.*/
/*Nota 26: NEW es una variable especial que se refiere al registro recién insertado en el caso de un trigger de tipo INSERT.*/
/*Nota 27: r. es un apodo corto de la tabla recipes, y se define en la linea "FROM recipes r" */
/*NOTA 28: El orden en que se escribe una consulta SQL no es el orden en que Postgres la procesa. Lee la consulta completa primero, antes de ejecutar (no la va corriendo línea por línea como un 
script de Python de arriba hacia abajo). Es decir: QL no es un lenguaje de instrucciones secuenciales, es más bien una descripción completa de qué resultado quieres, y le toca al motor de la 
base de datos decidir el orden más eficiente para construir ese resultado.*/
/*Nota 29: La convención de legibilidad en sql es SELECT, FROM, WHERE */
/*RETURN NEW es una instrucción que indica que el trigger debe continuar con el registro recién insertado */
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


------ Trigger: registrar venta ------
-- Cada vez que se inserta un order_item, genera automáticamente los movimientos de salida de inventario para cada insumo de su receta.

CREATE OR REPLACE FUNCTION register_sale() 
RETURNS TRIGGER AS $$
BEGIN
    -- Para cada insumo en la receta del producto vendido, inserta un movimiento de salida de inventario
    INSERT INTO inventory_movements (ingredients_id, movement_type, quantity, order_item_id, occurred_at)
    SELECT
        r.ingredients_id,
        "sale",
        -1 * r.quantity_required * NEW.quantity, --quantity corresponde a la cantidad de productos vendidos en order_items, y quantity_required es la cantidad de insumo que se necesita para hacer un producto. 
        NEW.order_item_id, --se genera una nueva fila en inventory_movements para cada insumo de la receta del producto vendido, y se asocia con el order_item_id correspondiente.
        (SELECT created_at FROM orders WHERE order_id = NEW.order_id) --order_items no tiene su propia fecha/hora, a toma prestada de la tabla orders.
    FROM recipes r
    WHERE r.product_id = NEW.product_id; --busca todas las filas de la receta que tengan el mismo product_id que el producto vendido en order_items

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_register_sale
AFTER INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION register_sale();


------ Trigger: registrar compra ------
-- Cada vez que se inserta una compra, genera automáticamente un movimiento de entrada de inventario para el insumo comprado.
CREATE OR REPLACE FUNCTION registrar_compra()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO inventory_movements (ingredient_id, movement_type, quantity, purchase_id, occurred_at)
    VALUES (NEW.ingredient_id, 'purchase', NEW.quantity, NEW.purchase_id, NEW.purchased_at);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_registrar_compra
AFTER INSERT ON purchases
FOR EACH ROW
EXECUTE FUNCTION registrar_compra();


-------------------------------------------------------------------------------------------------------------------------------
/*Nota 30: Los índices son útiles para mejorar el rendimiento de las consultas. (Analogía: es como el índice al final de un libro de texto, al buscar la palabra "merma", vas directo al índice, 
encuentras "merma... página 214", y saltas ahí. Sin índice, Postgres tiene que revisar cada fila de la tabla una por una para encontrar lo que buscas ["sequential scan"]; con índice, salta casi 
directo a las filas que coinciden). */
-------------------------------------------------------------------------------------------------------------------------------

------ Indices ------
CREATE INDEX idx_order_items_order_id   ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_orders_created_at      ON orders(created_at);
CREATE INDEX idx_orders_branch_id       ON orders(branch_id);
CREATE INDEX idx_movements_ingredient   ON inventory_movements(ingredient_id);
CREATE INDEX idx_movements_occurred_at  ON inventory_movements(occurred_at);
CREATE INDEX idx_movements_type         ON inventory_movements(movement_type);
