-- Cuantas subastas se realizan por mes po categoria
SELECT date_trunc('month', b.fecha) AS mes, COUNT(ca.categoria), c.tipo
    FROM bid AS b
    JOIN subasta AS s ON b.subasta = s.id 
    JOIN categoria_producto AS ca ON ca.producto = s.producto 
    JOIN categoria AS c ON ca.categoria = c.id WHERE b.fecha <= '2019-12-31'
    GROUP BY 1, c.tipo;


