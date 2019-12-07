-- Información sacada de: https://e-mc2.net/es/disparadores-triggers-en-postgresql
CREATE OR REPLACE FUNCTION checkHojaNuevaCategoria() RETURNS TRIGGER AS $checkHojaNuevaCategoria$
  DECLARE temprow RECORD;
  BEGIN

    IF (TG_OP = 'INSERT') THEN

      IF (NEW.padre IS NOT NULL) THEN
          FOR temprow IN
            -- Querie que selecciona las categorias que son padre de la nueva categoria insertada
            SELECT DISTINCT c.id, c.padre, c.es_hoja, c.tipo 
            FROM Categoria AS c
            WHERE c.id = NEW.padre
            
            LOOP
                NEW.es_hoja := 1;
            END LOOP;

          RETURN NEW;
      
      END IF;
    
    END IF;

   RETURN NEW;
  END;
$checkHojaNuevaCategoria$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS checkHojaNuevaCategoria 
ON Categoria CASCADE;

CREATE TRIGGER checkHojaNuevaCategoria BEFORE INSERT
    ON Categoria FOR EACH ROW
    EXECUTE PROCEDURE checkHojaNuevaCategoria();