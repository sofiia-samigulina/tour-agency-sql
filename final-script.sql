--sequences for triggers
DROP SEQUENCE IF EXISTS dep_id_od100;
CREATE SEQUENCE dep_id_od100
INCREMENT 1
START 100;

DROP SEQUENCE IF EXISTS order_num_tours;
CREATE SEQUENCE order_num_tours
INCREMENT 1
START 100;

DROP SEQUENCE IF EXISTS order_num_payments;
CREATE SEQUENCE order_num_payments
INCREMENT 1
START 100;

--creating tables

--table Clients
DROP TABLE IF EXISTS clients CASCADE;

CREATE TABLE clients (
    name varchar(50) not null,
    surname varchar(100) not null,
    phone int not null unique,
    email varchar(50) not null unique,
    birthday date not null,
    date_first_purchase date,
    insurance varchar(30),
    how_heard_about_us varchar(150),
    document_number varchar(20),
    citizenship varchar(150) not null,
    primary key (document_number)
);

--table Departments
DROP TABLE IF EXISTS departments CASCADE;

CREATE TABLE departments (
    name_dir varchar(50) not null,
    surname_dir varchar(100) not null,
    phone_dir int not null unique,
    email_dir varchar(50) not null unique,
    how_many_employees int not null,
    department_id int,
    department_name varchar(500) not null unique,
    primary key (department_id)
);

--table Employees
DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    name varchar(50) not null,
    surname varchar(100) not null,
    position varchar(100) not null,
    phone int not null unique,
    email varchar(50) not null unique,
    employe_id int,
    department_id int not null,
    degree varchar(500),
    date_employment date not null,
    salary float not null,
    children char(5),
    primary key (employe_id),
    foreign key (department_id) references departments(department_id)
);

--table Tours
DROP TABLE IF EXISTS tours CASCADE;

CREATE TABLE tours (
    order_number INT,
    departure_day date not null,
    transport_type varchar(100) not null,
    starting_location varchar(100) not null,
    journey_to varchar(100) not null,
    travelling_type varchar(100),
    accomodation_type varchar(100),
    how_many_days INT not null,
    client_doc_number varchar(20) not null,
    employe_id int not null,
    primary key (order_number),
    foreign key (client_doc_number) references clients(document_number),
    foreign key (employe_id) references employees(employe_id)
);

--table Payments
DROP TABLE IF EXISTS payments CASCADE;

CREATE TABLE payments (
    payment_id int,
    payment_date date not null,
    payment_type varchar(50) not null,
    total float not null,
    order_number int not null unique,
    special_offers varchar(100),
    gift_card_num int unique,
    iban varchar(100),
    primary key (payment_id),
    foreign key (order_number) references tours(order_number)
);

--triggers autoincrements
CREATE OR REPLACE FUNCTION set_dep_incr()
    RETURNS TRIGGER
    AS $$
        BEGIN
            IF NEW.department_id IS NULL then
                NEW.department_id := nextval('dep_id_od100');
            end if;
        RETURN NEW;
        END;
    $$LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_order_num_tours()
    RETURNS TRIGGER
    AS $$
        BEGIN
            IF NEW.order_number IS NULL then
                NEW.order_number := nextval('order_num_tours');
            end if;
        RETURN NEW;
        END;
    $$LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_order_num_payments()
    RETURNS TRIGGER
    AS $$
        BEGIN
            IF NEW.order_number IS NULL then
                NEW.order_number := nextval('order_num_payments');
            end if;
        RETURN NEW;
        END;
    $$LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_dep_id
BEFORE INSERT ON departments
FOR EACH ROW
EXECUTE FUNCTION set_dep_incr();

CREATE TRIGGER trigger_set_order_num_tours
BEFORE INSERT ON tours
FOR EACH ROW
EXECUTE FUNCTION set_order_num_tours();

CREATE TRIGGER trigger_set_order_num_paym
BEFORE INSERT ON payments
FOR EACH ROW
EXECUTE FUNCTION set_order_num_payments();

--inserts
INSERT INTO clients
    (name, surname, phone, email, birthday, date_first_purchase, insurance, how_heard_about_us, document_number, citizenship)
VALUES
    ('Alexandra', 'Polakova', 0987236451, 'sandra.polakova@yahoo.com', '1976-10-10', '2024-12-05', 'VZP', NULL, '761010/8517', 'Slovakia'),
    ('Sonya', 'Migasova', 0959163544, 'sonya200397@gmail.com', '1997-03-20', '2024-12-10', NULL, 'Instagram', '975320/8756', 'Russia'),
    ('Branislav', 'Kucera', 0968962123, 'kucera88.branislav@gmail.com', '1988-05-10', '2024-12-15', NULL, 'friends', 'P23556911', 'Slovakia'),
    ('Ivana', 'Horvathova', 0948659727, 'ivankaa1998@gmail.com', '1998-02-20', '2024-12-20', 'UNION', 'friends', '985220/6056', 'Slovakia'),
    ('Mirka', 'Novakova', 0998242289, 'novakova_m@outlook.com', '1989-11-29', '2025-01-05', 'VZP', 'Instagram', '896129/2439', 'Slovakia'),
    ('Branislav', 'Tomcikov', 0967891233, 'branislav10021978@outlook.com', '1978-02-10', '2025-01-07', NULL, 'Facebook', 'P45612978', 'Slovakia'),
    ('Alina', 'Vasilenko', 0967995131, 'vasilenko_a@gmail.com', '1994-05-15', '2025-01-10', NULL, 'Facebook', '945515/8779', 'Ukraine'),
    ('Samuel', 'Novacikov', 0977555111, 'novacikov_1968@yahoo.com', '1968-04-13', '2025-01-17', 'UNION', NULL, '680413/3787', 'Slovakia'),
    ('Juraj', 'Molnar', 0931998462, 'molnar_juraj@outlook.com', '1974-12-03', '2025-01-23', 'Dovera', 'Facebook', '741203/1506', 'Slovakia'),
    ('Julia', 'Ivanova', 0936778123, 'ivanolia@gmail.com', '1988-01-31', '2025-02-01', NULL, 'Instagram', '885131/1743', 'Ukraine');

INSERT INTO departments
    (name_dir, surname_dir, phone_dir, email_dir, how_many_employees, department_name)
VALUES
    ('Samuel', 'Migas', 0956725463, 'migas_it@outlook.com', 3, 'Technical Department'),
    ('Antonia', 'Vargova', 0900555666, 'vargova_predaj@outlook.com', 7, 'Sales Department'),
    ('Greta', 'Blanarova', 0983421655, 'blanarova_pr@outlook.com', 3, 'Marketing Department'),
    ('Blazej','Vinogradov', 0924569781, 'vinogradov_support@outlook.com', 2, 'Customer Service Department'),
    ('Irina','Tereshchuk', 0956698123, 'tereshchuk_fin@outlook.com', 2, 'Finance Department');

INSERT INTO employees
    (name, surname, position, phone, email, employe_id, department_id, degree, date_employment, salary, children)
VALUES
    ('Katka', 'Novakova', 'Tour Sales Agent', 0904123890, 'katka.novakova@outlook.com', 1011, 101, NULL, '2024-11-25', 1350, 'no'),
    ('Pavol', 'Petrov', 'Outdoor Advertising Specialist', 0919456789, 'pavol.petrov@outlook.com', 1021, 102, NULL, '2024-11-25', 1350, 'yes'),
    ('Mirka', 'Vargova', 'Tour Sales Agent', 0905678901, 'mirka.vargova@outlook.com', 1012, 101, NULL, '2024-12-05', 1350, 'yes'),
    ('Norbert', 'Varga', 'Complaints Officer', 0912456789, 'norbert.varga@outlook.com', 1015, 101, NULL, '2024-12-15', 1050, NULL),
    ('Diana', 'Kovalenko', 'Call Center Specialist', 0907345678, 'diana.kovalenko@outlook.com', 1031, 103, NULL, '2024-12-15', 1000, 'no'),
    ('Alexandra', 'Polarikova', 'Complaints Officer', 0915678901, 'alexandra.polarikova@outlook.com', 1016, 101, 'Sales Management', '2024-12-17', 1050, 'no'),
    ('Samuel','Novakov', 'Accountant', 0919654321, 'samuel.novakov@outlook.com', 1041, 104, NULL, '2024-12-18', 1050, 'yes'),
    ('Norbert', 'Kovac', 'Tour Sales Agent', 0910234567, 'norbert.kovac@outlook.com', 1013, 101, 'Sales Management', '2025-01-03', 1450, 'yes'),
    ('Robert', 'Polak', 'Tour Sales Agent', 0911987654, 'robert.polak@outlook.com', 1014, 101, 'Sales Management', '2025-01-03', 1400, 'no'),
    ('Samuel', 'Bechera', 'frontend developer', 0902987654, 'samuel.bechera@outlook.com', 1001, 100, 'Informatics', '2025-01-10', 2500, NULL),
    ('Michal', 'Vadimov', 'online supporter', 0948234567, 'michal.vadimov@outlook.com', 1032, 103, 'Veterinary Science', '2025-01-16', 1200, NULL),
    ('Richard', 'Polarik', 'Telemarketing Specialist', 0940678901, 'richard.polarik@outlook.com',1022, 102, NULL, '2025-01-17', 1350, 'no'),
    ('Dusan', 'Ambros', 'QR engineer', 0903456789, 'dusan.ambros@outlook.com', 1002, 100, NULL, '2024-01-19', 1850, 'yes'),
    ('Anya', 'Kirsanova', 'social media manager', 0918987654, 'anya.kirsanova@outlook.com', 1023, 101, 'Advertising a marketing', '2025-01-21', 1300, NULL),
    ('Kristina', 'Odincova','Sales Analyst', 0917234567, 'kristina.odincova@outlook.com', 1017, 101, 'Data Analyst', '2025-01-25', 1500, 'yes'),
    ('Ivana', 'Kovacova', 'Accountant', 0902789012, 'ivana.kovacova@outlook.com', 1042, 104, 'Finance Management', '2025-02-05', 1050, NULL),
    ('Sofiia', 'Samigulina', 'Database Administrator', 0901234567, 'sofiia.samigulina@outlook.com', 1003, 100, 'Informatics', '2025-02-05',  1600, NULL);

INSERT INTO tours
    (departure_day, transport_type, starting_location, journey_to, travelling_type, accomodation_type, how_many_days, client_doc_number, employe_id)
VALUES
    ('2025-02-04', 'airplane', 'Vienna', 'Spain', 'tourism', 'hostel', 5, '761010/8517', 1011),
    ('2025-03-08', 'airplane', 'Budapest', 'France', 'tourism', 'hotel', 3, '975320/8756',1012),
    ('2025-03-10', 'airplane', 'Vienna', 'USA', NULL, 'hotel', 3, 'P23556911',1013),
    ('2025-01-15', 'airplne', 'Budapest', 'Slovenia', 'visiting', NULL, 5, '985220/6056', 1014),
    ('2025-02-12', 'train', 'Kosice', 'Vienna', 'business', 'hotel', 4, '896129/2439', 1011),
    ('2025-04-07', 'airplane', 'Budapest', 'Russia', 'tourism', 'flat', 7, 'P45612978', 1012),
    ('2025-03-23', 'train', 'Kosice', 'Switzerland', 'Pilgrimage', NULL, 3,'945515/8779', 1013),
    ('2025-03-24', 'bus', 'Kosice', 'Warsaw', 'tourism', 'flat', 6, '680413/3787', 1014),
    ('2025-04-01','airplane', 'Budapest', 'Italy', 'tourism', 'hotel', 10, '741203/1506', 1011),
    ('2025-05-05', 'airplane', 'Vienna', 'Spain', 'tourism', 'flat', 11, '885131/1743', 1012);

INSERT INTO payments
    (payment_id, payment_date, payment_type, total, special_offers, gift_card_num, iban)
VALUES
    (19872, '2024-12-05', 'debit card, gift card', 155.28,  NULL, 202400, 'SK78 1122 3344 5566 7788 9900'),
    (47932, '2024-12-10', 'cash', 348,  'Christmas sale -15%', NULL, NULL),
    (6689, '2024-12-15', 'cash, gift card', 1335.50, 'Christmas sale -15%', 202401, NULL),
    (4586, '2024-12-20', 'debit card', 479.95,  'Christmas sale -15%', NULL, 'SK64 0054 0041 7432 1275 4217'),
    (65487, '2025-01-05', 'gift card', 150,   NULL, 202402, NULL),
    (4239, '2025-01-07', 'debit card', 1500.75,  '30% off your first trip outside Schengen', NULL, 'SK45 9876 5432 1098 7654 3210'),
    (5697, '2025-01-10', 'debit card', 750.50, NULL, NULL,  'SK12 1234 5678 9012 3456 7890'),
    (3246, '2025-01-17', 'debit card', 342.55,   NULL, NULL, 'SK68 4210 8700 1714 3751 7491'),
    (1256, '2025-01-23', 'debit card', 850.75,   NULL, NULL, 'SK68 7500 0000 0012 3456 7892'),
    (21685, '2025-02-01', 'cash', 500,  '-10% birthday sale', NULL, NUll);

--function
CREATE OR REPLACE FUNCTION changeDocuments()
    RETURNS TRIGGER
    AS $$
        BEGIN
            IF NEW.document_number <> OLD.document_number THEN
                UPDATE tours
                SET client_doc_number = NEW.document_number
                WHERE client_doc_numbet = OLD.document_number;
            end if;
            RETURN NEW;
        END;
    $$LANGUAGE plpgsql;

CREATE TRIGGER trigger_updateDocs
AFTER UPDATE OF document_number ON clients
FOR EACH ROW
EXECUTE FUNCTION changeDocuments();

--creating views

--this view shows who doesn't have any insurances
CREATE VIEW any_insurances AS
    SELECT name, surname, email
    FROM clients
    WHERE insurance IS NULL;

--function
CREATE OR REPLACE FUNCTION changeEmailsAnyInsurances()
    RETURNS TRIGGER
    AS $$
        BEGIN
            IF NEW.email <> OLD.email THEN
                UPDATE clients
                SET email = NEW.email
                WHERE email = OLD.email;
            end if;
            RETURN NEW;
        END;
    $$LANGUAGE plpgsql;

CREATE TRIGGER trigger_updateEmails
INSTEAD OF UPDATE ON any_insurances
FOR EACH ROW
EXECUTE FUNCTION changeEmailsAnyInsurances();

--this view shows how many days Samuel Novakov works in this company and his salary
CREATE VIEW samuel_novakov AS
    SELECT CONCAT (name, ' ', surname) AS "Name", (CURRENT_DATE-employees.date_employment) AS "Count of days", employees.salary AS "Salary"
    FROM employees
    WHERE name = 'Samuel' AND surname = 'Novakov';

--this view shows who sold a trip to Amerika
CREATE VIEW whoSoldTripToUSA AS
    SELECT name AS "Name", surname AS "Surname", email AS "Email", total AS "Total Sales"
    FROM employees
    JOIN tours t on employees.employe_id = t.employe_id
    JOIN payments p on t.order_number = p.order_number
    WHERE journey_to = 'USA';

--this view shows where people, who paid by the gift card, go
CREATE VIEW gift_card_and_trips AS
    SELECT client_doc_number AS "Document", journey_to AS "A person is going to", total AS "Price"
    FROM tours
    JOIN payments p on tours.order_number = p.order_number
    WHERE p.gift_card_num IS NOT NULL;

--this view shows all employees and the trips they sold (if any)
CREATE VIEW employees_and_sales AS
    SELECT name,surname, order_number, journey_to
    FROM employees
    LEFT JOIN tours t on employees.employe_id = t.employe_id;

--this view shows sales total by year
CREATE VIEW total_sales_by_year AS
    SELECT EXTRACT (YEAR from payment_date) AS "Year", SUM(payments.total) AS "Total"
    FROM payments
    GROUP BY "Year";

--this view shows sales total by month
CREATE VIEW total_sales_by_months AS
    SELECT EXTRACT(MONTH FROM payment_date) AS "Month", SUM(payments.total) AS "Total"
    FROM payments
    GROUP BY EXTRACT(MONTH FROM payment_date)
    ORDER BY "Total" DESC;

--this view shows all employees with their contacts
CREATE VIEW allEmployees AS
    SELECT CONCAT(name_dir, ' ', surname_dir) AS "Name", 'director' AS "Position", email_dir AS "Email",
       phone_dir AS "Phone Number"
    FROM departments
    UNION
    SELECT CONCAT(name, ' ', surname) AS "Name", position AS "Position", email AS "Email",
       phone AS "Phone Number"
    FROM employees
    ORDER BY "Position";

--this view shows the reachest employees
CREATE VIEW theReachestEmployees AS
    SELECT name, surname, position, salary
    FROM employees
    WHERE salary >
        (SELECT MAX(total)
        FROM payments);

--this view shows sales before Robert Polak's employment 
CREATE VIEW salesBeforeEmployment AS
    SELECT name, surname, journey_to, payment_date
    FROM clients
    INNER JOIN tours t on clients.document_number = t.client_doc_number
    INNER JOIN payments p on t.order_number = p.order_number
    WHERE payment_date <
        (SELECT date_employment
        FROM employees
        WHERE employees.name = 'Robert' AND employees.surname = 'Polak'
        );

--procedure
--deletes the tour and all related records based on the customer's document number
CREATE OR REPLACE PROCEDURE deleteTour (document text)
     AS
    $$
    DECLARE
    this_order int;
    BEGIN
        select order_number into this_order
        from tours
        where client_doc_number = document;

        delete from payments
        where order_number = this_order;
        delete from tours
        where client_doc_number = document;
        delete from clients
        where document_number = document;
    end;
    $$ language plpgsql;

call deleteTour('985220/6056');

--function 
--returns the name of the director with the most employees
CREATE OR REPLACE FUNCTION directorHasEmployees ()
    RETURNS text AS
    $$
    DECLARE
    this_name varchar(100);
    this_count int;
    BEGIN
        select max(how_many_employees) into this_count from departments;
        select concat(name_dir, ' ', surname_dir) into this_name from departments
            where how_many_employees = this_count;
        return this_name || ' has ' || this_count || ' employees';
    end;
    $$ language plpgsql;

select directorHasEmployees();





