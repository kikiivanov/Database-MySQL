DROP DATABASE IF EXISTS sportClubs;
CREATE DATABASE sportClubs;
USE sportClubs;

CREATE TABLE clubs (
id INT AUTO_INCREMENT PRIMARY KEY, 
sportName VARCHAR(25) NOT NULL
);

CREATE TABLE students (
id INT AUTO_INCREMENT PRIMARY KEY, 
fNum CHAR(10) NOT NULL UNIQUE,
studentName VARCHAR(255) NOT NULL, 
phone VARCHAR(35) NULL
);

CREATE TABLE coaches (
id INT AUTO_INCREMENT PRIMARY KEY, 
egn CHAR(10) NOT NULL UNIQUE,
coachName VARCHAR(255) NOT NULL
);

create table `groups` (
id INT AUTO_INCREMENT PRIMARY KEY,
dayOfWeek ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
hourOfDay TIME NOT NULL, 
location VARCHAR(255) NOT NULL,
club_id INT NOT NULL, 
coach_id INT NOT NULL,
CONSTRAINT FOREIGN KEY(club_id) REFERENCES clubs(id),
CONSTRAINT FOREIGN KEY(coach_id) REFERENCES coaches(id),
UNIQUE KEY(dayOfWeek, hourOfDay, location)
);

create table student_group (
student_id INT NOT NULL, 
group_id INT NOT NULL,
CONSTRAINT FOREIGN KEY(student_id) REFERENCES students(id),
CONSTRAINT FOREIGN KEY(group_id) REFERENCES classes(id),
PRIMARY KEY(student_id, group_id)
);