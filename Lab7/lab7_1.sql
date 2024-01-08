USE school_sport_clubs;

DELIMITER $
DROP PROCEDURE IF EXISTS testProc $
CREATE PROCEDURE testProc()
BEGIN
	SELECT sports.name, sportGroups.location
	FROM sports JOIN sportGroups
	ON sports.id = sportGroups.sport_id;
END $
DELIMITER ;

CALL testProc();