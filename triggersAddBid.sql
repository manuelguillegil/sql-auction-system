-- Información sacada de: https://e-mc2.net/es/disparadores-triggers-en-postgresql
CREATE OR REPLACE FUNCTION addBid() RETURNS TRIGGER AS $addBid$
  DECLARE 
    temprow RECORD;
    porcentaje INT;
  BEGIN
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
      FOR temprow IN
        -- Consulta que busca la
        SELECT DISTINCT * 
        FROM Subasta AS s
        WHERE s.id = NEW.subasta
          LOOP
            IF (NEW.monto <= temprow.monto_minimo) THEN
              RAISE NOTICE 'El monto del Bid que se quiere agregar es menor al requerido por la subasta por lo tanto es un bid no exitoso';
              RETURN NULL;
            END IF;
            
            IF (NEW.monto > temprow.monto_minimo) THEN
              porcentaje := (temprow.monto_minimo) * 100 / temprow.precio_base;
              temprow.precio_actual := temprow.precio_actual + (temprow.precio_actual / porcentaje);

 --             RAISE NOTICE 'Porcentaje: %', porcentaje;

              UPDATE Subasta
              SET precio_actual = subasta.precio_actual
              WHERE id = temprow.id;

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