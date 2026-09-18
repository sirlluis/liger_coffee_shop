-- Aquí va la estructura de las tablas antes de subirla a Neon, por ejemplo
CREATE SCHEMA IF NOT EXISTS "public"

-- tabla de ejemplo
CREATE TABLE "public.ingredients" (
    "ingredient_id" int NOT NULL,
    "name" text NOT NULL
    PRIMARY KEY ("ingredient_id")
);
