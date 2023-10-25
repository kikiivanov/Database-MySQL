DROP DATABASE IF EXISTS school_sport_clubs;
CREATE DATABASE school_sport_clubs;
USE school_sport_clubs;

CREATE TABLE school_sport_clubs.sports(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255) NOT NULL
);

CREATE TABLE school_sport_clubs.coaches(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	egn VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE school_sport_clubs.students(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	egn VARCHAR(10) NOT NULL UNIQUE,
	address VARCHAR(255) NOT NULL,
	phone VARCHAR(20) NULL DEFAULT NULL,
	class VARCHAR(10) NULL DEFAULT NULL   
);

CREATE TABLE school_sport_clubs.sportGroups(
	id INT AUTO_INCREMENT PRIMARY KEY,
	location VARCHAR(255) NOT NULL,
	dayOfWeek ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
	hourOfTraining TIME NOT NULL,
	sport_id INT NULL,
	coach_id INT NULL,
	UNIQUE KEY(location,dayOfWeek,hourOfTraining) ,
	CONSTRAINT FOREIGN KEY(sport_id) 
		REFERENCES sports(id),
	CONSTRAINT FOREIGN KEY (coach_id) 
		REFERENCES coaches(id)
);

CREATE TABLE school_sport_clubs.student_sport(
	student_id INT NOT NULL, 
	sportGroup_id INT NOT NULL,  
	CONSTRAINT FOREIGN KEY (student_id) 
		REFERENCES students(id),	
	CONSTRAINT FOREIGN KEY (sportGroup_id) 
		REFERENCES sportGroups(id),
	PRIMARY KEY(student_id,sportGroup_id)
);

INSERT INTO sports
VALUES 	(NULL, 'Football') ,
		(NULL, 'Volleyball') ,
		(NULL, 'Tennis');
		
INSERT INTO coaches  
VALUES 	(NULL, 'Ivan Todorov Petkov', '7509041245') ,
		(NULL, 'Georgi Ivanov Todorov', '8010091245') ,
		(NULL, 'Ilian Todorov Georgiev', '8407106352') ,
		(NULL, 'Petar Slavkov Yordanov', '7010102045') ,
		(NULL, 'Todor Ivanov Ivanov', '8302160980') , 
		(NULL, 'Slavi Petkov Petkov', '7106041278');
        
INSERT INTO students (name, egn, address, phone, class) 
VALUES 	('Iliyan Ivanov', '9401150045', 'Sofia-Mladost 1', '0893452120', '10') ,
		('Ivan Iliev Georgiev', '9510104512', 'Sofia-Liylin', '0894123456', '11') ,
		('Elena Petrova Petrova', '9505052154', 'Sofia-Mladost 3', '0897852412', '11') ,
		('Ivan Iliev Iliev', '9510104542', 'Sofia-Mladost 3', '0894123457', '11') ,
		('Maria Hristova Dimova', '9510104547', 'Sofia-Mladost 4', '0894123442', '11') ,
		('Antoaneta Ivanova Georgieva', '9411104547', 'Sofia-Krasno selo', '0874526235', '10');
		
INSERT INTO sportGroups
VALUES 	(NULL, 'Sofia-Mladost 1', 'Monday', '08:00:00', 1, 1 ) ,
		(NULL, 'Sofia-Mladost 1', 'Monday', '09:30:00', 2, 1 ) ,
		(NULL, 'Sofia-Liylin 7', 'Sunday', '09:00:00', 2, 2) ,
        (NULL, 'Sofia-Liylin 3', 'Tuesday', '09:00:00', 2, 2) ,
		(NULL, 'Sofia-Liylin 3', 'Friday', '09:00:00', NULL, NULL) ,
		(NULL, 'Sofia-Nadezhda', 'Sunday', '08:00:00', 1, NULL);
		
INSERT INTO student_sport 
VALUES 	(1, 1),
		(2, 1),
		(3, 1),
		(4, 2),
		(5, 2),
		(6, 2);
     
     
#1
INSERT INTO students
VALUES (NULL, 'Ivan Ivanov Ivanov', '9207186371', 'Sofia-Serdika', '0888892950', '10');

#2
SELECT * FROM students
ORDER BY name;

#3
DELETE FROM students
WHERE egn = '9207186371';

#4
#1st way
SELECT students.name, sports.name AS sport
FROM students JOIN sports 
ON students.id IN (
	SELECT student_id
    FROM student_sport
    WHERE sportGroup_id IN (
		SELECT id
		FROM sportGroups
        WHERE sport_id = sports.id
	)
);

#2nd way
SELECT students.name, sports.name AS sport
FROM students JOIN student_sport
ON students.id = student_id
JOIN sportGroups
ON sportGroup_id = sportGroups.id
JOIN sports
ON sport_id = sports.id;

#5 
#1st way
SELECT students.name, students.class, sportGroups.id
FROM students JOIN sportGroups
ON students.id IN (
	SELECT student_id
    FROM student_sport
    WHERE sportGroup_id = sportGroups.id
    AND sportGroups.dayOfWeek = 'Monday'
);

#2nd way
SELECT students.name, students.class, sportGroups.id
FROM students JOIN student_sport
ON students.id = student_id
JOIN sportGroups
ON sportGroup_id = sportGroups.id
AND sportGroups.dayOfWeek = 'Monday';

#6
#1st way
SELECT coaches.name
FROM coaches JOIN sports
ON coaches.id IN (
	SELECT coach_id
    FROM sportGroups
    WHERE sport_id = sports.id
    AND sports.name = 'Football'
);

#2nd way
SELECT coaches.name
FROM coaches JOIN sportGroups
ON coaches.id = coach_id
JOIN sports
ON sport_id = sports.id
AND sports.name = 'Football';

#7
SELECT sportGroups.location, sportGroups.hourOfTraining, sportGroups.dayOfWeek
FROM sportGroups JOIN sports
ON sport_id = sports.id
AND sports.name = 'Volleyball';

#8
SELECT sports.name
FROM sports JOIN students
ON sports.id IN (
	SELECT sport_id
    FROM sportGroups
    WHERE sportGroups.id IN (
		SELECT sportGroup_id
        FROM student_sport
        WHERE student_id = students.id
        AND students.name = 'Iliyan Ivanov'
	)
);

#10
SELECT students.name
FROM students JOIN student_sport
ON students.id = student_id
JOIN sportGroups
ON sportGroup_id = sportGroups.id
JOIN coaches
ON coach_id = coaches.id
AND coaches.name = 'Ivan Todorov Petkov'
JOIN sports
ON sport_id = sports.id
AND sports.name = 'Football';

#Checking assingments

SELECT * FROM students;

SELECT * FROM sports;

SELECT * FROM sportGroups;

SELECT * FROM student_sport;

SELECT * FROM coaches;