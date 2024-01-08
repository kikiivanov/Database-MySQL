DROP DATABASE IF EXISTS privateAirport;
CREATE DATABASE privateAirport;
USE privateAirport;

CREATE TABLE departments(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
manager_id INT NOT NULL,
FOREIGN KEY (manager_id) REFERENCES employees(id)
);

CREATE TABLE employees(
id INT AUTO_INCREMENT PRIMARY KEY,
department_id INT NOT NULL,
name VARCHAR(255) NOT NULL,
hire_date DATE NOT NULL,
job VARCHAR(255) NOT NULL,
salary DECIMAL(10, 2) NOT NULL,
email VARCHAR(255) NOT NULL,
FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE planes(
id INT AUTO_INCREMENT PRIMARY KEY,
brand VARCHAR(255) NOT NULL,
`number` VARCHAR(255) NOT NULL,
manufacture_date DATE NOT NULL,
manufacturer VARCHAR(255) NOT NULL,
passengers_capacity INT NOT NULL
);

CREATE TABLE flights(
id INT AUTO_INCREMENT PRIMARY KEY,
plane_id INT NOT NULL,
pilot_id INT NOT NULL,
flight_attendant_id INT NOT NULL,
departure_date_time DATETIME NOT NULL,
arrival_date_time DATETIME NOT NULL,
start_destination VARCHAR(255) NOT NULL,
end_destination VARCHAR(255) NOT NULL,
FOREIGN KEY (plane_id) REFERENCES planes(id),
FOREIGN KEY (pilot_id) REFERENCES employees(id),
FOREIGN KEY (flight_attendant_id) REFERENCES employees(id)
);

-- примерни данни за таблиците
INSERT INTO departments (name) VALUES ('Administration');
INSERT INTO departments (name) VALUES ('General Staff');
INSERT INTO departments (name) VALUES ('Stewardesses');
INSERT INTO departments (name) VALUES ('Pilots');

INSERT INTO employees (name, department_id) VALUES ('John Smith', 1);
INSERT INTO employees (name, department_id) VALUES ('Jane Doe', 2);
INSERT INTO employees (name, department_id) VALUES ('Mary Johnson', 3);
INSERT INTO employees (name, department_id) VALUES ('Tom Davis', 4);

INSERT INTO planes (brand, number, manufacture_date, manufacturer, passengers_capacity) 
VALUES ('Boeing', 'B747', '2020-01-01', 'Boeing Corporation', 450);

INSERT INTO flights (plane_id, pilot_id, stewardess_id, departure_date_time, arrival_date_time, start_destination, end_destination) 
VALUES (1, 1, 3, '2023-04-01 12:00:00', '2023-04-01 15:00:00', 'Sofia', 'London');

CREATE TABLE reservations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  passenger_name VARCHAR(255) NOT NULL,
  reservation_date DATETIME NOT NULL,
  flight_number VARCHAR(10) NOT NULL,
  ticket_category ENUM('First', 'Business', 'Economy') NOT NULL,
  ticket_price DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (reservation_id),
  FOREIGN KEY (flight_number) REFERENCES flights (flight_number)
);

CREATE TABLE department_assignments (
  department_id INT NOT NULL,
  employee_id INT NOT NULL,
  is_manager BOOLEAN NOT NULL,
  PRIMARY KEY (department_id, employee_id),
  FOREIGN KEY (department_id) REFERENCES departments (department_id),
  FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
);

SELECT * FROM flights WHERE arrival_date_time < NOW();
SELECT * FROM flights WHERE departure_date_time > NOW();