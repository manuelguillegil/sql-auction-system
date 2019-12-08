DROP PROCEDURE IF EXISTS undolastbid(integer);

CREATE OR REPLACE PROCEDURE undoLastBid(idToEliminate integer)
LANGUAGE plpgsql
AS $$
    BEGIN

    DELETE FROM Bid as b
    WHERE b.id = idToEliminate;
 
    COMMIT;
    
    END;
$$;

CALL undoLastBid(1);