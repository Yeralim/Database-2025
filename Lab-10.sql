--3.1
BEGIN;
UPDATE accounts SET balance = balance - 100
	WHERE name = 'Alice';
UPDATE accounts SET balance = balance + 100
	WHERE name = 'Bob';
COMMIT;
--a) Alice: 900.00; Bob: 600.00
--b) These two UPDATES should be executed as a single unit to ensure atomicity.
--c) Without the transaction, the first UPDATE would have been saved to disk, and the second UPDATE would not have been executed. This would result in a loss of $100

--3.2
BEGIN;
UPDATE accounts SET balance = balance - 500.00
	WHERE name = 'Alice';
SELECT * FROM accounts WHERE name = 'Alice';
ROLLBACK;
SELECT * FROM accounts WHERE name = 'Alice';
--a) 400.00
--b) 900.00
--c) ROLLBACK is used for error handling, undoing user actions, maintaining data integrity, simultaneous operations, and testing.

--3.3
BEGIN;
UPDATE accounts SET balance = balance - 100.00
	WHERE name = 'Alice';
SAVEPOINT my_savepoint;
UPDATE accounts SET balance = balance + 100.00
	WHERE name = 'Bob';
ROLLBACK TO my_savepoint;
UPDATE accounts SET balance = balance + 100.00
	WHERE name = 'Wally';
COMMIT;
--a) Alice: 800.00; Bob: 600.00; Wally: 850.00
--b) Yes, Bob's balance was temporarily increased to 700.00 after the first UPDATE, however, this UPDATE was cancelled using a ROLLBACK TO
--c) Saving resources, preserving context, flexibility, complex business logic, debugging

--3.4
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM products WHERE shop = 'Joe''s Shop';

BEGIN;
DELETE FROM products WHERE shop = 'Joe''s Shop';
INSERT INTO products (shop, products, price)
	VALUES ('Joe''s Shop', 'Fanta', 3.50);
COMMIT;

SELECT * FROM products WHERE shop = 'Joe''s Shop';



BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM products WHERE shop = 'Joe''s Shop';

BEGIN;
DELETE FROM products WHERE shop = 'Joe''s Shop';
INSERT INTO products (shop, products, price)
	VALUES ('Joe''s Shop', 'Fanta', 3.50);
COMMIT;

SELECT * FROM products WHERE shop = 'Joe''s Shop';
--a) Before COMMIT Terminal 2: Terminal 1 sees the source data: Coke (2.50) and Pepsi (3.00)
--After COMMIT Terminal 2: Terminal 1 sees new data: Fanta only (3.50)
--b) In SERIALIZABLE mode, Terminal 1 sees the same data in both SELECT
--c) READ COMMITTED: Allows you to see the changes of other transactions immediately after their COMMIT.
--	 SERIALIZABLE: Ensures that all SELECTS in a transaction see the same data. Other transactions cannot change this data until the current transaction is completed.


--3.5
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT MAX(price), MIN(price) FROM products
WHERE shop = 'Joe''s Shop';

BEGIN;
INSERT INTO products (shop, product, price)
 VALUES ('Joe''s Shop', 'Sprite', 4.00);
COMMIT;

SELECT MAX(price), MIN(price) FROM products
 WHERE shop = 'Joe''s Shop';
COMMIT;
--a) No, Terminal 1 does not see the new Sprite product, even after Terminal 2 has committed the changes. In REPEATABLE READ mode, a transaction sees only the data that existed at the time it started.
--b) A phantom read is a situation where, within a single transaction, repeated execution of the same query returns a different number of rows.
--c) Only the SERIALIZABLE isolation level completely prevents phantom reads.


--3.6
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM products WHERE shop = 'Joe''s Shop';

BEGIN;
UPDATE products SET price = 99.99
    WHERE product = 'Fanta';

SELECT * FROM products WHERE shop = 'Joe''s Shop';

ROLLBACK;

SELECT * FROM products WHERE shop = 'Joe''s Shop';
COMMIT;
--a) Yes, Terminal 1 saw the price of 99.99 in its second SELECT. This is problematic because it breaks the consistency of the data.
--b) Dirty read is the reading of uncommitted data from another transaction.
--c) Consistency issues, unpredictability, and debugging difficulties


--ex 4.1
BEGIN;

-- Check Bob's balance
SELECT balance FROM accounts WHERE name = 'Bob';

-- Only transfer if Bob has enough money
UPDATE accounts
SET balance = balance - 200
WHERE name = 'Bob'
  AND balance >= 200;
IF FOUND THEN
    UPDATE accounts
    SET balance = balance + 200
    WHERE name = 'Wally';
ELSE
    ROLLBACK;
    RAISE NOTICE 'Transfer failed: insufficient funds';
    RETURN;
END IF;

COMMIT;

--4.2
BEGIN;

-- Insert new product
INSERT INTO products (shop, product, price)
VALUES ('Joe''s Shop', 'TestProduct', 5.00);

SAVEPOINT sp1;

-- Update price
UPDATE products
SET price = 7.00
WHERE product = 'TestProduct';

SAVEPOINT sp2;

-- Delete product
DELETE FROM products
WHERE product = 'TestProduct';

-- Roll back to first savepoint (sp1)
ROLLBACK TO sp1;

COMMIT;

-- Check final state
SELECT * FROM products WHERE product = 'TestProduct';

--4.3
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT balance FROM accounts WHERE name = 'Alice';

UPDATE accounts
SET balance = balance - 300
WHERE name = 'Alice';

-- Wait…
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT balance FROM accounts WHERE name = 'Alice';

UPDATE accounts
SET balance = balance - 300
WHERE name = 'Alice';

COMMIT;

--4.4
SELECT MAX(price) FROM sells WHERE shop='Joe''s Shop';
-- Joe changes price here
SELECT MIN(price) FROM sells WHERE shop='Joe''s Shop';

BEGIN;

SELECT MAX(price), MIN(price)
FROM sells
WHERE shop='Joe''s Shop';

COMMIT;


-- Questions for Self-Assessment
--1
-- Atomic: either full transfer or none
-- Consistent: constraints stay valid
-- Isolated: concurrent users don’t interfere
-- Durable: committed data survives crash
--2
-- COMMIT = save changes; ROLLBACK = undo
--3
-- SAVEPOINT = partial rollback inside transaction
--4
-- Read uncommitted – dirty reads allowed
-- Read committed – no dirty reads
-- Repeatable read – no non-repeatable reads
-- Serializable – no phantoms
--5
-- Dirty read = uncommitted read; allowed in READ UNCOMMITTED
--6
-- Non-repeatable read → same row read twice → values differ
-- 7
-- Phantom read = new rows appear; prevented only in SERIALIZABLE
-- 8
-- READ COMMITTED is faster; SERIALIZABLE is slow
-- 9
-- Transactions prevent race conditions & inconsistent updates
-- 10
-- Uncommitted data is lost on crash