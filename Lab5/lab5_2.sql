#1
DROP DATABASE IF EXISTS cinema;
CREATE DATABASE cinema;
USE cinema;

CREATE TABLE cinemas (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
address VARCHAR(255) NOT NULL
);

CREATE TABLE halls (
id INT AUTO_INCREMENT PRIMARY KEY,
cinema_id INT NOT NULL,
name VARCHAR(255) NOT NULL,
capacity INT NOT NULL,
hall_status VARCHAR(50),
CONSTRAINT FOREIGN KEY (cinema_id) REFERENCES cinemas(id)
);

CREATE TABLE films (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
year INT NOT NULL,
country VARCHAR(255) NOT NULL
);

CREATE TABLE projections (
id INT AUTO_INCREMENT PRIMARY KEY,
hall_id INT NOT NULL,
film_id INT NOT NULL,
broadcasting_time DATETIME NOT NULL,
audience INT NOT NULL,
CONSTRAINT FOREIGN KEY (hall_id) REFERENCES halls(id),
CONSTRAINT FOREIGN KEY (film_id) REFERENCES films(id)
);

INSERT INTO cinemas
	VALUES (NULL, 'Arena Mladost', 'Okolovrasten Pat'),
		   (NULL, 'Sofia Arena Armeec', 'Carigradsko shose');
INSERT INTO halls (cinema_id, name, capacity, hall_status) 
	VALUES (1, 'Zala 1', 200, 'VIP'),
           (2, 'Zala 2', 300, 'Deluxe');
INSERT INTO films (name, year, country) 
	VALUES ('Final Destinaton 7', 1994, 'USA'),
           ('South Wind', 2020, 'SRB');
INSERT INTO projections (hall_id, film_id, broadcasting_time, audience) 
	VALUES (1, 1, '2023-03-22 18:30:00', 150),
		   (2, 2, '2023-03-21 20:00:00', 170);
#2
SELECT c.name AS cinema_name, h.hall_status, p.broadcasting_time
FROM cinemas AS c
INNER JOIN halls AS h ON c.id = h.cinema_id
INNER JOIN projections AS p ON h.id = p.hall_id
INNER JOIN films AS f ON p.film_id = f.id
WHERE (h.hall_status = 'VIP' OR h.hall_status = 'Deluxe') AND f.name = 'Final Destinaton 7'
ORDER BY c.name, h.cinema_id;

#3
SELECT sum(p.audience) AS total_audience
FROM cinemas AS c
INNER JOIN halls AS h ON c.id = h.cinema_id
INNER JOIN projections AS p ON h.id = p.hall_id
INNER JOIN films AS f ON p.film_id = f.id
WHERE h.hall_status = 'VIP' AND f.name = 'Final Destinaton 7' AND c.name = 'Arena Mladost';