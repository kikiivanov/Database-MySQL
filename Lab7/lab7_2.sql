DELIMITER $
DROP PROCEDURE IF EXISTS testProc $
CREATE PROCEDURE testProc(INOUT testParam VARCHAR(255))
BEGIN
	SELECT testParam;
	SET testParam = 'Ivan';
	SELECT testParam;
END $
DELIMITER ;

-- IN - предаване по стойност
-- OUT - предаване по референция

SET @name = 'Georgi';
CALL testProc(@name);
SELECT @name;