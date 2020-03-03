USE listing;

DELIMITER //
CREATE FUNCTION register(rut VARCHAR(10), name VARCHAR(255), last_name VARCHAR(255), user_img_url VARCHAR(255), birthday VARCHAR, mail VARCHAR(255), nickname VARCHAR(255), password VARCHAR(255), gender VARCHAR(1))
RETURNS BOOLEAN
BEGIN
insert into user (rut, name, last_name, user_img_url, birthday, mail, nickname, password, gender) values (rut, name, last_name, user_img_url, STR_TO_DATE(birthday,'%d/%m/%Y'), mail, nickname, password, gender);
END//

DELIMITER //
CREATE FUNCTION login(identifier VARCHAR(255), password VARCHAR(255))
RETURNS BOOLEAN
BEGIN

END//