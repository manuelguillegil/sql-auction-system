-- Información sacada de: https://e-mc2.net/es/disparadores-triggers-en-postgresql
CREATE OR REPLACE FUNCTION addBid() RETURNS TRIGGER AS $addBid$
  DECLARE 
    subasta RECORD;
    porcentaje INT;
  BEGIN
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
      FOR subasta IN
        -- Consulta que busca la
        SELECT DISTINCT * 
        FROM Subasta AS s
        WHERE s.id = NEW.subasta
          LOOP
            IF (NEW.monto <= subasta.monto_minimo) THEN
              RAISE NOTICE 'El monto del Bid que se quiere agregar es menor al requerido por la subasta por lo tanto es un bid no exitoso';
              RETURN NULL;
            END IF;
            
            IF (NEW.monto > subasta.monto_minimo) THEN
              porcentaje := (subasta.monto_minimo) * 100 / subasta.precio_base;
              subasta.precio_actual := subasta.precio_actual + (subasta.precio_actual / porcentaje);

              RAISE NOTICE 'Porcentaje: %', porcentaje;

              UPDATE Subasta
              SET precio_actual = subasta.precio_actual
              WHERE id = subasta.id;

              RETURN NEW;
            END IF;
          END LOOP;
    END IF;
  RETURN NULL;
  END;
$addBid$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS addBid 
ON Bid CASCADE;

CREATE TRIGGER addBid AFTER INSERT OR UPDATE
  ON Bid FOR EACH ROW
  EXECUTE PROCEDURE addBid();