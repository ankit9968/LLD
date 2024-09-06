-- 1. Customer Table
CREATE TABLE Customer (
    customer_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    street VARCHAR(200),
    city VARCHAR(100),
    zip_code VARCHAR(20)
);

-- 2. Order Table
CREATE TABLE `Order` (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    total_amount DECIMAL(10, 2),
    status ENUM('PENDING', 'PROCESSING', 'DISPATCHED', 'DELIVERED', 'CANCELED'),
    payment_id VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (payment_id) REFERENCES Payment(payment_id)
);

-- 3. OrderItem Table
CREATE TABLE OrderItem (
    order_item_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    item_id VARCHAR(50),
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- 4. Item Table
CREATE TABLE Item (
    item_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    quantity INT,
    price DECIMAL(10, 2)
);

-- 5. Inventory Table
CREATE TABLE Inventory (
    inventory_id VARCHAR(50) PRIMARY KEY,
    item_id VARCHAR(50),
    stock_quantity INT,
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- 6. Delivery Table
CREATE TABLE Delivery (
    delivery_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    status ENUM('ASSIGNED', 'IN_TRANSIT', 'DELIVERED'),
    delivery_person_id VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id)
);

-- 7. Payment Table
CREATE TABLE Payment (
    payment_id VARCHAR(50) PRIMARY KEY,
    method ENUM('CREDIT_CARD', 'DIGITAL_WALLET', 'CASH_ON_DELIVERY'),
    amount DECIMAL(10, 2),
    status ENUM('PENDING', 'COMPLETED', 'FAILED')
);

-- SQL Queries

-- Insert a new customer
INSERT INTO Customer (customer_id, name, email, phone, street, city, zip_code) 
VALUES ('C001', 'John Doe', 'john@example.com', '1234567890', '123 Main St', 'City', '12345');

-- Insert a new order
INSERT INTO `Order` (order_id, customer_id, total_amount, status) 
VALUES ('O001', 'C001', 50.75, 'PENDING');

-- Insert items into an order
INSERT INTO OrderItem (order_item_id, order_id, item_id, quantity, price) 
VALUES ('OI001', 'O001', 'I001', 2, 10.50), 
       ('OI002', 'O001', 'I002', 1, 29.75);

-- Check inventory availability
SELECT stock_quantity 
FROM Inventory 
WHERE item_id = 'I001';

-- Update inventory after order
UPDATE Inventory 
SET stock_quantity = stock_quantity - 2 
WHERE item_id = 'I001';

-- Update order status
UPDATE `Order` 
SET status = 'DISPATCHED' 
WHERE order_id = 'O001';

-- Assign a delivery to an order
INSERT INTO Delivery (delivery_id, order_id, status, delivery_person_id) 
VALUES ('D001', 'O001', 'ASSIGNED', 'DP001');

-- Insert a payment record
INSERT INTO Payment (payment_id, method, amount, status) 
VALUES ('P001', 'CREDIT_CARD', 50.75, 'COMPLETED');

-- Update payment status
UPDATE Payment 
SET status = 'COMPLETED' 
WHERE payment_id = 'P001';

-- Fetch customer orders
SELECT o.order_id, o.total_amount, o.status, p.method, p.status AS payment_status
FROM `Order` o
JOIN Payment p ON o.payment_id = p.payment_id
WHERE o.customer_id = 'C001';

-- Get items for an order
SELECT oi.item_id, i.name, oi.quantity, oi.price
FROM OrderItem oi
JOIN Item i ON oi.item_id = i.item_id
WHERE oi.order_id = 'O001';
