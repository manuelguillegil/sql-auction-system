-- Información sacada de: https://e-mc2.net/es/disparadores-triggers-en-postgresql
CREATE OR REPLACE FUNCTION updateFinishDate() RETURNS TRIGGER AS $updateFinishDate$
  DECLARE 
    temprow RECORD;
    nuevaFecha Timestamp;
    fechaLimite Timestamp;
    fechaBid Timestamp;
  BEGIN

    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE' ) THEN

        FOR temprow IN
            -- Querie que selecciona las categorias que son padre de la nueva categoria insertada
            SELECT DISTINCT s.id, s.usuario, s.fecha_ini, s.fecha_fin, s.precio_base, s.precio_reserva, s.precio_actual, s.producto, s.monto_minimo, s.fecha_limite 
            FROM Subasta AS s
            WHERE s.id = NEW.subasta
            
            LOOP
                -- fechaLimite := EXTRACT(HOUR FROM temprow.fecha_limite);
                -- fechaBid := EXTRACT(HOUR FROM NEW.fecha);
                /* IF (fechaLimite < fechaBid) THEN
                    nuevaFecha := '2015-12-31'::timestamp + 
                    EXTRACT(HOUR FROM NEW.fecha) * INTERVAL '1 HOUR' +
                    EXTRACT(MINUTE FROM s.fecha_limite) * INTERVAL '1 MINUTE' +
                    EXTRACT(SECOND FROM s.fecha_limite) * INTERVAL '1 SECOND';
                    RETURN NEW;
                END IF; */

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