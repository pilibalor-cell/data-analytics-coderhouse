-- Pre-entrega 4: Consultas SQL de negocio
-- DE: Pilar Balor

-- === CONSULTA 1: Resumen ejecutivo mensual ===
--SELECT MONTH (fecha_venta) AS mes FROM ventas
--GROUP BY month (fecha_venta);

SELECT MONTH (fecha_venta) AS mes,
       SUM (cantidad * precio_unitario) AS total_facturado,
       COUNT (*) AS cantidad_pedidos,
       AVG (cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH (fecha_venta); 

-- === CONSULTA 2: Ranking de productos ===

SELECT TOP 5 id_producto,
       SUM (cantidad) AS unidades_vendidas,
       SUM (cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- === CONSULTA 3: Clientes recurrentes ===
SELECT id_cliente,
       COUNT (*) AS cantidad_pedidos,
       SUM (cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

-- === CONSULTA 4: Productos por encima o por debajo del promedio ===
WITH totales_producto AS (
     SELECT id_producto,
            SUM (cantidad * precio_unitario) AS total_facturado
     FROM ventas
     GROUP BY id_producto
     )
     -- Paso 2: el promedio de los totales por producto (da 1074)
     --SELECT AVG (total_facturado) AS promedio
     --FROM totales_producto;

-- Paso 3: primero lo probé con 1074 escrito a mano; ahora el promedio se calcula solo
SELECT id_producto,
       total_facturado,
       CASE WHEN total_facturado > (SELECT AVG(total_facturado) FROM totales_producto) THEN 'Por encima' ELSE 'Por debajo' END AS comparacion
       FROM totales_producto;

       -- === HALLAZGOS ===
-- 1. El producto 1 concentra el 56% de la facturación de marzo.
-- 2. El 100$ de los clientes son recurrentes 
-- 3. El producto 2 vendió más unidades que todos, pero sólo facturó $364, un 6%


