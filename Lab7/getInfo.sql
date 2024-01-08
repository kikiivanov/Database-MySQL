USE school_sport_clubs;

#1
DROP PROCEDURE IF EXISTS getCoachInfo;
DELIMITER &
CREATE PROCEDURE getCoachInfo(IN coachName VARCHAR(255))
BEGIN
	SELECT sports.name, sportGroups.location, sportGroups.hourOfTraining, sportGroups.dayOfWeek, students.name, students.phone
	FROM sportGroups
	JOIN coaches ON sportGroups.coach_id = coaches.id
	JOIN sports ON sportGroups.sport_id = sports.id
	JOIN student_sport ON sportGroups.id = student_sport.sportGroup_id
	JOIN students ON student_sport.student_id = students.id
	WHERE coaches.name = coachName;
END;
&
DELIMITER ;

CALL getInfo('Ivan Todorov Petkov');


#2
DROP PROCEDURE IF EXISTS getSportInfo;
DELIMITER |
CREATE procedure getSportInfo(IN sportId INT)
BEGIN
	SELECT sports.name, students.name, coaches.name
	FROM students
	JOIN student_sport ON students.id = student_sport.student_id
	JOIN sportgroups ON student_sport.sportgroup_id = sportgroups.id
	JOIN sports ON sportgroups.sport_id = sports.id
	JOIN coaches ON sportgroups.coach_id = coaches.id
	WHERE sportId = sports.id;
END;
|
DELIMITER ;
CALL getSportInfo(1);


#3
DROP PROCEDURE IF EXISTS getTaxesInfo;
DELIMITER ^
CREATE PROCEDURE getTaxesInfo(IN studentName VARCHAR(255), inYear YEAR)
BEGIN
	SELECT studentName, AVG(taxesPayments.paymentAmount) AS AverageTaxes
	FROM students
	JOIN taxespayments ON students.id = taxespayments.student_id
	WHERE studentName = students.name
	AND inYear = taxespayments.year
	GROUP BY studentName, inYear;
END;
^
DELIMITER ; 
CALL getTaxesInfo('Iliyan Ivanov', 2022);


#4
DELIMITER |
DROP PROCEDURE IF EXISTS getGroups |
CREATE PROCEDURE getGroups(IN coachName VARCHAR(255))
BEGIN
	DECLARE counter INT;
	SELECT COUNT(sportgroups.coach_id) INTO counter
	FROM coaches
	JOIN sportgroups ON sportgroups.coach_id = coaches.id
	WHERE coaches.name = coachName;

	IF (counter = 0 OR counter = NULL) 
    THEN
		SELECT 'No groups for the trainer!' AS RESULT;
	ELSE
		SELECT counter;
	END IF;
END;
|
DELIMITER ; 
CALL getGroups('Ivan Todorov Petkov');