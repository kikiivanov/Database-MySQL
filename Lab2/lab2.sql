DROP DATABASE IF EXISTS newsSite;
CREATE DATABASE newsSite;
USE newsSite;

CREATE TABLE categories (
id INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(255) NOT NULL
);

CREATE TABLE users (
id INT AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(255) NOT NULL,
`password` VARCHAR(20) NOT NULL,
`role` ENUM ('Admin', 'Reader', 'Author')
);

CREATE TABLE articles (
id INT AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(255) NOT NULL unique,
`text` VARCHAR(3000) NOT NULL,
link VARCHAR(255) NOT NULL unique,
author_id INT NOT NULL,
category_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (author_id) REFERENCES users(id),
CONSTRAINT FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE multimedia (
id INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50) NOT NULL,
`source` VARCHAR(150) NOT NULL,
`type` ENUM('IMAGE', 'VIDEO')
);

CREATE TABLE article_multimedia (
article_id INT NOT NULL,
multimedia_id INT NOT NULL,
PRIMARY KEY(article_id, multimedia_id),
CONSTRAINT FOREIGN KEY (article_id) REFERENCES articles(id),
CONSTRAINT FOREIGN KEY (multimedia_id) REFERENCES multimedia(id)
);

CREATE TABLE comments (
id INT AUTO_INCREMENT PRIMARY KEY,
`text` TEXT NOT NULL,
`date` DATETIME NOT NULL,
user_id INT NOT NULL,
article_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (user_id) REFERENCES users(id),
CONSTRAINT FOREIGN KEY (article_id) REFERENCES articles(id)
);