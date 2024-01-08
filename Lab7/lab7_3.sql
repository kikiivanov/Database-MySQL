USE school_sport_clubs;

DROP PROCEDURE IF EXISTS getAllPaymentsAmount;
DELIMITER |
CREATE PROCEDURE getAllPaymentsAmount(IN firstMonth INT, IN secMonth INT, IN paymentYear INT, IN studId INT)
BEGIN
	DECLARE iterator INT;
	IF (firstMonth >= secMonth)
    THEN 
		SELECT 'Please enter correct months!' as RESULT;
	ELSE IF ((
			SELECT COUNT(*)
			FROM taxesPayments
			WHERE student_id = studId ) = 0)
	THEN 
		SELECT 'Please enter correct student_id!' as RESULT;
	ELSE
		SET ITERATOR = firstMonth;

		WHILE (iterator >= firstMonth AND iterator <= secMonth)
		DO
			SELECT student_id, group_id, paymentAmount, month
			FROM taxespayments
			WHERE student_id = studId
			AND year = paymentYear
			AND month = iterator;
    
			SET iterator = iterator + 1;
		END WHILE;
	END IF;
    
    END IF;
END;
|
DELIMITER ;

CALL getAllPaymentsAmount(1, 6, 2021, 1);