--
-- PostgreSQL Sale db
--
-- All required tables are created for e-commerce company:
-- stock, product, product_sale_item, sale, sale_status, manufacturer
--

BEGIN;

SET client_encoding = 'LATIN1';

CREATE TABLE role(
    id integer NOT NULL,
    role_name varchar(100) NOT NULL
);

CREATE TABLE membership_type(
    id integer NOT NULL,
    membership_name varchar(100) NOT NULL,
    is_active boolean NOT NULL
);

CREATE TABLE user_account(
    id serial NOT NULL,
    user_name varchar(100) NOT NULL,
    email varchar(250) NOT NULL,
    first_name varchar(250) NOT NULL,
    last_name varchar(250) NOT NULL,
    date_of_birth DATE NOT NULL,
    mobile varchar(50) NOT NULL,
    above_18 boolean NOT NULL,
    current_membership_type int NOT NULL
);

CREATE TABLE user_membership(
    id serial NOT NULL,
    member_id varchar(100) NOT NULL,
    status_start_time timestamp NOT NULL,
    status_end_time timestamp,
    user_account_id integer NOT NULL,
    membership_type integer NOT NULL
);

CREATE TABLE user_role(
    id integer NOT NULL,
    role_start_time timestamp NOT NULL,
    role_end_time timestamp,
    user_account_id integer NOT NULL,
    role_id integer NOT NULL
);

CREATE TABLE stock(
    product_id integer NOT NULL,
    in_stock decimal(8,2) NOT NULL,
    last_update_time timestamp
);

CREATE TABLE manufacturer(
    id integer NOT NULL,
    manufacturer_name varchar(255) NOT NULL,
    ctry_of_origin  varchar(255)
);

CREATE TABLE product(
    id integer NOT NULL,
    name varchar(255) NOT NULL,
    manufacturer_id integer NOT NULL,
    manufacturer_name varchar(255),
    base_unit decimal(8,2) NOT NULL,
    is_active boolean NOT NULL,
    tax_percentage decimal(8,2)
);

CREATE TABLE product_sale_item(
    id integer NOT NULL,
    sold_quantity decimal(8,2) NOT NULL,
    price_per_unit decimal(8,2) NOT NULL,
    price decimal(8,2) NOT NULL,
    tax_amt decimal(8,2) NOT NULL,
    sale_id integer NOT NULL,
    product_id integer NOT NULL
);

CREATE TABLE sale_status(
    id integer NOT NULL,
    status_name varchar(100) NOT NULL

);

CREATE TABLE sale(
    id integer NOT NULL,
    create_time timestamp NOT NULL,
    paid_time timestamp NOT NULL,
    total_item_weight decimal(8,2) NOT NULL,
    sale_amt decimal(8,2) NOT NULL,
    sale_amt_paid decimal(8,2) NOT NULL,
    tax_amt decimal(8,2),
    sale_status_id integer NOT NULL,
    user_membership_id integer NOT NULL,
    user_role_id integer NOT NULL
);

CREATE TABLE member_applications(
    id serial NOT NULL,
    membership_id varchar(255) NOT NULL,
    firstname varchar(255) NOT NULL,
    lastname varchar(255),
    email varchar(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    mobile_no varchar(255) NOT NULL,
    above_18 boolean NOT NULL
);

COPY membership_type (id, membership_name, is_active) FROM stdin (Delimiter ',');
1,Silver,1
2,Gold,1
3,Platinum,1
4,Diamond,1
\.

COPY role (id, role_name) FROM stdin (Delimiter ',');
1,Employee
2,Member
\.

COPY sale_status (id, status_name) FROM stdin (Delimiter ',');
1,Pending Payment
2,Paid
3,Shipped
4,Completed
\.

COPY manufacturer (id, manufacturer_name, ctry_of_origin) FROM stdin (Delimiter ',');
1,Google,USA
2,Apple,USA
3,TWG,SGP
4,Samsung,KOR
\.

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pk PRIMARY KEY (id);

ALTER TABLE ONLY membership_type
    ADD CONSTRAINT membership_type_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_account
    ADD CONSTRAINT user_account_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_membership
    ADD CONSTRAINT user_membership_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_role_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_account
    ADD CONSTRAINT membership_type_fk FOREIGN KEY (current_membership_type) REFERENCES membership_type(id);

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_account_fk FOREIGN KEY (user_account_id) REFERENCES user_account(id);

ALTER TABLE ONLY user_role
    ADD CONSTRAINT role_fk FOREIGN KEY (role_id) REFERENCES role(id);

ALTER TABLE ONLY user_membership
    ADD CONSTRAINT user_account_fk FOREIGN KEY (user_account_id) REFERENCES user_account(id);

ALTER TABLE ONLY user_membership
    ADD CONSTRAINT membership_type_fk FOREIGN KEY (membership_type) REFERENCES membership_type(id);

ALTER TABLE ONLY manufacturer
    ADD CONSTRAINT manufacturer_pk PRIMARY KEY (id);

ALTER TABLE ONLY stock
    ADD CONSTRAINT stock_pk PRIMARY KEY (product_id);

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pk PRIMARY KEY (id);

ALTER TABLE ONLY product_sale_item
    ADD CONSTRAINT product_sale_pk PRIMARY KEY (id);

ALTER TABLE ONLY sale_status
    ADD CONSTRAINT sale_status_pk PRIMARY KEY (id);

ALTER TABLE ONLY sale
    ADD CONSTRAINT sale_pk PRIMARY KEY (id);

ALTER TABLE ONLY product
    ADD CONSTRAINT product_manufacturer_fk FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(id);

ALTER TABLE ONLY product_sale_item
    ADD CONSTRAINT product_id_fk FOREIGN KEY (product_id) REFERENCES product(id);

ALTER TABLE ONLY product_sale_item
    ADD CONSTRAINT sale_id_fk FOREIGN KEY (sale_id) REFERENCES sale(id);

ALTER TABLE ONLY sale
    ADD CONSTRAINT sale_status_fk FOREIGN KEY (sale_status_id) REFERENCES sale_status(id);

ALTER TABLE ONLY sale
    ADD CONSTRAINT user_membership_fk FOREIGN KEY (user_membership_id) REFERENCES user_membership(id);

ALTER TABLE ONLY sale
    ADD CONSTRAINT user_role_fk FOREIGN KEY (user_role_id) REFERENCES user_role(id);

COMMIT;

ANALYZE role;
ANALYZE membership_type;
ANALYZE user_account;
ANALYZE user_membership;
ANALYZE user_role;
ANALYZE stock;
ANALYZE manufacturer;
ANALYZE product;
ANALYZE product_sale_item;
ANALYZE sale;
ANALYZE sale_status;

