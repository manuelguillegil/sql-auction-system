-- PREGUNTA 4
-- Cuantas subastas se realizan por mes po categoria
SELECT date_trunc('month', b.fecha) AS mes, COUNT(ca.categoria), c.tipo
    FROM bid AS b
    JOIN subasta AS s ON b.subasta = s.id 
    JOIN categoria_producto AS ca ON ca.producto = s.producto 
    JOIN categoria AS c ON ca.categoria = c.id WHERE b.fecha <= '2019-12-31'
    GROUP BY 1, c.tipo;

-- Pregunta 3
-- Nuestra  solucion parte desde la vision de que con dos query
-- podemos resolver de igual manera el mismo problema de una forma
-- menos confusa utilizando los parametros dados en clase
 
-- Query number 1
-- Este query responde a la tarea de conseguir todas las categorias que tienen
-- un promedio de 'precio_actual' mayor al de la tabla general subasta y
-- tengan un valor 'precio_base' mayor a $ 1
 
SELECT *
FROM (
   select c.categoria as name , ca.tipo, avg(s.precio_actual) as average_category
   from categoria_producto as c
   join subasta as s on s.producto = c.producto
   join categoria as ca on ca.id= c.categoria where s.precio_base > 1 group by c.categoria,ca.tipo
) a,
( select avg(precio_actual) as total FROM subasta ) b
WHERE b.total < a.average_category;
 
-- Query number 2
-- Este query responde a la tarea de conseguir todas las categorias que tienen
-- un promedio de 'precio_actual' mayor al de la tabla general subasta y
-- tengan un valor 'precio_base' menor a $ 1
 
SELECT *
FROM (
   select c.categoria as name , ca.tipo, avg(s.precio_actual) as average_category
   from categoria_producto as c
   join subasta as s on s.producto = c.producto
   join categoria as ca on ca.id= c.categoria where s.precio_base < 1 group by c.categoria,ca.tipo
) a,
( select avg(precio_actual) as total FROM subasta ) b
WHERE b.total < a.average_category;


