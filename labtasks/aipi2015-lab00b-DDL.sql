CREATE DATABASE bookstore;

USE bookstore;

CREATE TABLE country (
    id          INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    name        VARCHAR(50) NOT NULL,
    code        VARCHAR(2) NOT NULL UNIQUE,
    description VARCHAR(1000),
    KEY (id)
);
ALTER TABLE country ADD CONSTRAINT pk_country_id PRIMARY KEY (id);

CREATE TABLE publishing_house (
    id                INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    name              VARCHAR(50) NOT NULL,
    registered_number INT(10) NOT NULL UNIQUE,            
    description       VARCHAR(1000),
    postal_address    VARCHAR(200) NOT NULL,
    zip_code          INT(10) NOT NULL,
    country_id        INT(10) UNSIGNED NOT NULL,
    internet_address  VARCHAR(100),
    KEY (id)
);
ALTER TABLE publishing_house ADD CONSTRAINT pk_publishing_house_id PRIMARY KEY (id);
ALTER TABLE publishing_house ADD CONSTRAINT fk_publishing_house_country_id FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE collection (
    id                  INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    name                VARCHAR(100) NOT NULL,
    description         VARCHAR(1000),
    publishing_house_id INT(10) UNSIGNED NOT NULL,
    KEY (id),
    KEY (name, publishing_house_id)
);
ALTER TABLE collection ADD CONSTRAINT pk_collection_id PRIMARY KEY (id);
ALTER TABLE collection ADD CONSTRAINT fk_collection_publishing_house_id FOREIGN KEY (publishing_house_id) REFERENCES publishing_house(id) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE book (
    id            INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    title         VARCHAR(200) NOT NULL,
    subtitle      VARCHAR(200),
    description   VARCHAR(1000),
    edition       INT(2) NOT NULL,
    printing_year INT(4) NOT NULL,
    collection_id INT(10) UNSIGNED NOT NULL,
    KEY (id)
);
ALTER TABLE book ADD CONSTRAINT pk_book_id PRIMARY KEY (id);
ALTER TABLE book ADD CONSTRAINT fk_book_collection_id FOREIGN KEY (collection_id) REFERENCES collection(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE book ADD CONSTRAINT ck_book_edition_should_be_positive CHECK (edition>0);
ALTER TABLE book ADD CONSTRAINT ck_book_printing_year_should_be_greater_than_or_equal_to_1900 CHECK (printing_year>=1900);

CREATE TABLE format (
    id          INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    value       VARCHAR(30) NOT NULL,
    description VARCHAR(1000),
    KEY (id)
);
ALTER TABLE format ADD CONSTRAINT pk_constraint_id PRIMARY KEY (id);

CREATE TABLE language (
    id          INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    name        VARCHAR(50) NOT NULL,
    code        VARCHAR(2) NOT NULL UNIQUE,
    description VARCHAR(1000),
    KEY (id)
);
ALTER TABLE language ADD CONSTRAINT pk_language_id PRIMARY KEY (id);

CREATE TABLE book_presentation (
     id          INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
     isbn        BIGINT(13) NOT NULL UNIQUE,
     book_id     INT(10) UNSIGNED NOT NULL,
     format_id   INT(10) UNSIGNED NOT NULL,
     language_id INT(10) UNSIGNED NOT NULL,
     price       FLOAT(6,2) UNSIGNED NOT NULL,
     stockpile   INT(6) UNSIGNED NOT NULL,
     KEY (id)
);
ALTER TABLE book_presentation ADD CONSTRAINT pk_book_presentation_id PRIMARY KEY (id);
ALTER TABLE book_presentation ADD CONSTRAINT fk_book_presentation_book_id FOREIGN KEY (book_id) REFERENCES book(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE book_presentation ADD CONSTRAINT fk_book_presentation_language_id FOREIGN KEY (language_id) REFERENCES language(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE book_presentation ADD CONSTRAINT ck_book_presentation_price_should_be_positive CHECK (price>0);
ALTER TABLE book_presentation ADD CONSTRAINT ck_book_presentation_stockpile_should_be_positive CHECK (stockpile>=0);

CREATE TABLE writer (
    id         INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    biography  VARCHAR(1000) NOT NULL,
    KEY (id)
);
ALTER TABLE writer ADD CONSTRAINT pk_writer_id PRIMARY KEY (id);

CREATE TABLE author (
    id        INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    book_id   INT(10) UNSIGNED NOT NULL,
    writer_id INT(10) UNSIGNED NOT NULL,
    KEY (id),
	KEY (book_id, writer_id)
);
ALTER TABLE author ADD CONSTRAINT pk_author_id PRIMARY KEY (id);
ALTER TABLE author ADD CONSTRAINT fk_author_book_id FOREIGN KEY (book_id) REFERENCES book(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE author ADD CONSTRAINT fk_author_writer_id FOREIGN KEY (writer_id) REFERENCES writer(id) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE category (
    id          INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    name        VARCHAR(50) NOT NULL,
    description VARCHAR(1000),
    KEY (id)
);
ALTER TABLE category ADD CONSTRAINT pk_category_id PRIMARY KEY (id);

CREATE TABLE category_content (
    id          INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    book_id     INT(10) UNSIGNED NOT NULL,
    category_id INT(10) UNSIGNED NOT NULL,
    KEY (id),
    KEY (book_id, category_id)
);
ALTER TABLE category_content ADD CONSTRAINT pk_category_content_id PRIMARY KEY (id);
ALTER TABLE category_content ADD CONSTRAINT fk_category_content_book_id FOREIGN KEY (book_id) REFERENCES book(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE category_content ADD CONSTRAINT fk_category_content_category_id FOREIGN KEY (category_id) REFERENCES category(id) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE supply_order_header (
    id                    INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    identification_number VARCHAR(20) NOT NULL,
    issue_date            DATE NOT NULL,
    state                 VARCHAR(30) NOT NULL DEFAULT 'sent',
    publishing_house_id   INT(10) UNSIGNED NOT NULL,
    KEY (id),
    KEY (identification_number, issue_date)
);
ALTER TABLE supply_order_header ADD CONSTRAINT pk_supply_order_header_id PRIMARY KEY (id);
ALTER TABLE supply_order_header ADD CONSTRAINT fk_supply_order_header_publishing_house_id FOREIGN KEY (publishing_house_id) REFERENCES publishing_house(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE supply_order_header ADD CONSTRAINT ck_supply_order_header_state_allowed_values CHECK (state IN ('sent', 'delivered'));

CREATE TABLE supply_order_line (
    id                     INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    supply_order_header_id INT(10) UNSIGNED NOT NULL,
    book_presentation_id   INT(10) UNSIGNED NOT NULL,
    quantity               INT(4) UNSIGNED NOT NULL,
    KEY (id)
);
ALTER TABLE supply_order_line ADD CONSTRAINT pk_supply_order_line_id PRIMARY KEY (id);
ALTER TABLE supply_order_line ADD CONSTRAINT fk_supply_order_line_supply_order_header_id FOREIGN KEY (supply_order_header_id) REFERENCES supply_order_header(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE supply_order_line ADD CONSTRAINT fk_supply_order_line_book_presentation_id FOREIGN KEY (book_presentation_id) REFERENCES book_presentation(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE supply_order_line ADD CONSTRAINT ck_supply_order_line_quantity_should_be_positive CHECK (quantity>0);

CREATE TABLE user (
    id                  INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    personal_identifier BIGINT(13) UNSIGNED NOT NULL UNIQUE,
    first_name          VARCHAR(50) NOT NULL,
    last_name           VARCHAR(50) NOT NULL,
    address             VARCHAR(100) NOT NULL,
    phone_number        INT(10),
    email               VARCHAR(60) NOT NULL,
    type                VARCHAR(30) NOT NULL DEFAULT 'client',
    username            VARCHAR(30) NOT NULL,
    password            VARCHAR(30) NOT NULL,
    KEY (id)
);
ALTER TABLE user ADD CONSTRAINT pk_user_id PRIMARY KEY (id);
ALTER TABLE user ADD CONSTRAINT ck_user_type_allowed_values CHECK (type IN ('administrator', 'client'));

CREATE TABLE invoice_header (
    id                    INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    identification_number VARCHAR(20) NOT NULL,
    issue_date            DATETIME NOT NULL,
    state                 VARCHAR(10) NOT NULL DEFAULT 'issued', 
    user_id               INT(10) UNSIGNED NOT NULL,
    KEY (id)
);
ALTER TABLE invoice_header ADD CONSTRAINT pk_invoice_header_id PRIMARY KEY (id);
ALTER TABLE invoice_header ADD CONSTRAINT fk_invoice_header_user_id FOREIGN KEY (user_id) REFERENCES user(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE invoice_header ADD CONSTRAINT ck_invoice_header_state_allowed_values CHECK (state IN ('issued', 'paid'));

CREATE TABLE invoice_line (
    id                   INT(10) UNSIGNED AUTO_INCREMENT NOT NULL,
    invoice_header_id    INT(10) UNSIGNED NOT NULL,
    book_presentation_id INT(10) UNSIGNED NOT NULL,
    quantity             INT(4) UNSIGNED NOT NULL,
    KEY (id)
);
ALTER TABLE invoice_line ADD CONSTRAINT pk_invoice_line_id PRIMARY KEY (id);
ALTER TABLE invoice_line ADD CONSTRAINT fk_invoice_line_invoice_header_id FOREIGN KEY (invoice_header_id) REFERENCES invoice_header(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE invoice_line ADD CONSTRAINT fk_invoice_line_book_presentation_id FOREIGN KEY (book_presentation_id) REFERENCES book_presentation(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE invoice_line ADD CONSTRAINT ck_invoice_line_quantity_should_be_positive CHECK (quantity>0);