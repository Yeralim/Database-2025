	-- Part A
	CREATE DATABASE advanced_lab;

	CREATE TABLE employees (
		emp_id SERIAL PRIMARY KEY,
		first_name VARCHAR(255),
		last_name VARCHAR(255),
		department VARCHAR(255),
		salary INTEGER,
		hire_date DATE,
		status VARCHAR(20) DEFAULT 'Active'
	);

	CREATE TABLE departments (
		dept_id SERIAL PRIMARY KEY,
		dept_name VARCHAR(100),
		budget INTEGER,
		manager_id INTEGER
	);

	CREATE TABLE projects (
		project_id SERIAL PRIMARY KEY,
		project_name VARCHAR(255),
		dept_id INTEGER,
		start_date DATE,
		end_date DATE,
		budget INTEGER
	);

	-- Part B
	INSERT INTO employees (first_name, last_name, department)
	VALUES
		('Yeralim', 'Bolyskhan', 'IT'),
		('Asylzhan', 'Zholdybai', 'Robotics'),
		('Bekarys', 'Zhymakhan', 'Finance');

	INSERT INTO employees (first_name, last_name, department, salary, status)
	VALUES
		('Nurs', 'qwerty', 'Marketing', DEFAULT, DEFAULT),
		('Alex', 'asdfgh', 'Sales', NULL, DEFAULT);

	INSERT INTO departments (dept_name, budget, manager_id)
	VALUES 
		('IT', 600000, 1),
		('HR', 300000, 2),
		('Finance', 250000, 3),
		('Marketing', 350000, 4);

	INSERT INTO employees (first_name, last_name, department, salary, hire_date)
	VALUES 
		('Asik', 'Yessentur', 'IT', 500000 * 1.1, CURRENT_DATE),
		('Asyl', 'Zholdybai', 'Robotics', 400000 * 1.15, CURRENT_DATE - INTERVAL '1 day');

	CREATE TEMPORARY TABLE temp_employees AS
	SELECT * FROM employees
	WHERE department = 'IT';


	-- Part C
	UPDATE employees
	SET salary = salary * 1.10;

	UPDATE employees
	SET status = 'Senior'
	WHERE salary > 60000 and hire_date < '2020-01-01';

	UPDATE employees
	SET department = CASE
		WHEN salary > 80000 THEN 'Management'
		WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
		ELSE 'Junior'
	END;

	UPDATE employees
	SET department = DEFAULT
	WHERE status = 'Inactive';

	UPDATE departments d
	SET budget = (
		SELECT AVG(salary) * 1.20
		FROM employees e
		WHERE e.department = d.dept_name
	)
	WHERE dept_id IN (SELECT DISTINCT dept_id FROM departments);

	UPDATE employees
	SET salary = salary * 1.15,
		status = 'Promoted'
	WHERE department = 'Sales';


	-- Part D
	DELETE FROM employees
	WHERE status = 'Terminated';

	DELETE FROM employees
	WHERE salary < 40000
		AND hire_date > '2023-01-01'
		AND department IS NULL;

	DELETE FROM departments 
	WHERE dept_id NOT IN (
		SELECT DISTINCT d.dept_id 
		FROM departments d 
		JOIN employees e ON d.dept_name = e.department 
		WHERE e.department IS NOT NULL
	);

	DELETE FROM projects
	WHERE end_date < '2023-01-01'
	RETURNING *;


	-- Part E
	INSERT INTO employees (first_name, last_name, salary, department, hire_date, status)
	VALUES
		('Asyl', 'Zholdybai', NULL, NULL, CURRENT_DATE, 'Active');

	UPDATE employees
	SET department = 'Unassigned'
	WHERE department IS NULL;

	DELETE FROM employees
	WHERE salary IS NULL
		OR department IS NULL;


	--Part F
	INSERT INTO employees (first_name, last_name, department, salary, hire_date)
	VALUES
		('Beka', 'qwerty', 'IT', 75000, CURRENT_DATE)
	RETURNING emp_id,
		first_name || ' ' || last_name AS full_name;

	UPDATE employees
	SET salary = salary + 5000
		WHERE department = 'IT'
	RETURNING emp_id, 
		salary - 5000 AS old_salary,
		salary AS new_salary;

	DELETE FROM employees
	WHERE hire_date < '2020-01-01'
	RETURNING *;


	-- Part G
	INSERT INTO employees (first_name, last_name, department, salary, hire_date)
	SELECT 'Asyl', 'Zholdybai', 'IT', 70000, CURRENT_DATE
	WHERE NOT EXISTS (
		SELECT 1 FROM employees 
		WHERE first_name = 'Asyl' AND last_name = 'Zholdybai'
	);

	UPDATE employees
	SET salary = CASE
		WHEN department IN (
			SELECT dept_name FROM departments WHERE budget > 100000
		) THEN salary * 1.10
		ELSE salary * 1.05
	END;

	-- 25
	INSERT INTO employees (first_name, last_name, department, salary, hire_date)
	VALUES
		('Yeralim', 'Bolyskhan', 'IT', 95000, CURRENT_DATE),
		('Asyl', 'Zholdybai', 'Robotics', 42000, CURRENT_DATE),
		('Beka', 'Zhymakhan', 'Marketing', 68000, CURRENT_DATE),
		('Asik', 'Qwerty', 'HR', 78000, CURRENT_DATE),
		('Nurs', 'asdfg', 'Finance', 73000, CURRENT_DATE);

	UPDATE employees 
	SET salary = salary * 1.10
	WHERE first_name IN ('Yeralim', 'Asyl', 'Beka', 'Asik', 'Nurs')
	AND last_name IN ('Bolyskhan', 'Zholdybai', 'Zhymakhan', 'Qwerty', 'asdfg');

	-- 26
	CREATE TABLE employee_archive AS
	TABLE employees
	WITH NO DATA;

	INSERT INTO employee_archive
	SELECT * FROM employees
	WHERE status = 'Inactive';

	DELETE FROM employees
	WHERE status = 'Inactive';

	-- 27
	UPDATE projects p
	SET end_date = end_date + INTERVAL '30 days'
	WHERE p.budget > 50000 
	AND EXISTS (
		SELECT 1 
		FROM departments d 
		JOIN employees e ON d.dept_name = e.department 
		WHERE d.dept_id = p.dept_id 
		GROUP BY d.dept_id 
		HAVING COUNT(e.emp_id) > 3
	);