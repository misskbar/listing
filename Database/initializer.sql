CREATE DATABASE listing;

USE listing;
CREATE TABLE user (
  rut VARCHAR(10) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  user_img_url VARCHAR(255) NOT NULL,
  birthday DATE NOT NULL,
  mail VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  gender VARCHAR(1)
);

USE listing;
CREATE TABLE phone_number (
  id_phone_number INT AUTO_INCREMENT PRIMARY KEY,
  phone_number VARCHAR(25) NOT NULL,
  fk_rut VARCHAR(10) NOT NULL,
  FOREIGN KEY (fk_rut) REFERENCES user (rut)
);

USE listing;
CREATE TABLE category (
  id_category INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  parent INT,
  FOREIGN KEY (parent) REFERENCES category (id_category)
);


USE listing;
CREATE TABLE address (
  id_address INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  parent INT,
  fk_rut VARCHAR(10),
  FOREIGN KEY (fk_rut) REFERENCES user (rut),
  FOREIGN KEY (parent) REFERENCES address (id_address)
);

USE listing;
CREATE TABLE service (
  id_service INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description VARCHAR(255) NOT NULL,
  keywords VARCHAR(255),
  mail VARCHAR(255),
  service_front_img_url VARCHAR(255),
  rate DECIMAL(2,2) NOT NULL,
  price_from DECIMAL (10,2),
  price_to DECIMAL (10,2) NOT NULL,
  is_promoted BOOLEAN NOT NULL,
  publication_date DATE NOT NULL,
  website_url VARCHAR(255),
  facebook_url VARCHAR(255),
  instagram_url VARCHAR(255),
  twitter_url VARCHAR(255),
  fk_rut VARCHAR(10) NOT NULL,
  fk_category INT NOT NULL,
  fk_address INT,
  fk_phonenumber INT,
  FOREIGN KEY (fk_category) REFERENCES category (id_category),
  FOREIGN KEY (fk_rut) REFERENCES user (rut),
  FOREIGN KEY (fk_address) REFERENCES address (id_address),
  FOREIGN KEY (fk_phonenumber) REFERENCES phone_number (id_phone_number)
);


USE listing;
CREATE TABLE review (
  id_review INT AUTO_INCREMENT PRIMARY KEY,
  rate INT NOT NULL,
  comment VARCHAR(500),
  publication_date DATE NOT NULL,
  is_annonymous BOOLEAN NOT NULL,
  fk_rut VARCHAR(10),
  fk_service INT,
  FOREIGN KEY (fk_rut) REFERENCES user (rut),
  FOREIGN KEY (fk_service) REFERENCES service (id_service)
);

USE listing;
CREATE TABLE favorite (
  id_favorite INT AUTO_INCREMENT PRIMARY KEY,
  fk_rut VARCHAR(10) NOT NULL,
  fk_service INT NOT NULL,
  FOREIGN KEY (fk_rut) REFERENCES user (rut),
  FOREIGN KEY (fk_service) REFERENCES service (id_service)
);

USE listing;
CREATE TABLE galery (
  id_galery INT AUTO_INCREMENT PRIMARY KEY,
  img_url VARCHAR(255) NOT NULL,
  fk_service INT NOT NULL,
  FOREIGN KEY (fk_service) REFERENCES service (id_service)
);

USE listing;
CREATE TABLE timetable (
  id_timetable INT AUTO_INCREMENT PRIMARY KEY,
  weekday VARCHAR(20) NOT NULL,
  open_hour TIME NOT NULL,
  close_hour TIME NOT NULL,
  fk_service INT NOT NULL,
  FOREIGN KEY (fk_service) REFERENCES service (id_service)
);
