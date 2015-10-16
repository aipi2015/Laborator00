USE bookstore;

# EXERCISE 3
SELECT b.id, 
	   b.title, 
       (SELECT GROUP_CONCAT(DISTINCT CONCAT(w.first_name, ' ', w.last_name) SEPARATOR ', ') 
        FROM author a, writer w 
        WHERE a.book_id = b.id AND w.id = a.writer_id) AS authors,
	   cl.name AS collection,
       ph.name AS publishing_house,
       b.edition,
       b.printing_year,
       c.name AS country
FROM book b, collection cl, publishing_house ph, country c
WHERE cl.id = b.collection_id
AND ph.id = cl.publishing_house_id
AND c.id = ph.country_id
ORDER BY b.id;

# EXERCISE 4
CREATE TEMPORARY TABLE IF NOT EXISTS book_tmp (
  book_id INT(10) UNSIGNED NOT NULL
);

INSERT INTO book_tmp SELECT DISTINCT b.id
					 FROM book b
                     WHERE (SELECT COUNT(*)
						    FROM book_presentation bp 
							WHERE bp.book_id = b.id) > 3;
                            
SELECT bp.book_id, bp.price FROM book_presentation bp WHERE bp.book_id IN (SELECT book_id FROM book_tmp);

UPDATE book_presentation
SET price = price * 1.15 
WHERE book_id IN (SELECT book_id FROM book_tmp);

SELECT bp.book_id, bp.price FROM book_presentation bp WHERE bp.book_id IN (SELECT book_id FROM book_tmp);

DROP TABLE book_tmp;

# EXERCISE 5
SELECT CONCAT(w.first_name, ' ', w.last_name) AS writer,
       (SELECT GROUP_CONCAT(b.title SEPARATOR '; ') 
	    FROM book b, author a 
		WHERE b.id = a.book_id 
        AND a.writer_id = w.id) AS books,
       (SELECT COUNT(b.title) 
        FROM book b, author a 
        WHERE b.id = a.book_id 
        AND a.writer_id = w.id) AS total,
       (SELECT COUNT(b.title) 
        FROM book b, author a 
        WHERE b.id = a.book_id 
        AND a.writer_id = w.id 
        AND (SELECT COUNT(w1.id) 
			 FROM writer w1, author a1 
			 WHERE a1.book_id = b.id 
             AND w1.id = a1.writer_id) = 1) AS alone,
       (SELECT COUNT(b.title) 
		FROM book b, author a 
		WHERE b.id=a.book_id 
        AND a.writer_id = w.id 
        AND (SELECT COUNT(w1.id) 
             FROM writer w1, author a1 
             WHERE a1.book_id = b.id 
             AND w1.id = a1.writer_id) <> 1) AS collaboration
FROM writer w
HAVING total > 4 AND alone > 2
ORDER BY CONCAT(w.first_name, ' ', w.last_name) ASC;

# EXERCISE 6
DELETE FROM writer WHERE (SELECT COUNT(*) 
                          FROM author a 
						  where a.writer_id = writer.id) = 0;

# EXERCISE 7
DELIMITER //
CREATE FUNCTION calculate_invoice_value (
  identification_number VARCHAR(20)
)
RETURNS DECIMAL(8,2) DETERMINISTIC
BEGIN
  DECLARE result DECIMAL(8,2);
  SELECT SUM(il.quantity * bp.price) INTO result 
  FROM invoice_header ih, invoice_line il, book_presentation bp
  WHERE ih.identification_number = identification_number 
  AND il.invoice_header_id = ih.id 
  AND bp.id = il.book_presentation_id;
  RETURN result;
END; //

SELECT identification_number, calculate_invoice_value(identification_number) AS invoice_value 
FROM invoice_header 
ORDER BY invoice_value DESC 
LIMIT 3;

# EXERCISE 8
DELIMITER //
CREATE PROCEDURE calculate_user_total_invoice_value (
  IN personal_identifier BIGINT(13),
  OUT total_invoice_value DECIMAL(8,2)
)
BEGIN
  SELECT SUM(calculate_invoice_value(identification_number)) INTO total_invoice_value 
  FROM invoice_header ih 
  WHERE ih.user_id = (SELECT u.id 
				      FROM user u
                      WHERE u.personal_identifier = personal_identifier);
END; //

# EXERCISE 9
DELIMITER //
CREATE PROCEDURE user_maximum_invoice_value() 
BEGIN
  DECLARE done INT DEFAULT FALSE; 
  DECLARE user_personal_identifier BIGINT(13);
  DECLARE total_invoice_value FLOAT(20,2);
  DECLARE user_maximum_total_invoice_value_personal_identifier BIGINT(13);
  DECLARE maximum_total_invoice_value FLOAT(20,2);
  DECLARE user_cursor CURSOR FOR SELECT personal_identifier FROM user; 
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN user_cursor; 
    
    SET user_personal_identifier := 0;
    SET total_invoice_value := 0.0;
    SET user_maximum_total_invoice_value_personal_identifier := 0;
    SET maximum_total_invoice_value := 0;
    
    main_loop: LOOP FETCH user_cursor INTO user_personal_identifier; 
			     IF done 
                   THEN LEAVE main_loop; 
                 END IF;
                 CALL calculate_user_total_invoice_value (user_personal_identifier, total_invoice_value);
                 IF total_invoice_value > maximum_total_invoice_value THEN
				   SET maximum_total_invoice_value := total_invoice_value;
                   SET user_maximum_total_invoice_value_personal_identifier := user_personal_identifier;
                 END IF;
    END LOOP; 
    SELECT CONCAT('Valoarea maxima a sumelor facturilor pentru un utilizator este ', maximum_total_invoice_value,', acesta avand identificatorul personal ',user_maximum_total_invoice_value_personal_identifier,'.');
	CLOSE user_cursor; 
END; //

CALL user_maximum_invoice_value();

# EXERCISE 10
DROP TRIGGER book_presentation_update_check;
DELIMITER //
CREATE TRIGGER book_presentation_update_check BEFORE UPDATE ON book_presentation FOR EACH ROW
BEGIN
  DECLARE avg_price FLOAT(20,2);
  DECLARE message VARCHAR(255);
  IF NEW.price > OLD.price THEN
    SELECT AVG(price) INTO avg_price
    FROM book_presentation bp
    WHERE bp.format_id = NEW.format_id;
    IF NEW.price > avg_price THEN
      SET NEW.price := avg_price;
      SET message := concat('Valoarea pretului ', NEW.price,' pentru produsul ', NEW.book_id,' a fost modificat la valoarea ', avg_price, '.');
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = message;
    END IF;
  END IF;
END; //