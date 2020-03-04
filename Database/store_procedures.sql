USE listing;

DELIMITER //
CREATE FUNCTION validate_rut(identifier VARCHAR(10))
RETURNS BOOLEAN
BEGIN
RETURN EXISTS(SELECT name FROM user WHERE rut = identifier);
END//

DELIMITER //
CREATE FUNCTION validate_mail(identifier VARCHAR(255))
RETURNS BOOLEAN
BEGIN
RETURN EXISTS(SELECT name FROM user WHERE mail = identifier);
END//

DELIMITER //
CREATE FUNCTION validate_password(identifier VARCHAR(255), password VARCHAR(255))
RETURNS BOOLEAN
BEGIN
RETURN EXISTS(SELECT U.name FROM user U WHERE U.password = password AND U.rut = identifier OR U.mail = identifier);
END//

DELIMITER //
CREATE PROCEDURE register(rut VARCHAR(10), name VARCHAR(255), last_name VARCHAR(255), user_img_url VARCHAR(255), birthday VARCHAR(255), mail VARCHAR(255), password VARCHAR(255), gender VARCHAR(1))
BEGIN
insert into user (rut, name, last_name, user_img_url, birthday, mail, nickname, password, gender) values (rut, name, last_name, user_img_url, STR_TO_DATE(birthday,'%d/%m/%Y'), mail, password, gender);
END//

DELIMITER //
CREATE PROCEDURE login(identifier VARCHAR(255), password VARCHAR(255))
BEGIN
SELECT U.rut, U.name, U.last_name, U.user_img_url, U.mail  FROM user U WHERE U.mail=identifier OR U.rut=identifier AND U.password=password;
END//

DELIMITER //
CREATE PROCEDURE update_password_with_old(identifier VARCHAR(255), old_password VARCHAR(255), new_password VARCHAR(255))
BEGIN
UPDATE user U SET U.password = new_password WHERE (U.rut = identifier OR U.mail = identifier) AND U.password= old_password; 
END//

DELIMITER //
CREATE PROCEDURE update_password(identifier VARCHAR(255), new_password VARCHAR(255))
BEGIN
UPDATE user U SET U.password = new_password WHERE U.rut = identifier OR U.mail = identifier; 
END//

DELIMITER //
CREATE PROCEDURE update_user(identifier VARCHAR(255), name VARCHAR(255), last_name VARCHAR(255), user_img_url VARCHAR(255), birthday VARCHAR(255), mail VARCHAR(255), gender VARCHAR(1))
BEGIN
UPDATE user U SET U.name=name, U.last_name=last_name, U.user_img_url=user_img_url, U.birthday=STR_TO_DATE(birthday,'%d/%m/%Y'), U.mail=mail, U.gender=gender WHERE U.rut = identifier OR U.mail = identifier; 
END//

DELIMITER //
CREATE PROCEDURE delete_account(identifier VARCHAR(255))
BEGIN
DELETE FROM user WHERE rut=identifier OR mail= identifier;
END//

DELIMITER //
CREATE PROCEDURE add_phone_number(rut VARCHAR(10), phonenumber VARCHAR(25))
BEGIN
insert into phone_number (phone_number, fk_rut) values (phonenumber, rut);
END//

DELIMITER //
CREATE PROCEDURE delete_phone_number(identifier VARCHAR(255))
BEGIN
DELETE FROM phone_number WHERE id_phone_number=identifier;
END//

DELIMITER //
CREATE PROCEDURE update_phone_number(identifier VARCHAR(255), new_phone_number VARCHAR(255))
BEGIN
UPDATE phone_number P SET P.phone_number = new_phone_number WHERE P.id_phone_number = identifier; 
END//

DELIMITER //
CREATE PROCEDURE get_phone_numbers_by_user(identifier VARCHAR(10))
BEGIN
SELECT P.phone_number FROM phone_number P WHERE P.fk_rut = identifier;
END//

DELIMITER //
CREATE PROCEDURE add_address(rut VARCHAR(10), address VARCHAR(255), parent INT)
BEGIN
insert into address (name, parent, fk_rut) values (address, parent, rut);
END//

DELIMITER //
CREATE PROCEDURE delete_address(identifier INT)
BEGIN
DELETE FROM address WHERE id_address=identifier;
END//

DELIMITER //
CREATE PROCEDURE update_address(identifier INT, new_name VARCHAR(255))
BEGIN
UPDATE address A SET A.name = new_name WHERE A.id_address = identifier; 
END//

DELIMITER //
CREATE PROCEDURE get_address_by_user(identifier VARCHAR(10))
BEGIN
SELECT A.name FROM address A WHERE A.fk_rut = identifier;
END//

DELIMITER //
CREATE PROCEDURE get_address_by_parent(parent INT)
BEGIN
SELECT A.name FROM address A WHERE A.parent = parent;
END//

DELIMITER //
CREATE PROCEDURE get_address(identifier INT)
BEGIN
SELECT A.name FROM address A WHERE A.id_address = identifier;
END//

DELIMITER //
CREATE PROCEDURE add_favorite(rut VARCHAR(10), service INT)
BEGIN
insert into favorite (fk_rut, fk_service) values (rut, service);
END//

DELIMITER //
CREATE PROCEDURE delete_favorite(identifier INT)
BEGIN
DELETE FROM favorite WHERE id_favorite=identifier;
END//

DELIMITER //
CREATE PROCEDURE delete_all_user_favorites(identifier VARCHAR(10))
BEGIN
DELETE FROM favorite WHERE fk_rut=identifier;
END//

DELIMITER //
CREATE PROCEDURE get_full_user_favorites(identifier VARCHAR(10), show_max INT)
BEGIN
SELECT  S.id_service, 
		S.title, 
		S.description,  
		S.mail, 
		S.service_front_img_url, 
		S.rate, 
		S.price_from, 
		S.price_to, 
		S.is_promoted, 
		S.publication_date, 
		S.website_url, 
		S.facebook_url, 
		S.instagram_url, 
		S.twitter_url,
		C.name,
		P.phone_number,
		A.id_address
FROM service S, category C, phone_number P, address A, favorite F
WHERE F.fk_service=S.id_service AND
		S.fk_category = C.id_category AND
		S.fk_phonenumber = P.id_phone_number AND
		S.fk_address = A.id_address
ORDER BY S.id_service ASC
LIMIT show_max;
END//

DELIMITER //
CREATE PROCEDURE get_full_user_favorites_pagination(identifier VARCHAR(10), show_max INT, last_service_id INT)
BEGIN
SELECT  S.id_service, 
		S.title, 
		S.description,  
		S.mail, 
		S.service_front_img_url, 
		S.rate, 
		S.price_from, 
		S.price_to, 
		S.is_promoted, 
		S.publication_date, 
		S.website_url, 
		S.facebook_url, 
		S.instagram_url, 
		S.twitter_url,
		C.name,
		P.phone_number,
		A.id_address
FROM service S, category C, phone_number P, address A, favorite F
WHERE F.fk_service=S.id_service AND
		S.fk_category = C.id_category AND
		S.fk_phonenumber = P.id_phone_number AND
		S.fk_address = A.id_address
ORDER BY S.id_service ASC
LIMIT last_service_id,show_max;
END//

DELIMITER //
CREATE PROCEDURE get_favorites(identifier VARCHAR(10))
BEGIN
SELECT fk_service FROM favorite WHERE fk_rut = identifier ORDER BY id_service ASC;
END//

DELIMITER //
CREATE PROCEDURE add_service(service_title VARCHAR(255),
  service_description VARCHAR(255),
  service_keywords VARCHAR(255),
  service_mail VARCHAR(255),
  service_front_img_url VARCHAR(255),
  service_price_from DECIMAL,
  service_price_to DECIMAL,
  service_website_url VARCHAR(255),
  service_facebook_url VARCHAR(255),
  service_instagram_url VARCHAR(255),
  service_twitter_url VARCHAR(255),
  service_fk_rut VARCHAR(10),
  service_fk_category INT,
  service_fk_address INT,
  service_fk_phonenumber INT)
BEGIN
insert into service (title, 
	description, 
	keywords, 
	mail, 
	service_front_img_url, 
	rate, 
	price_from, 
	price_to, 
	is_promoted, 
	publication_date, 
	website_url, 
	facebook_url, 
	instagram_url, 
	twitter_url, 
	fk_rut, 
	fk_category, 
	fk_address, 
	fk_phonenumber) 
values (service_title, 
	service_description, 
	service_keywords, 
	service_mail,
	service_front_img_url,
	0,
	service_price_from,
	service_price_to,
	false,
	CURDATE(),
	service_website_url,
	service_facebook_url,
	service_instagram_url,
	service_twitter_url,
	service_fk_rut,
	service_fk_category,
	service_fk_address,
	service_fk_phonenumber);
END//

DELIMITER //
CREATE PROCEDURE delete_all_user_services(identifier VARCHAR(10))
BEGIN
DELETE FROM service WHERE fk_rut=identifier;
END//

DELIMITER //
CREATE PROCEDURE delete_service(identifier INT)
BEGIN
DELETE FROM service WHERE id_service=identifier;
END//

DELIMITER //
CREATE PROCEDURE promote_service(identifier INT, promoted BOOLEAN)
BEGIN
UPDATE service SET is_promoted=promoted WHERE id_service=identifier;
END//

DELIMITER //
CREATE PROCEDURE update_service(identifier INT, 
  service_title VARCHAR(255),
  service_description VARCHAR(255),
  service_keywords VARCHAR(255),
  service_mail VARCHAR(255),
  front_img_url VARCHAR(255),
  service_price_from DECIMAL,
  service_price_to DECIMAL,
  service_website_url VARCHAR(255),
  service_facebook_url VARCHAR(255),
  service_instagram_url VARCHAR(255),
  service_twitter_url VARCHAR(255),
  service_fk_category INT,
  service_fk_address INT,
  service_fk_phonenumber INT)
BEGIN
UPDATE service
SET 
title=service_title,
description=service_description,
keywords=service_keywords,
mail=service_mail,
service_front_img_url=front_img_url,
price_from=service_price_from,
price_to=service_price_to,
website_url=service_website_url,
facebook_url=service_facebook_url,
instagram_url=service_instagram_url,
twitter_url=service_twitter_url,
fk_category=service_fk_category,
fk_address=service_fk_address,
fk_phonenumber=service_fk_phonenumber
WHERE id_service = identifier;
END//

DELIMITER //
CREATE PROCEDURE get_full_user_services(identifier VARCHAR(10), show_max INT)
BEGIN
SELECT  S.id_service, 
		S.title, 
		S.description,  
		S.mail, 
		S.service_front_img_url, 
		S.rate, 
		S.price_from, 
		S.price_to, 
		S.is_promoted, 
		S.publication_date, 
		S.website_url, 
		S.facebook_url, 
		S.instagram_url, 
		S.twitter_url,
		C.name,
		P.phone_number,
		A.id_address
FROM service S, category C, phone_number P, address A, user U
WHERE U.rut=S.fk_rut AND
		U.rut = identifier AND
		S.fk_category = C.id_category AND
		S.fk_phonenumber = P.id_phone_number AND
		S.fk_address = A.id_address
ORDER BY S.id_service ASC
LIMIT show_max;
END//

DELIMITER //
CREATE PROCEDURE get_full_user_services_pagination(identifier VARCHAR(10), show_max INT, last_service_id INT)
BEGIN
SELECT  S.id_service, 
		S.title, 
		S.description,  
		S.mail, 
		S.service_front_img_url, 
		S.rate, 
		S.price_from, 
		S.price_to, 
		S.is_promoted, 
		S.publication_date, 
		S.website_url, 
		S.facebook_url, 
		S.instagram_url, 
		S.twitter_url,
		C.name,
		P.phone_number,
		A.id_address
FROM service S, category C, phone_number P, address A, user U
WHERE U.rut=S.fk_rut AND
		U.rut = identifier AND
		S.fk_category = C.id_category AND
		S.fk_phonenumber = P.id_phone_number AND
		S.fk_address = A.id_address
ORDER BY S.id_service ASC
LIMIT last_service_id,show_max;
END//

DELIMITER //
CREATE PROCEDURE get_services_by_user(identifier VARCHAR(10))
BEGIN
SELECT S.id_service FROM service S WHERE S.fk_rut = identifier ORDER BY S.id_service ASC;
END//






