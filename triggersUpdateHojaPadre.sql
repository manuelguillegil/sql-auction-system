-- Información sacada de: https://e-mc2.net/es/disparadores-triggers-en-postgresql


CREATE OR REPLACE FUNCTION actualizarPadreCategoria() RETURNS TRIGGER AS $actualizarPadreCategoria$
  DECLARE temprow RECORD;
  BEGIN

    IF (TG_OP = 'INSERT') THEN
         FOR temprow IN
            -- Querie que selecciona las categorias que son padre de la nueva categoria insertada
            SELECT DISTINCT c.id, c.padre, c.es_hoja, c.tipo 
            FROM Categoria AS c
            WHERE c.id = NEW.padre
            
            LOOP
                UPDATE Categoria
                    SET es_hoja = False
                    WHERE id = temprow.id;
            END LOOP;
        NEW.es_hoja = 1;
        RETURN NEW;
    END IF;
    -- Si se elimina una categoria, se tiene que convertirse en Hoja todas las demás categorias que sean papas
    IF (TG_OP = 'DELETE') THEN
        FOR temprow IN
            -- Querie que selecciona las categorias que son padre de la nueva categoria insertada
            SELECT DISTINCT c.id, c.padre, c.es_hoja, c.tipo 
            FROM Categoria AS c
            WHERE c.id = OLD.padre
            
            LOOP
                -- Para las filas que son padre de la nueva categoria, cambiamos el atribuo de es_hoja de True a False
                UPDATE Categoria
                    SET es_hoja = True
                    WHERE id = temprow.id;
            END LOOP;

        RETURN NULL;
    END IF;

   RETURN NEW;
  END;
$actualizarPadreCategoria$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS actualizarPadreCategoria 
ON Categoria CASCADE;

CREATE TRIGGER actualizarPadreCategoria AFTER INSERT OR UPDATE OR DELETE
    ON Categoria FOR EACH ROW
    EXECUTE PROCEDURE actualizarPadreCategoria();


/* CREATE TRIGGER nombre { BEFORE | AFTER } { INSERT | UPDATE | DELETE [ OR ... ] }
    ON tabla [ FOR [ EACH ] { ROW | STATEMENT } ]
    EXECUTE PROCEDURE nombre de funcion ( argumentos ) */