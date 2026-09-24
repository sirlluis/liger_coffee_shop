\copy public.branches(branch_id, name) FROM 'c:/Users/Mi PC/Desktop/liger_coffee_shop/data/raw/branches.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy public.ingredients(ingredient_id, name, unit_of_measure, unit_cost, category) FROM 'c:/Users/Mi PC/Desktop/liger_coffee_shop/data/raw/ingredients.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy public.products(product_id, name, category, unit_price) FROM 'c:/Users/Mi PC/Desktop/liger_coffee_shop/data/raw/products.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy public.recipes(recipe_id, product_id, ingredient_id, quantity_required) FROM 'c:/Users/Mi PC/Desktop/liger_coffee_shop/data/raw/recipes.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy public.orders(order_id, branch_id, created_at, in_or_out, payment_method) FROM 'c:/Users/Mi PC/Desktop/liger_coffee_shop/data/raw/orders.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy public.order_items(order_item_id, order_id, product_id, quantity, sale_price) FROM 'c:/Users/Mi PC/Desktop/liger_coffee_shop/data/raw/order_items.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy public.purchases(purchase_id, ingredient_id, branch_id, quantity, unit_cost_real, supplier_name, purchased_at) FROM 'c:/Users/Mi PC/Desktop/liger_coffee_shop/data/raw/purchases.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy public.inventory_movements(movement_id, ingredient_id, movement_type, quantity, order_item_id, purchase_id, occurred_at, notes) FROM 'c:/Users/Mi PC/Desktop/liger_coffee_shop/data/raw/inventory_movements.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');