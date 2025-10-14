-- PART 1
-- Task 1.1
CREATE TABLE employees (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CHECK (salary > 0)
);


-- Task 1.2: Named CHECK Constraint
CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0 
        AND discount_price > 0 
        AND discount_price < regular_price
    )
);

-- Testing CHECK constraints for products_catalog
-- Valid inserts
INSERT INTO products_catalog VALUES (1, 'Laptop', 1000, 800);
INSERT INTO products_catalog VALUES (2, 'Mouse', 50, 40);

-- Invalid inserts
-- INSERT INTO products_catalog VALUES (3, 'Keyboard', -100, 80); -- Regular price violation
-- INSERT INTO products_catalog VALUES (4, 'Monitor', 300, 350); -- Discount > regular price violation

-- Task 1.3: Multiple Column CHECK
CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER CHECK (num_guests BETWEEN 1 AND 10),
    CONSTRAINT valid_dates CHECK (check_out_date > check_in_date)
);

-- Testing CHECK constraints for bookings
-- Valid inserts
INSERT INTO bookings VALUES (1, '2024-01-01', '2024-01-05', 2);
INSERT INTO bookings VALUES (2, '2024-02-01', '2024-02-03', 4);

-- Invalid inserts
-- INSERT INTO bookings VALUES (3, '2024-03-01', '2024-02-28', 3); -- Date constraint violation
-- INSERT INTO bookings VALUES (4, '2024-04-01', '2024-04-05', 15); -- Guests constraint violation

--е
----
-- PART 2: NOT NULL CONSTRAINTS


-- Task 2.1: NOT NULL Implementation
CREATE TABLE customers (
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

-- Task 2.2: Combining Constraints
CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

-- Testing NOT NULL constraints
-- Valid inserts
INSERT INTO customers VALUES (1, 'yeralim@email.com', '123-456-7890', '2024-01-01');
INSERT INTO customers VALUES (2, 'asylzhan@email.com', '123-456-7891', '2024-01-02');
INSERT INTO inventory VALUES (1, 'Widget', 100, 19.99, '2024-01-01 10:00:00');
INSERT INTO inventory VALUES (2, 'Gadget', 50, 29.99, '2024-01-01 11:00:00');

-- Invalid inserts
-- INSERT INTO customers VALUES (NULL, 'bekarys@email.com', '111-222-3333', '2024-01-02'); -- NULL customer_id
-- INSERT INTO inventory VALUES (3, NULL, 50, 9.99, '2024-01-01 11:00:00'); -- NULL item_name

----
-- PART 3: UNIQUE CONSTRAINTS


-- Task 3.1: Single Column UNIQUE
CREATE TABLE users (
    user_id INTEGER,
    username TEXT UNIQUE,
    email TEXT UNIQUE,
    created_at TIMESTAMP
);

-- Task 3.2: Multi-Column UNIQUE
CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    UNIQUE (student_id, course_code, semester)
);

-- Task 3.3: Named UNIQUE Constraints
DROP TABLE IF EXISTS users; -- Drop and recreate with named constraints
CREATE TABLE users (
    user_id INTEGER,
    username TEXT,
    email TEXT,
    created_at TIMESTAMP,
    CONSTRAINT unique_username UNIQUE (username),
    CONSTRAINT unique_email UNIQUE (email)
);

-- Testing UNIQUE constraints
INSERT INTO users VALUES (1, 'yeralim_bol', 'yeralim@email.com', NOW());
INSERT INTO users VALUES (2, 'asylzhan_zhol', 'asylzhan@email.com', NOW());
-- INSERT INTO users VALUES (3, 'yeralim_bol', 'bekarys@email.com', NOW()); -- Duplicate username violation
-- INSERT INTO users VALUES (4, 'aslanbek_ess', 'yeralim@email.com', NOW()); -- Duplicate email violation

----
-- PART 4: PRIMARY KEY CONSTRAINTS


-- Task 4.1: Single Column Primary Key
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);

-- Insert departments
INSERT INTO departments VALUES (1, 'HR', 'New York');
INSERT INTO departments VALUES (2, 'IT', 'San Francisco');
INSERT INTO departments VALUES (3, 'Finance', 'Chicago');

-- Test primary key constraints
-- INSERT INTO departments VALUES (1, 'Marketing', 'Boston'); -- Duplicate dept_id violation
-- INSERT INTO departments VALUES (NULL, 'Sales', 'Miami'); -- NULL dept_id violation

-- Task 4.2: Composite Primary Key
CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);

-- Insert sample data with our names
INSERT INTO student_courses VALUES (1, 101, '2024-01-15', 'A');
INSERT INTO student_courses VALUES (2, 102, '2024-01-16', 'B');

----
-- PART 5: FOREIGN KEY CONSTRAINTS


-- Task 5.1: Basic Foreign Key
CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id),
    hire_date DATE
);

-- Testing foreign key with our names
INSERT INTO employees_dept VALUES (1, 'yeralim bolyskhan', 1, '2023-01-15');
INSERT INTO employees_dept VALUES (2, 'asylzhan zholdybai', 2, '2023-02-20');
INSERT INTO employees_dept VALUES (3, 'bekarys zhymakhan', 1, '2023-03-10');
INSERT INTO employees_dept VALUES (4, 'aslanbek essentur', 3, '2023-04-15');
-- INSERT INTO employees_dept VALUES (5, 'test user', 99, '2023-03-10'); -- Invalid dept_id violation

-- Task 5.2: Multiple Foreign Keys
CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    publication_year INTEGER,
    isbn TEXT UNIQUE
);

-- Insert sample data with our names as authors
INSERT INTO authors VALUES (1, 'yeralim bolyskhan', 'Kazakhstan');
INSERT INTO authors VALUES (2, 'asylzhan zholdybai', 'Kazakhstan');
INSERT INTO authors VALUES (3, 'bekarys zhymakhan', 'Kazakhstan');
INSERT INTO authors VALUES (4, 'aslanbek essentur', 'Kazakhstan');
INSERT INTO publishers VALUES (1, 'Penguin Books', 'London');
INSERT INTO publishers VALUES (2, 'HarperCollins', 'New York');
INSERT INTO books VALUES (1, 'Database Design', 1, 1, 2023, '978-0439708180');
INSERT INTO books VALUES (2, 'SQL Mastery', 2, 2, 2024, '978-0451524935');
INSERT INTO books VALUES (3, 'Programming Basics', 3, 1, 2023, '978-0451524936');
INSERT INTO books VALUES (4, 'Web Development', 4, 2, 2024, '978-0451524937');

-- Task 5.3: ON DELETE Options
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk,
    quantity INTEGER CHECK (quantity > 0)
);

-- Insert test data
INSERT INTO categories VALUES (1, 'Electronics');
INSERT INTO categories VALUES (2, 'Books');
INSERT INTO products_fk VALUES (1, 'Laptop', 1);
INSERT INTO products_fk VALUES (2, 'SQL Book by yeralim', 2);
INSERT INTO orders VALUES (1, '2024-01-15');
INSERT INTO orders VALUES (2, '2024-01-16');
INSERT INTO order_items VALUES (1, 1, 1, 2);
INSERT INTO order_items VALUES (2, 2, 2, 1);

-- Test ON DELETE behaviors
-- DELETE FROM categories WHERE category_id = 1; -- Should fail due to RESTRICT
-- DELETE FROM orders WHERE order_id = 1; -- Should succeed and cascade delete order_items


----
-- PART 6: PRACTICAL APPLICATION - E-COMMERCE DATABASE

-- E-commerce Database Schema
CREATE TABLE ecommerce_customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE ecommerce_products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC CHECK (price >= 0),
    stock_quantity INTEGER CHECK (stock_quantity >= 0)
);

CREATE TABLE ecommerce_orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES ecommerce_customers,
    order_date DATE NOT NULL,
    total_amount NUMERIC CHECK (total_amount >= 0),
    status TEXT CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE ecommerce_order_details (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES ecommerce_orders ON DELETE CASCADE,
    product_id INTEGER REFERENCES ecommerce_products,
    quantity INTEGER CHECK (quantity > 0),
    unit_price NUMERIC CHECK (unit_price >= 0)
);

-- Insert sample data with our names (at least 5 records per table)
INSERT INTO ecommerce_customers VALUES 
(1, 'yeralim bolyskhan', 'yeralim@email.com', '555-0101', '2024-01-01'),
(2, 'asylzhan zholdybai', 'asylzhan@email.com', '555-0102', '2024-01-02'),
(3, 'bekarys zhymakhan', 'bekarys@email.com', '555-0103', '2024-01-03'),
(4, 'aslanbek essentur', 'aslanbek@email.com', '555-0104', '2024-01-04'),
(5, 'yeralim zholdybai', 'yeralim2@email.com', '555-0105', '2024-01-05');

INSERT INTO ecommerce_products VALUES 
(1, 'Wireless Mouse', 'Ergonomic wireless mouse', 25.99, 100),
(2, 'Mechanical Keyboard', 'RGB mechanical keyboard', 89.99, 50),
(3, 'Monitor 24"', '24 inch HD monitor', 199.99, 25),
(4, 'Laptop Stand', 'Adjustable laptop stand', 39.99, 75),
(5, 'USB-C Hub', '7-in-1 USB-C hub', 49.99, 150);

INSERT INTO ecommerce_orders VALUES 
(1, 1, '2024-01-10', 115.98, 'delivered'),
(2, 2, '2024-01-11', 289.98, 'processing'),
(3, 3, '2024-01-12', 199.99, 'shipped'),
(4, 4, '2024-01-13', 89.99, 'pending'),
(5, 5, '2024-01-14', 49.99, 'cancelled');

INSERT INTO ecommerce_order_details VALUES 
(1, 1, 1, 2, 25.99),
(2, 1, 4, 1, 39.99),
(3, 2, 2, 1, 89.99),
(4, 2, 3, 1, 199.99),
(5, 3, 3, 1, 199.99),
(6, 4, 2, 1, 89.99),
(7, 5, 5, 1, 49.99);

-- Test queries demonstrating constraints
-- Test CHECK constraint
-- INSERT INTO ecommerce_products VALUES (6, 'Test Product', 'Test', -10, 5); -- Price violation
-- INSERT INTO ecommerce_orders VALUES (6, 1, '2024-01-15', 50, 'invalid_status'); -- Status violation

-- Test UNIQUE constraint
-- INSERT INTO ecommerce_customers VALUES (6, 'Duplicate', 'yeralim@email.com', '555-0106', '2024-01-06'); -- Email violation

-- Test FOREIGN KEY constraint
-- INSERT INTO ecommerce_orders VALUES (7, 99, '2024-01-16', 100, 'pending'); -- Invalid customer_id

-- Test NOT NULL constraint
-- INSERT INTO ecommerce_customers VALUES (NULL, 'Test', 'test@email.com', '555-0107', '2024-01-07'); -- NULL customer_id

-- Display all tables with sample data
SELECT 'E-commerce Database Implementation Complete' as result;
