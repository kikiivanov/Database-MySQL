USE school_sport_clubs;

DROP PROCEDURE IF EXISTS getAllPaymentsAmountOptimized;
DELIMITER |
CREATE PROCEDURE getAllPaymentsAmountOptimized(IN firstMonth INT, IN secMonth INT, IN paymentYear INT, IN studId INT)
BEGIN
    DECLARE iterator INT;
    CREATE TEMPORARY TABLE tempTbl (
		student_id INT, 
		group_id INT,
		paymentAmount DOUBLE,
		month INT
    ) ENGINE = Memory;
    
	IF (firstMonth >= secMonth)
    THEN 
		SELECT 'Please enter correct months!' AS RESULT;
	ELSE IF ((
			SELECT COUNT(*)
			FROM taxesPayments
			WHERE student_id = studId ) = 0)
	THEN 
		SELECT 'Please enter correct student_id!' AS RESULT;
	ELSE
	    SET iterator = firstMonth;
		WHILE (iterator >= firstMonth AND iterator <= secMonth)
		DO
			INSERT INTO tempTbl
			SELECT student_id, group_id, paymentAmount, month
			FROM taxespayments
			WHERE student_id = studId
			AND year = paymentYear
			AND month = iterator;
    
		    SET iterator = iterator + 1;
		END WHILE;
	END IF;
    END IF;
    
	SELECT *
	FROM tempTbl;
	DROP TABLE tempTbl;
END;
|
DELIMITER ;