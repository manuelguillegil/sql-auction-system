-- PREGUNTA 4
-- Cuantas subastas se realizan por mes por categoria
SELECT date_trunc('month', b.fecha_ini) AS mes, COUNT(ca.categoria), c.tipo
    FROM subasta AS b
    JOIN categoria_producto AS ca ON ca.producto = b.producto 
    JOIN categoria AS c ON ca.categoria = c.id WHERE b.fecha_ini <= '2019-12-31'
    GROUP BY 1, c.tipo;

-- Pregunta 3
-- Nuestra  solucion parte desde la vision de que con dos query
-- podemos resolver de igual manera el mismo problema de una forma
-- menos confusa utilizando los parametros dados en clase
 
-- Query number 1
-- Este query responde a la tarea de conseguir todas las categorias que tienen
-- un promedio de 'precio_actual' mayor al de la tabla general subasta y
-- tengan un valor 'precio_base' mayor a $ 1
-- Lo que sale como total al finalizar las tablas es el promedio de la tabla completa 
 
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



--- Stored Procedure 
--- Este Store Procedure tiene la funcion que cuando el administrador sospecha de un bid fraudalento 
--  entonces dado ese id, decide eliminarlo haciendo un llamado a undolastbid()
--- Con este Stored Procedure respondemos a la pregunta numero 2 del proyecto.
--- Se hace un llamado para eliminar el bid cuyo id es "1" para efectos de una prueba
--- ya que el procedimiento se activa cuando el administrador asi lo desea

DROP PROCEDURE IF EXISTS undolastbid(integer);

CREATE OR REPLACE PROCEDURE undoLastBid(idToEliminate integer)
LANGUAGE plpgsql
AS $$
    BEGIN

    DELETE FROM Bid as b
    WHERE b.id = idToEliminate;

    RAISE NOTICE 'Se elimino el bid cuyo id es: %', idToEliminate;
 
    COMMIT;
    
    END;
$$;

CALL undoLastBid(1);

-- Para responder la pregunta #1 sobre los controles de concurrencia, manejador, etc...
-- Dichas funcionalidades se encuentran en los triggers implementados despues de crear la base de datos,
-- lo que permite consistencia en el manejo de nuestro sistema de base de datos