drop database if exists sportClubs;
create database sportClubs;
use sportClubs;

create table clubs(id int auto_increment primary key, sportName varchar(25) not null);

create table students(id int auto_increment primary key, fNum char(10) not null unique,
studentName varchar(255) not null, phone varchar(35) null);

create table coaches(id int auto_increment primary key, egn char(10) not null unique,
coachName varchar(255) not null);

create table classes(id int auto_increment primary key,
dayOfWeek enum('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
hourOfDay time not null, location varchar(255) not null,
club_id int not null, coach_id int not null,
constraint foreign key(club_id) references clubs(id),
constraint foreign key(coach_id) references coaches(id),
unique key(dayOfWeek, hourOfDay, location)
);

create table student_group(student_id int not null, group_id int not null,
constraint foreign key(student_id) references students(id),
constraint foreign key(group_id) references classes(id),
primary key(student_id, group_id)
);