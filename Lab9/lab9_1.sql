USE school_sport_clubs;

SELECT * FROM salaryPayments;

#1
DROP TRIGGER IF EXISTS salaryPayment_delete;
DELIMITER |
CREATE TRIGGER salaryPayment_delete BEFORE DELETE ON salaryPayments
FOR EACH ROW
BEGIN
	INSERT INTO salaryPayments_log(operation, old_coach_id, old_month, old_year, old_salaryAmount, old_dateOfPayment, dateOfLog)
	VALUES ('DELETE', OLD.coach_id, OLD.month, OLD.year, OLD.salaryAmount, OLD.dateOfPayment, NOW());
END;
|
DELIMITER ;

UPDATE salaryPayments SET salaryAmount = '2000' WHERE id = 13;
DELETE FROM salaryPayments WHERE id = 6;

SELECT * FROM salaryPayments_log;


#2 
DELETE FROM salarypayments;
 
INSERT INTO salarypayments(coach_id, month, year, salaryAmount, dateOfPayment)
SELECT old_coach_id, old_month, old_year, old_salaryAmount, old_dateOfPayment
FROM salarypayments_log
WHERE operation = "DELETE";
  
SELECT * FROM salarypayments;
 
 
#3 
DROP TRIGGER IF EXISTS before_student_sport_insert;
DELIMITER &
CREATE TRIGGER before_student_sport_insert BEFORE INSERT ON student_sport
FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) 
		FROM student_sport 
		WHERE student_id = NEW.student_id) >=2 
	THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'A student cannot be added in more than 2 groups.';
	END IF;
END;
&
DELIMITER ; 
 
 
#4
CREATE VIEW student_info AS
SELECT students.name, COUNT(sportgroup_id) AS number_of_groups
FROM students 
JOIN student_sport 
ON student_sport.student_id = students.id
GROUP BY student_sport.student_id;

SELECT * FROM student_info;


#5
DELIMITER |
CREATE PROCEDURE sport_info(IN given_sport VARCHAR(50))
BEGIN
	SELECT sports.name, coaches.name, sportgroups.location, sportgroups.hourOfTraining, sportgroups.dayOfWeek
	FROM sports
	JOIN sportgroups ON sportgroups.sport_id = sports.id
	JOIN coaches ON sportgroups.coach_id = coaches.id
	WHERE sports.name = given_sport;
END;
|
DELIMITER ;

CALL sport_info("Football");

DROP PROCEDURE IF EXISTS sport_info;