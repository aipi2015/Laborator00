CREATE DATABASE IF NOT EXISTS physician_catalog;

USE physician_catalog;

CREATE TABLE IF NOT EXISTS  title (
    id              INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    name            VARCHAR(50) NOT NULL,
    description     VARCHAR(1000),
	KEY(id)
);
ALTER TABLE title ADD CONSTRAINT pk_title_id PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS  speciality (
    id              INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    name            VARCHAR(50) NOT NULL,
    description     VARCHAR(1000),
	KEY(id)
);
ALTER TABLE speciality ADD CONSTRAINT pk_speciality_id PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS  doctor (
    id              INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    first_name      VARCHAR(50) NOT NULL,
	last_name       VARCHAR(50) NOT NULL,
    title_id        INT(10) UNSIGNED,
    speciality_id   INT(10) UNSIGNED,
    code            VARCHAR(20) NOT NULL,
    email           VARCHAR(50),
    phone_number    INT(10) NOT NULL,
	KEY (id)
);
ALTER TABLE doctor ADD CONSTRAINT pk_doctor_id PRIMARY KEY (id);
ALTER TABLE doctor ADD CONSTRAINT fk_doctor_title_id FOREIGN KEY (title_id) REFERENCES title (id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE doctor ADD CONSTRAINT fk_doctor_speciality_id FOREIGN KEY (speciality_id) REFERENCES speciality (id) ON UPDATE CASCADE ON DELETE SET NULL;


INSERT INTO title(name, description) VALUES
('fellow', '-'),
('resident', '-'),
('attending', '-'),
('professor', '-');

INSERT INTO speciality(name, description) VALUES
('surgery', '-'),
('general care', '-'),
('radiology', '-'),
('stomatology', '-');

INSERT INTO doctor(first_name, last_name, title_id, speciality_id, code, email, phone_number) VALUES
('Thomas', 'CARTER', 1, 2, 'AAA111', 'thomas.carter@google.com', 111222),
('Rachel', 'RODRIGUEZ', 3, 1, 'BBB222', 'rachel.rodrigues@hotmail.com', 333444),
('Harry', 'LEWIS', 2, 4, 'CCC333', 'harry.lewis@live.com', 555666),
('Richard', 'ALLEN', 3, 2, 'DDD444', 'richard.allen@space.com', 777888),
('Jessica', 'WHITE', 4, 1, 'EEE555', 'jessicawhite@aim.com', 999000);

CREATE DATABASE IF NOT EXISTS veterinary_clinic;

USE veterinary_clinic;

CREATE DATABASE IF NOT EXISTS veterinary_clinic;

USE veterinary_clinic;

CREATE TABLE IF NOT EXISTS breed (
    id              INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    name            VARCHAR(50) NOT NULL,
    description     VARCHAR(1000),
    KEY (id)
);
ALTER TABLE breed ADD CONSTRAINT pk_breed_id PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS owner (
    id              INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    first_name      VARCHAR(50) NOT NULL,
	last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(50),
    phone_number    INT(10) NOT NULL,
    bank_account    VARCHAR(50) NOT NULL,
    KEY (id)
);
ALTER TABLE owner ADD CONSTRAINT pk_owner_id PRIMARY KEY (id);
ALTER TABLE owner ADD CONSTRAINT owner_email_format CHECK (email LIKE '%@%.%');

CREATE TABLE IF NOT EXISTS animal (
    id              INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
	name            VARCHAR(50) NOT NULL,
	breed_id        INT(10) UNSIGNED,
    gender          CHAR(1) DEFAULT 'M' NOT NULL,
    birth_date      DATETIME NOT NULL,
    death_date      DATETIME,
    owner_id        INT(10) UNSIGNED,
    father_id       INT(10) UNSIGNED,
    mother_id       INT(10) UNSIGNED,
    KEY (id)
);
ALTER TABLE animal ADD CONSTRAINT pk_animal_id PRIMARY KEY (id);
ALTER TABLE animal ADD CONSTRAINT fk_animal_breed_id FOREIGN KEY(breed_id) REFERENCES breed(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE animal ADD CONSTRAINT fk_animal_ownder_id FOREIGN KEY(owner_id) REFERENCES owner(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE animal ADD CONSTRAINT fk_animal_father_id FOREIGN KEY(father_id) REFERENCES animal(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE animal ADD CONSTRAINT fk_animal_mother_id FOREIGN KEY(mother_id) REFERENCES animal(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE animal ADD CONSTRAINT chk_animal_sex_possible_values CHECK (gender in ('M', 'F'));

CREATE TABLE IF NOT EXISTS doctor (
    id              INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    first_name      VARCHAR(50) NOT NULL,
	last_name       VARCHAR(50) NOT NULL,
    title           VARCHAR(20) NOT NULL,
    speciality      VARCHAR(20),
    code            VARCHAR(20) NOT NULL,
    email           VARCHAR(50),
    phone_number    INT(10) NOT NULL,
    KEY (id)
);
ALTER TABLE doctor ADD CONSTRAINT pk_doctor_id PRIMARY KEY (id);
ALTER TABLE doctor ADD CONSTRAINT chk_doctor_email_format CHECK (email LIKE '%@%.%');

CREATE TABLE IF NOT EXISTS diagnosis (
    id              INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    name            VARCHAR(50) NOT NULL,
    description     VARCHAR(1000) NOT NULL,
    severity        VARCHAR(20) NOT NULL,
	cure            VARCHAR(1000) NOT NULL,
    KEY (id)
);
ALTER TABLE diagnosis ADD CONSTRAINT pk_diagnosis_id PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS medical_record (
    id              INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    animal_id       INT(10) UNSIGNED,
    doctor_id       INT(10) UNSIGNED,
	diagnosis_id    INT(10) UNSIGNED,
	date            DATETIME NOT NULL,
	treatment       VARCHAR(1000),
    KEY (id)
);
ALTER TABLE medical_record ADD CONSTRAINT pk_medical_record_id PRIMARY KEY (id);
ALTER TABLE medical_record ADD CONSTRAINT fk_medical_record_animal_id FOREIGN KEY(animal_id) REFERENCES animal(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE medical_record ADD CONSTRAINT fk_medical_record_doctor_id FOREIGN KEY(doctor_id) REFERENCES doctor(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE medical_record ADD CONSTRAINT fk_medicak_record_diagnosis_id FOREIGN KEY(diagnosis_id) REFERENCES diagnosis(id) ON UPDATE CASCADE ON DELETE SET NULL;

USE veterinary_clinic;

INSERT LOW_PRIORITY INTO breed (name, description) VALUES
('dog', 'The domestic dog (Canis lupus familiaris, or Canis familiaris) is a member of the Canidae family of the mammalian order Carnivora. The term \"domestic dog\" is generally used for both domesticated and feral varieties. The dog was the first domesticated animal and has been the most widely kept working, hunting, and pet animal in human history. The word \"dog\" can also refer to the male of a canine species, as opposed to the word \"bitch\" which refers to the female of the species.'),
('cat','The domestic cat (Felis catus or Felis silvestris catus) is a small, usually furry, domesticated, and carnivorous mammal. It is often called a housecat when kept as an indoor pet, or simply a cat when there is no need to distinguish it from other felids and felines. Cats are often valued by humans for companionship, and their ability to hunt vermin and household pests.'),
('guinea pig', NULL),
('horse', 'The horse (Equus ferus caballus) is one of two extant subspecies of Equus ferus. It is an odd-toed ungulate mammal belonging to the taxonomic family Equidae. The horse has evolved over the past 45 to 55 million years from a small multi-toed creature into the large, single-toed animal of today. Humans began to domesticate horses around 4000 BC, and their domestication is believed to have been widespread by 3000 BC. Horses in the subspecies caballus are domesticated, although some domesticated populations live in the wild as feral horses. These feral populations are not true wild horses, as this term is used to describe horses that have never been domesticated, such as the endangered Przewalski\'s horse, a separate subspecies, and the only remaining true wild horse. There is an extensive, specialized vocabulary used to describe equine-related concepts, covering everything from anatomy to life stages, size, colors, markings, breeds, locomotion, and behavior.'),
('gold fish', NULL);

INSERT IGNORE INTO owner 
  SET first_name='Sarah', last_name='LEE', email='sarah.lee@lavabit.com', phone_number='123456789', bank_account='US01AABB0000000001';
INSERT IGNORE INTO owner 
  SET first_name='William', last_name='LOPEZ', email='william.lopez@aim.com', phone_number='456789123', bank_account='UK02CCDD0000000002';
INSERT IGNORE INTO owner 
  SET first_name='Samuel', last_name='JONES', email='samuel.jones@fastmail.com', phone_number='789123456', bank_account='DE03EEFF0000000003';
INSERT IGNORE INTO owner 
  SET first_name='William', last_name='THOMPSON', email='william.thompson@lmyway.com', phone_number='123789456', bank_account='FR04GGHH0000000004';
INSERT IGNORE INTO owner 
  SET first_name='Richard', last_name='MARTIN', email='richard.martin@myspace.com', phone_number='789456123', bank_account='IT05IIJJ0000000005';

LOAD DATA LOCAL INFILE 'C:\\animals.txt' 
INTO TABLE animal
FIELDS TERMINATED BY '\t' ENCLOSED BY '' ESCAPED BY '\\' LINES TERMINATED BY '\r\n' STARTING BY ''
(name, breed_id, gender, birth_date, owner_id, father_id, mother_id);

INSERT HIGH_PRIORITY INTO doctor(first_name, last_name, title, speciality, code, email, phone_number) 
SELECT d.first_name, d.last_name, t.name, s.name, d.code, d.email, d.phone_number
FROM physician_catalog.doctor d, physician_catalog.title t, physician_catalog.speciality s WHERE t.id = d.title_id AND s.id = d.speciality_id;

INSERT INTO diagnosis VALUES
(NULL, 'giardiasis', 'Giardiasis is a protozoal, parasitic, gastrointestinal zoonotic disease in humans and domestic and wild animals.', 'medium', 'nitroimidazole derivatives, benzimidazole compounds or acridine dyes'),
(NULL, 'rabies', 'Rabies is a severely fatal, viral, neurological disease of mammals.', 'high', 'There is no treatment once the clinical signs appear.'),
(NULL, 'dermatophytosis', 'Dermatophytosis is a fungal skin disease that commonly affects humans as well as wild and domestic animals', 'low', 'Dermatophyte infections are treated with a variety of topical and oral antifungal drugs.'),
(NULL, 'mycobacteriosis', 'Mycobacteriosis is a bacterial, systemic, granulomatous skin disease that occurs in aquarium and culture food fish and can affect humans.', 'low', ' Antibiotic therapy may be warranted to prevent progression to deep infection.'),
(NULL, 'malignant catarrhal fever', 'Malignant catarrhal fever (MCF) is a serious, often fatal, viral disease affecting cattle, bison, deer, moose, exotic ruminants, and pigs.', 'severe', 'There is no cure discovered so far');

LOAD DATA LOCAL INFILE 'C:\\medical_records.txt' 
INTO TABLE medical_record 
FIELDS TERMINATED BY '\t' ENCLOSED BY '' ESCAPED BY '\\' LINES TERMINATED BY '\r\n' STARTING BY ''
(animal_id, doctor_id, diagnosis_id)
SET date=CURRENT_DATE, treatment='-';

UPDATE LOW_PRIORITY animal SET birth_date=CURRENT_DATE
WHERE YEAR(CURRENT_TIMESTAMP) - YEAR(birth_date) - (MONTH(CURRENT_TIMESTAMP) < MONTH(birth_date) OR (MONTH(CURRENT_TIMESTAMP) = MONTH(birth_date) AND DAY(CURRENT_TIMESTAMP) < DAY(birth_date))) < 0
ORDER BY birth_date DESC;

UPDATE medical_record mr, diagnosis d 
SET mr.treatment = d.cure
WHERE mr.diagnosis_id = d.id;

DELETE QUICK breed, animal 
FROM breed, animal 
WHERE animal.breed_id = breed.id AND breed.description IS NULL;

DELETE LOW_PRIORITY IGNORE FROM animal, owner 
USING animal INNER JOIN owner ON animal.owner_id=owner.id
WHERE animal.death_date IS NOT NULL;

SELECT a.name AS name, 
       b.name AS breed, 
	   a.gender AS gender,
       YEAR(CURRENT_TIMESTAMP) - YEAR(a.birth_date) - (MONTH(CURRENT_TIMESTAMP) < MONTH(a.birth_date) OR (MONTH(CURRENT_TIMESTAMP) = MONTH(a.birth_date) AND DAY(CURRENT_TIMESTAMP) < DAY(a.birth_date))) AS age, 
	   CONCAT(o.first_name, ' ' , o.last_name) AS owner,
       COALESCE((SELECT name FROM animal where id=COALESCE(a.father_id,'0')),'-') AS father,
	   COALESCE((SELECT name FROM animal where id=COALESCE(a.mother_id,'0')),'-') AS mother,
       (SELECT GROUP_CONCAT(DISTINCT d.name) FROM diagnosis d, medical_record mr WHERE d.id = mr.diagnosis_id AND mr.animal_id=a.id) AS diseases,
       (SELECT GROUP_CONCAT(DISTINCT CONCAT(d.first_name,' ', d.last_name)) FROM doctor d, medical_record mr WHERE d.id = mr.doctor_id AND mr.animal_id=a.id) AS physicians
FROM animal a, breed b, owner o
WHERE b.id = a.breed_id AND o.id = a.owner_id
HAVING age > 0;

#produs cartezian
SELECT * FROM animal CROSS JOIN owner;

#natural join
SELECT * FROM animal NATURAL JOIN owner;

#inner join
SELECT * FROM animal INNER JOIN owner ON animal.owner_id = owner.id;

#left outer join
SELECT * FROM animal LEFT OUTER JOIN owner ON animal.owner_id = owner.id;

#right outer join
SELECT * FROM animal RIGHT OUTER JOIN owner ON animal.owner_id = owner.id;

#self join
SELECT * FROM animal a1 JOIN animal a2 ON a1.father_id = a2.id OR a1.mother_id = a2.id;

#union
SELECT first_name, last_name, email, phone_number, 'Pet Owner' AS role FROM owner 
UNION
SELECT first_name, last_name, email, phone_number, 'Physician' AS role FROM doctor;

SELECT a.name AS name,
       YEAR(CURRENT_TIMESTAMP) - YEAR(a.birth_date) - (MONTH(CURRENT_TIMESTAMP) < MONTH(a.birth_date) OR (MONTH(CURRENT_TIMESTAMP) = MONTH(a.birth_date) AND DAY(CURRENT_TIMESTAMP) < DAY(a.birth_date))) AS age  
FROM animal a
WHERE birth_date = (SELECT MIN(birth_date) FROM animal);

SELECT a.name AS name,
       YEAR(CURRENT_TIMESTAMP) - YEAR(a.birth_date) - (MONTH(CURRENT_TIMESTAMP) < MONTH(a.birth_date) OR (MONTH(CURRENT_TIMESTAMP) = MONTH(a.birth_date) AND DAY(CURRENT_TIMESTAMP) < DAY(a.birth_date))) AS age  
FROM animal a
WHERE birth_date <= ALL(SELECT birth_date FROM animal);

SELECT a.name AS name,
       b.name AS breed
FROM animal a INNER JOIN breed b ON a.breed_id=b.id
WHERE EXISTS (SELECT * FROM medical_record mr WHERE mr.animal_id = a.id);

SELECT b.name, 
       MAX(average_age) 
FROM (SELECT a.breed_id, 
             AVG(YEAR(CURRENT_TIMESTAMP) - YEAR(a.birth_date) - (MONTH(CURRENT_TIMESTAMP) < MONTH(a.birth_date) OR (MONTH(CURRENT_TIMESTAMP) = MONTH(a.birth_date) AND DAY(CURRENT_TIMESTAMP) < DAY(a.birth_date)))) AS average_age 
      FROM animal a 
      GROUP BY a.breed_id) statistics, breed b
WHERE b.id = statistics.breed_id;

SELECT a.name AS name,
	   (SELECT COUNT(*) FROM medical_record mr WHERE mr.animal_id = a.id) AS number_of_examinations
FROM animal a;

DELIMITER //
CREATE PROCEDURE get_number_of_diseases(
    IN animal_id INT,
    OUT number_of_diseases INT(2)
)
BEGIN
    SELECT COUNT(DISTINCT mr.diagnosis_id) INTO number_of_diseases
    FROM medical_record mr INNER JOIN animal a ON mr.animal_id = a.id 
    WHERE a.id = animal_id;
END; //
CALL get_number_of_diseases(2, @result);
SELECT @result;

DELIMITER //
CREATE FUNCTION get_number_of_examinations(animal_id INT)
    RETURNS INT(2)
BEGIN
    DECLARE number_of_examinations INT(2);
    SELECT COUNT(mr.id) INTO number_of_examinations
    FROM medical_record mr INNER JOIN animal a ON mr.animal_id = a.id
    WHERE a.id = animal_id;
    RETURN number_of_examinations;
END; //
SELECT get_number_of_examinations(2);

DELIMITER //
CREATE TRIGGER animal_update_check 
    BEFORE UPDATE ON animal
    FOR EACH ROW
BEGIN
    IF NEW.birth_date > CURRENT_DATE THEN
        SET NEW.birth_date = CURRENT_DATE;
    ELSEIF YEAR(NEW.birth_date) - YEAR(CURRENT_DATE) > 20 THEN
        SET NEW.birth_date = OLD.birth_date;
    END IF;
END; //

DELIMITER //
CREATE TRIGGER owner_insert_check 
    BEFORE INSERT ON owner 
    FOR EACH ROW
BEGIN
    DECLARE message VARCHAR(255);
    IF NEW.email IS NOT NULL AND NEW.email NOT LIKE '%@%.%' THEN
        SET message = concat('The format of an email should be username@domain.country ', cast(NEW.email AS CHAR));
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = message;
     END IF; 
END; //

CREATE VIEW pets_per_owner AS
    SELECT CONCAT(o.first_name,' ', o.last_name) AS name,
		   (SELECT GROUP_CONCAT(a.name) FROM animal a WHERE a.owner_id=o.id) AS pets
	FROM owner o;

SELECT * FROM pets_per_owner;

DELIMITER //
CREATE PROCEDURE average_age_per_gender()
BEGIN

    DECLARE done INT DEFAULT FALSE;
    DECLARE _gender CHAR(1);
    DECLARE _birth_date DATETIME;
    DECLARE current_age, male_total_age, male_number, female_total_age, female_number INT;
    DECLARE animal_cursor CURSOR FOR SELECT gender, birth_date FROM animal;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET male_total_age := 0;
	SET male_number := 0;
    SET female_total_age := 0;
	SET female_number := 0;
 
    OPEN animal_cursor;

    this_loop: LOOP
        
        FETCH animal_cursor INTO _gender, _birth_date;
        
		IF done THEN
            LEAVE this_loop;
        END IF;

        SET current_age := YEAR(CURRENT_TIMESTAMP) - YEAR(_birth_date) - (MONTH(CURRENT_TIMESTAMP) < MONTH(_birth_date) OR (MONTH(CURRENT_TIMESTAMP) = MONTH(_birth_date) AND DAY(CURRENT_TIMESTAMP) < DAY(_birth_date)));
        IF current_age < 0 THEN 
		    SET current_age := 0;
		END IF;

        CASE _gender
		    WHEN 'M' THEN
						 SET male_total_age := male_total_age + current_age;
					     SET male_number := male_number + 1;
            WHEN 'F' THEN
                         SET female_total_age := female_total_age + current_age; 
                         SET female_number := female_number + 1;
        END CASE;

    END LOOP;

    SELECT CONCAT('Varsta medie a animalelor de sex masculin este ', male_total_age / male_number,'. Varsta medie a animalelor de sex feminin este ', female_total_age / female_number,'.');

    CLOSE animal_cursor;

END; //

CALL average_age_per_gender;

DROP DATABASE veterinary_clinic;
DROP DATABASE physician_catalog;