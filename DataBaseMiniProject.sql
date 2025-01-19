USE classicmodels;
-- Membuat Users--
CREATE USER 'rakhaPratamaa' IDENTIFIED BY '080605';
CREATE USER 'farajaAhdaf' IDENTIFIED BY '260905';
CREATE USER 'luthfiIriawan' IDENTIFIED BY '101204';
CREATE USER 'jiyadArsal' IDENTIFIED BY '280605';

DROP USER 'rakhaPratamaa';
DROP USER 'farajaAhdaf';
DROP USER 'luthfiIriawan';
DROP USER 'jiyadArsal';

-- Membuat Roles--
CREATE ROLE Manager;
CREATE ROLE Officer;

-- Memberikan akses kepada roles--
GRANT SELECT , INSERT ON employees TO Manager;
GRANT SELECT, UPDATE ON products TO Officer;

-- Memberikan roles pada users--
GRANT Manager TO farajaAhdaf, luthfiIriawan;
GRANT Officer TO jiyadArsal, rakhaPratamaa;

SELECT * FROM INFORMATION_SCHEMA.APPLICABLE_ROLES;
SELECT USER, HOST, ROLE FROM mysql.roles_mapping;

SELECT * FROM mysql.tables_priv WHERE User = 'Manager';
SELECT * FROM mysql.tables_priv WHERE User = 'Officer';





-- Memngaktifkan akses role--
SET ROLE Manager;   -- Untuk farajaAHdaf dan luthfiIriawan
SET ROLE Officer;   -- untuk jiyadArsal dan rakhaPratama

-- Jiyad--
CREATE VIEW data_products AS SELECT productName, productLine, productVendor FROM products;
-- Read--
GRANT SELECT ON data_products TO jiyadArsal;
SELECT * FROM data_products;
-- insert--
GRANT SELECT, INSERT ON orders TO jiyadArsal;
INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber) 
VALUES (20000, '2024-11-21', '2024-11-28', '2024-11-23', 'Shipped', 'Order delivered on time.', 450);
SELECT * FROM orders WHERE orderNumber = 20000;
-- updaate--
GRANT UPDATE (comments) ON orders TO jiyadArsal;
UPDATE orders SET comments = 'shipped' WHERE orderNumber = 10100;
SELECT orderNumber, comments FROM orders WHERE orderNumber = 10100;

-- Rakha--
-- Read dan delete--
GRANT SELECT, DELETE ON offices TO rakhaPratamaa;
SELECT * FROM offices;
SET foreign_key_checks = 0;
DELETE FROM offices WHERE city = 'Boston';
SET foreign_key_checks = 1;
-- -- Menjadikan user rakhaPratama dapat mengakses semua tabel dan bisa menambahkan atau menghapus akses ke user lain --
GRANT ALL PRIVILEGES ON *.* TO 'rakhaPratamaa' WITH GRANT OPTION;
REVOKE SELECT ON customers FROM farajaAhdaf;
-- Test user farajaAhdaf setelah dihapus akses oleh rakhaPratama terhadap select di table customers
SELECT * FROM customers;

-- Faraja--
GRANT SELECT ON customers TO farajaAhdaf;
SELECT * FROM customers;
-- Memberikan hak UPDATE pada kolom creditLimit di table customers
GRANT UPDATE (creditLimit) ON customers TO farajaAhdaf;
-- untuk test--
UPDATE customers SET creditLimit = 80000 WHERE customerNumber = 112;
SELECT customerNumber,creditLimit FROM customers WHERE customerNumber = 112;
-- Memberikan hak INSERT pada table orders --
GRANT INSERT ON customers TO farajaAhdaf;
INSERT INTO customers (customerNumber, customerName, contactLastName,contactFirstName, phone, addressLine1, addressLine2,city, state, postalCode, country,salesRepEmployeeNumber,creditLimit) 
VALUES (502,'Tech Solutions Inc.','Doe','John','123-456-7890', '123 Elm Street', 'Suite 456','New York','NY','10001','USA',1370,75000.00);
SELECT * FROM customers WHERE customerNumber = 502;

-- Luthfi--
GRANT SELECT ON payments TO luthfiIriawan;
GRANT UPDATE (checkNumber)ON payments TO luthfiIriawan;
-- untuk test
SELECT checkNumber, amount FROM payments WHERE checkNumber = 'HQ336336';
-- untuk update
UPDATE payments SET amount = 3333333 WHERE checkNumber = 'HQ336336';

GRANT DELETE, SELECT ON employees TO luthfiIriawan;
-- untuk test
SELECT * FROM employees WHERE employeeNumber = 1002;
-- untuk delete
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM employees WHERE employeeNumber = 1002;
SET FOREIGN_KEY_CHECKS = 1;




