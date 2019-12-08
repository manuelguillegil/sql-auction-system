-- Información sacada de: https://e-mc2.net/es/disparadores-triggers-en-postgresql
CREATE OR REPLACE FUNCTION updateFinishDate() RETURNS TRIGGER AS $updateFinishDate$
  DECLARE 
    temprow RECORD;
    nuevaFecha Timestamp;
    fechaLimite Timestamp;
    fechaBid Timestamp;
    timeToEnd Timestamp;
  BEGIN
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE' ) THEN
      FOR temprow IN
        SELECT * 
        FROM Subasta AS s
        WHERE s.id = NEW.subasta
          LOOP
            timeToEnd = now()::timestamp - temprow.fecha_fin;

              IF (timeToEnd <= temprow.fecha_fin) THEN
                UPDATE Subasta
                SET fecha_fin = fecha_fin + fecha_limite
                WHERE Subasta.id = temprow.id;
              END IF;
          END LOOP;
    END IF;
    RETURN NEW;
  END;
$updateFinishDate$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS updateFinishDate 
ON Bid CASCADE;

CREATE TRIGGER updateFinishDate BEFORE INSERT OR UPDATE
  ON Bid FOR EACH ROW
  EXECUTE PROCEDURE updateFinishDate();