--Dropping tables if they exist
DROP TABLE IF EXISTS departments; 
DROP TABLE IF EXISTS dept_employees;
DROP TABLE IF EXISTS dept_manager; 
DROP TABLE IF EXISTS employees; 
DROP TABLE IF EXISTS salaries; 
DROP TABLE IF EXISTS titles; 

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/fURTXn
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" VARCHAR(4)   NOT NULL,
    "dept_name" VARCHAR(100)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "titles" (
    "emp_title_id" VARCHAR(5)   NOT NULL,
    "title" VARCHAR(80)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "emp_title_id"
     )
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR(5)   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(80)   NOT NULL,
    "last_name" VARCHAR(80)   NOT NULL,
    "gender" VARCHAR(1)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR(4)   NOT NULL
);

CREATE TABLE "dept_manager" (
	"dept_no" VARCHAR(5)   NOT NULL,
    "emp_no" INT   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("emp_title_id");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

--Querying/Viewing all of the created tables wiht the imported data 
SELECT * FROM departments; 
SELECT * FROM dept_emp; 
SELECT * FROM dept_manager;
SELECT * FROM employees; 
SELECT * FROM salaries; 
SELECT * FROM titles; 

--1. List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT 
	employees.emp_no, 
	employees.last_name, 
	employees.first_name, 
	employees.gender, 
	salaries.salary
FROM salaries
INNER JOIN employees ON 
employees.emp_no = salaries.emp_no;

--2. List first name, last name, and hire date for employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1987
ORDER BY hire_date;

--3. List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, first name.

SELECT 
	dept_manager.dept_no,
	departments.dept_name, 
	employees.emp_no, 
	employees.last_name,
	employees.first_name 
FROM dept_manager 
INNER JOIN employees 
ON employees.emp_no = dept_manager.emp_no
INNER JOIN departments 
ON departments.dept_no = dept_manager.dept_no;

--4. List the department of each employee with the following information: 
--employee number, last name, first name, and department name.
SELECT 
	employees.emp_no, 
	employees.last_name, 
	employees.first_name, 
	departments.dept_name
FROM dept_emp
INNER JOIN employees
ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments 
ON departments.dept_no = dept_emp.dept_no
ORDER BY last_name; 

--5. List first name, last name, and sex 
--for employees whose first name is "Hercules" and last names begin with "B."

SELECT first_name, last_name, gender 
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'
ORDER BY last_name;
	
--6. List all employees in the Sales department, 
--including their employee number, last name, first name, and department name.
SELECT
	employees.emp_no, 
	employees.last_name, 
	employees.first_name, 
	departments.dept_name 
FROM dept_emp
INNER JOIN employees 
ON employees.emp_no = dept_emp.emp_no 
INNER JOIN  departments 
ON dept_emp.dept_no = departments.dept_no
INNER JOIN dept_manager 
ON departments.dept_no = dept_manager.dept_no
WHERE dept_name = 'Sales'
ORDER BY emp_no;

--7. List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.
SELECT 
	employees.emp_no, 
	employees.last_name, 
	employees.first_name, 
	departments.dept_name
FROM dept_emp
JOIN employees
ON employees.emp_no = dept_emp.emp_no
JOIN departments 
ON dept_emp.dept_no = departments.dept_no 
JOIN dept_manager 
ON departments.dept_no = dept_manager.dept_no
WHERE dept_name = 'Development' OR dept_name = 'Sales';

--8. In descending order, list the frequency count of employee last names, 
--i.e., how many employees share each last name.
SELECT last_name, COUNT(last_name) 
FROM employees 
GROUP BY last_name 
ORDER BY COUNT DESC;



