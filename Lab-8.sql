-- Part 2
-- 2.1
CREATE INDEX emp_salary_idx ON employees(salary);
--After creating the emp_salary_idx index, there will be 2 indexes in the employees table

-- 2.2
CREATE INDEX emp_dept_idx ON employees(dept_id);
--Speeds up the execution of JOIN queries between tables and speeds up the search for records using a foreign key.

-- 2.3
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
--After performing all operations, the following indexes will be created: departments_pkey, employees_pkey, emp_dept_idx, emp_salary_idx,projects_pkey
--Automatically created indexes: departments_pkey, employees_pkey, projects_pkey

-- Part 3
-- 3.1
CREATE INDEX emp_dept_salary_idx ON employees(dept_id, salary);
--No, the emp_dept_salary_idx (dept_id, salary) index will not be effectively used for the query. Because in composite indexes, the order of the columns is important.

-- 3.2
CREATE INDEX emp_salary_dept_idx ON employees(salary, dept_id);
--Yes, the order of columns in a composite index is very important.

-- Part 4
-- 4.1
CREATE UNIQUE INDEX emp_email_unique_idx ON employees(email);
--An error will be received when trying to insert a duplicate email.

-- 4.2
ALTER TABLE employees ADD COLUMN phone VARCHAR(20) UNIQUE;
--Yes, PostgreSQL automatically creates an index when a UNIQUE constraint is added. A unique B-tree index is being created


-- Part 5
-- 5.1
CREATE INDEX emp_salary_desc_idx ON employees(salary DESC);
--The emp_salary_desc_idx index (salary DESC) helps ORDER BY queries

-- 5.2
CREATE INDEX proj_budget_nulls_first_idx ON projects(budget NULLS FIRST);


-- Part 6
-- 6.1
CREATE INDEX emp_name_lower_idx ON employees(LOWER(emp_name));
--Without this index, PostgreSQL will perform a sequential table scan (seq scan) and apply the LOWER() function to each emp_name value.

-- 6.2
CREATE INDEX emp_hire_year_idx ON employees(EXTRACT(YEAR FROM hire_date));


-- Part 7
-- 7.1
ALTER INDEX emp_salary_index RENAME TO employees_salary_index;

-- 7.2
DROP INDEX emp_salary_dept_idx;
--Indexes can be deleted for the following reasons: the index is not used or rarely used, the index duplicates the functionality of another index.

-- 7.3
REINDEX INDEX employees_salary_index;


-- Part 8
-- 8.1
CREATE INDEX emp_salary_filter_idx ON employees(salary) WHERE salary > 50000;

-- 8.2
CREATE INDEX proj_high_budget_idx ON projects(budget)
WHERE budget > 80000;
-- Advantages of a partial index: smaller size, lower maintenance overhead

-- 8.3
EXPLAIN SELECT * FROM employees WHERE salary > 52000;
--If the output shows "Index Scan", it means that PostgreSQL uses the index to execute the query. If it shows "Seq Scan", it means that a full scan of the table is being performed.


-- Part 9
-- 9.1
CREATE INDEX dept_name_hash_idx ON departments USING HASH (dept_name);
--HASH index should be used instead of B-tree when only exact comparison operations are performed (=)

-- 9.2
CREATE INDEX proj_name_btree_idx ON projects(project_name);

CREATE INDEX proj_name_hash_idx ON projects USING HASH (project_name);


-- Part 10
-- 10.1
SELECT
	schemaname,
	tablename,
	indexname,
	pg_size_pretty(pg_relation_size(indexname::regclass)) as index_size
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
-- dept_name_hash_idx is the largest

-- 10.2
DROP INDEX IF EXISTS proj_name_hash_idx;

-- 10.3
CREATE VIEW index_documentation AS
SELECT
	tablename,
	indexname,
	indexdef,
	'Improves salary-based queries' as purpose
FROM pg_indexes
WHERE schemaname = 'public' AND indexname LIKE '%salary%';

SELECT * FROM index_documentation;


-- Summary Questions
-- 1. B-tree
-- 2. Columns frequently used in WHERE, foreign keys, columns used in JOIN and ORDER BY
-- 3. On small tables, on columns that are updated frequently
-- 4. Indexes must be updated, which slows down write operations.
-- 5. Using the EXPLAIN command before the request