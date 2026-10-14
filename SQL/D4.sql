-- ON DELETE CASCADE -- to delete from parent table and then child table automatically 
-- FRIEGN KEY CAN HAVE DUPLICATES AND NULL VALUES 
-- CONSTRAINTS 
	 -- USED TO ENFORCE RULES AT THE TABLE LEVEL 
	 -- ENSURE ACCURACY AND INTEGRITY 
	 -- MAXIMUM 32 

-- WORKING WITH CONSTRAINTS:
	-- In MySQL, constraints are used to enforce rules at the table level, 
	-- ensuring the accuracy and integrity of the data in a database. 

-- NOT NULL  --> Ensures that a column cannot have a NULL value.
-- UNIQUE 	 --> Ensures that all values in a column (or combination of columns) are unique across the table.
-- CHECK 	 --> Enforces a condition that each row must satisfy (available from MySQL 8.0+).
-- DEFAULT   --> Provides a default value for a column if no value is specified.
-- PRIMARY KEY --> Uniquely identifies each record in a table. It must contain unique and non-null values.
-- FOREIGN KEY --> Maintains referential integrity by ensuring the value in one table matches a value in another.

USE LTMB26;

-- NOT NULL CONS:
CREATE TABLE E_NN(ID INT NOT NULL,NAME VARCHAR(10));
INSERT INTO E_NN VALUES(1,'DINESH');
INSERT INTO E_NN1(NAME) VALUES('RAMESH');
delete from e_nn1 where name='Ramesh';
SELECT * FROM E_NN1;
-- NN ALTER CONS:
CREATE TABLE E_NN1(ID INT ,NAME VARCHAR(10));
-- ALTER FOR ADDING NOT NULL:
ALTER TABLE E_NN1 MODIFY ID INT NOT NULL; -- ADDING A CONS
ALTER TABLE E_NN1 MODIFY ID INT NULL; -- DROPPING THE CONS
ALTER TABLE E_NN1 ADD FOREIGN KEY ID REFERENCES EMP(EMPNO);
-- UNIQUE CONS:
CREATE TABLE EUNQ(ID INT UNIQUE, NAME VARCHAR(10));
INSERT INTO EUNQ VALUES(1,'DINESH');
INSERT INTO EUNQ VALUES(2,'RAMESH');

CREATE TABLE EUNQ11(ID INT, NAME VARCHAR(10));
-- ALTER TABLE <table_name> ADD CONSTRAINT constraint_name constraint_type (column_list);
ALTER TABLE EUNQ11 ADD CONSTRAINT UNQ_ID UNIQUE (ID);
-- QUERY TO HIT DD OBJECT TO CHECK THE NAME OF CONS:
select COLUMN_NAME, CONSTRAINT_NAME from information_schema.KEY_COLUMN_USAGE
where TABLE_NAME = 'E_NN1'; 
-- 'EUNQ11';
ALTER TABLE EUNQ11 DROP CONSTRAINT UNQ_ID;
INSERT INTO EUNQ11 VALUES(1,'DINESH');

-- CHECK CONS:
CREATE TABLE parts (part_no VARCHAR(18) PRIMARY KEY,description VARCHAR(40),
cost DECIMAL(10,2 ) NOT NULL CHECK (cost >= 0),
price DECIMAL(10,2) NOT NULL CHECK (price >= 0));
SELECT * FROM PARTS;
INSERT INTO parts(part_no, description,cost,price) VALUES('A-001','Cooler',100,100);
INSERT INTO parts(part_no, description,cost,price) VALUES('A-002','VDC',-10,-10);
ALTER TABLE PARTS MODIFY COLUMN DESCRIPTION VARCHAR(40) CHECK (LIKE 'des%');
-- DEFAULT CONS: -- Option-1:
CREATE TABLE EMP_DATA (ID int NOT NULL, FName varchar(25) NOT NULL,
LName varchar(25),Age int, City varchar(10) DEFAULT 'Mumbai');
    
INSERT INTO EMP_DATA (ID,FNAME,LNAME,AGE,CITY) VALUES(1,'DINESH','KARTHIK',32,'');
SELECT * FROM EMP_DATA;
INSERT INTO EMP_DATA (ID,FNAME,LNAME,AGE,CITY) VALUES(1,'DINESH','KARTHIK',32); -- error bcoz city mentioned in table insert struct
INSERT INTO EMP_DATA (ID,FNAME,LNAME,AGE,CITY) VALUES(3,'DINESH','KARTHIK',32,'NULL');-- city = 'NULL'
INSERT INTO EMP_DATA (ID,FNAME,LNAME,AGE,CITY) VALUES(4,'DINESH','KARTHIK',32,NULL); -- city = NULL 
INSERT INTO EMP_DATA (ID,FNAME,LNAME,AGE) VALUES(5,'MUKESH','KARTHIK',32); -- city = 'Mumbai'


SELECT * FROM EMP_DATA;
INSERT INTO EMP_DATA VALUES(2,'DINESH','KARTHIK',32,'CHENNAI'); -- city = 'Chennai'

-- Option-2:
CREATE TABLE EDEF (ID int NOT NULL,FName varchar(25),LName varchar(25),Age int,
	City varchar(10));
-- Adding DEFUALT CONS.
ALTER TABLE EMP_DATA ALTER City SET DEFAULT 'Sandnes';
-- DROP DEFUALT CONS.
ALTER TABLE EMP_DATA ALTER City DROP DEFAULT;

ALTER TABLE EMP_DATA MODIFY CITY VARCHAR(10) DEFAULT 'MUMBAI';

-- PRIMARY KEY -- PARENT TABLE:
CREATE TABLE PDEPT(DEPTNO INT PRIMARY KEY,DNAME VARCHAR(10));
-- FOREIGN KEY -- CHILD TABLE:
CREATE TABLE CEMP(ENO INT PRIMARY KEY, ENAME VARCHAR(10),DNO INT REFERENCES PDEPT(DEPTNO) );

-- ALTER - PRIMARY
CREATE TABLE PDEPT1(DNO INT,DNAME VARCHAR(10));
CREATE TABLE CEMP1(ENO INT PRIMARY KEY, ENAME VARCHAR(10),DEPTNO INT);
ALTER TABLE PDEPT1 ADD PRIMARY KEY(DNO);
-- ALTER FOREIGN KEY -- CHILD TABLE:
ALTER TABLE CEMP1 ADD FOREIGN KEY(DEPTNO) REFERENCES PDEPT1(DNO);


-- DATA DICTIONARY COMMANDS TO CHECK THE CONSTRAINT NAMES:
SHOW CREATE TABLE emp_child;
SHOW CREATE TABLE dept_parent;


-- PK AND FK USING GUI OPTION:
CREATE TABLE `ltmb12`.`dept_parent` (
    `DNO` INT NOT NULL,
    `DNAME` VARCHAR(45) NULL,
    PRIMARY KEY (`DNO`)
);

CREATE TABLE `ltmb12`.`emp_child` (
  `ENO` INT NOT NULL,
  `ENAME` VARCHAR(45) NULL,
  `SAL` INT NULL,
  `DNO` INT NULL,
  PRIMARY KEY (`ENO`),
  INDEX `FK_DNO_idx` (`DNO` ASC) VISIBLE,
  CONSTRAINT `FK_DNO`
    FOREIGN KEY (`DNO`)
    REFERENCES `ltmb12`.`dept_parent` (`DNO`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);
    
SELECT * FROM DEPT_PARENT;
SELECT * FROM EMP_CHILD;

INSERT INTO DEPT_PARENT VALUES(10,'HR');
INSERT INTO EMP_CHILD VALUES(100,'DK',1000,10);

INSERT INTO EMP_CHILD VALUES(101,'DK1',1000,20);
INSERT INTO DEPT_PARENT VALUES(10,'HR');

DELETE FROM DEPT_PARENT WHERE DNO = 10;

select COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_COLUMN_NAME, REFERENCED_TABLE_NAME
from information_schema.KEY_COLUMN_USAGE where TABLE_NAME = 'DEPT_PARENT';

select COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_COLUMN_NAME, REFERENCED_TABLE_NAME
from information_schema.KEY_COLUMN_USAGE where TABLE_NAME = 'EMP_CHILD';

INSERT INTO PARENT_DEPT VALUES (10,'SALES','NY');
-- INSERT INTO CHILD TABLE WITH VALUE NOT IN PARENT TABLE: -- NOT POSSIBLE -- ERROR
INSERT INTO CHID_EMP VALUES (100,'DINESH',1000,10);
INSERT INTO CHID_EMP VALUES (101,'DINESH',1000,20);
-- DELETE FROM PARENT TABLE WHEN CHILD VALUE IS THERE: -- NOT POSSIBLE -- ERROR
DELETE FROM PARENT_DEPT WHERE DEPTNO = 10;

SELECT * from information_schema.table_constraints where table_name='pt_deptno';
SELECT * from information_schema.table_constraints where table_name='cd_emp';


-- WORKING WITH DCL COMMANDS - AND PRACTICAL UNDERSTANDING:

CREATE DATABASE b13_retail_db;
USE b13_retail_db;

CREATE TABLE products (product_id INT PRIMARY KEY AUTO_INCREMENT,name VARCHAR(50),price DECIMAL(10,2));

CREATE TABLE orders (order_id INT PRIMARY KEY AUTO_INCREMENT,product_id INT,qty INT,amount DECIMAL(10,2));

INSERT INTO products(name, price) VALUES('Laptop', 60000),('Mobile', 25000);

INSERT INTO orders(product_id, qty, amount) VALUES(1, 1, 60000),(2, 2, 50000);

select * from products;
select * from orders;

-- Create Read-Only Role
CREATE ROLE 'b13_read_only_role';
-- Create Sales Manager Role
CREATE ROLE 'b13_sales_manager_role';

-- Grant Privileges to Roles -- read_only_role
GRANT SELECT ON b13_retail_db.* TO 'b13_read_only_role';

-- Grant Privileges to Roles -- sales_manager_role
GRANT SELECT ON b13_retail_db.* TO 'b13_sales_manager_role';
GRANT INSERT ON b13_retail_db.orders TO 'b13_sales_manager_role';
GRANT UPDATE ON b13_retail_db.products TO 'b13_sales_manager_role';

-- Create Users: Create a user named <any_name>--<'reader1'@'%'> who can log in from ANY IP or ANY host.
-- Else we can do: CREATE USER 'dineshkm'@'localhost' IDENTIFIED BY 'P@ssword123';
CREATE USER 'b13reader'@'%' IDENTIFIED BY 'Reader@123';
CREATE USER 'b13sales_mgr'@'%' IDENTIFIED BY 'Sales@123';

-- Assign Roles to Users:
-- Assign read_only_role → reader1
GRANT 'b13_read_only_role' TO 'b13reader'@'%';

-- Assign sales_manager_role → sales_mgr1
GRANT 'b13_sales_manager_role' TO 'b13sales_mgr'@'%';

-- Enable/Activate Role as Default
-- Reader user default role:
SET DEFAULT ROLE 'b13_read_only_role' TO 'b13reader'@'%';

-- Sales Manager default role:
SET DEFAULT ROLE 'b13_sales_manager_role' TO 'b13sales_mgr'@'%';

-- TEST Permissions:
-- Test for reader1 (Read-Only user)
SELECT * FROM products;
SELECT * FROM orders;

-- View Role Permissions
SELECT * FROM mysql.user WHERE user='b13_read_only_role' OR user='b13_sales_manager_role';

-- Show role privileges:
SHOW GRANTS FOR 'b13_read_only_role';
SHOW GRANTS FOR 'b13_sales_manager_role';

-- Show user roles:
SHOW GRANTS FOR 'reader'@'%';
SHOW GRANTS FOR 'sales_mgr'@'%';

-- Role						Permissions											Assigned To
-- b13_read_only_role		SELECT on all tables								reader
-- b13_sales_manager_role	SELECT all + INSERT(orders) + UPDATE(products)		sales_mgr


-- TEST Permissions:
use b13_retail_db;

-- Reader Allowed:
-- Test for reader1 (Read-Only user)
SELECT * FROM products;
SELECT * FROM orders;

-- Not Allowed (will show ERROR):
INSERT INTO orders(product_id, qty, amount) VALUES(1,1,60000);
UPDATE products SET price = 70000 WHERE product_id = 1;
DELETE FROM products WHERE product_id = 1;

-- Reason: reader1 only has SELECT permission via role.



-- Test for sales_mgr1 (Sales Manager role)
use b13_retail_db;

-- Allowed (SELECT on products / orders):
SELECT * FROM products;
SELECT * FROM orders;

-- Allowed (INSERT on orders):
INSERT INTO orders(product_id, qty, amount) VALUES (1, 2, 120000);

-- Allowed (UPDATE on products):
UPDATE products SET price = 65000 WHERE product_id = 1;

-- Not Allowed (no DELETE permission):
DELETE FROM products WHERE product_id = 1;
-- Not Allowed (no INSERT on products):
INSERT INTO products(name, price) VALUES('Keyboard', 1200);
-- Reason:
	-- sales_manager_role_dk does NOT have DELETE
	-- Only INSERT on `orders`, not products


/*
Window functions In MySQL:
**************************
Analytical functions in MySQL, also known as window functions, which is a 
powerful feature in SQL and data analysis which are used for performing complex calculations across a 
set of table rows related to the current row. 

These functions provide powerful capabilities for data analysis, 
including the ability to compute running totals, moving averages, ranking, and more.

Here are some reasons why window functions are used:

	Advanced Data Analysis: Window functions allow for complex calculations 
    like running totals, moving averages, cumulative sums, and 	ranking without the need for 
    self-joins or subqueries.

	Row-by-Row Computation: They perform calculations based on a specified range of rows, 
    known as a window. This means each row can be compared to other rows within the same window, 
    allowing for operations like ranking, cumulative sums, and moving averages.

	Partitioning Data: They enable calculations to be performed within partitions of data, 
    making it possible to analyze data in segments without needing to separate it into multiple queries.

	Performance: Window functions can be more efficient than equivalent operations 
    using subqueries or joins, especially for large datasets.

	Flexibility: They provide a way to perform calculations 
    both vertically (across rows) and horizontally (within rows), which can be 	difficult to 	
    achieve with traditional SQL.

	Readability and Maintainability: Queries using window functions are often more concise 
    and easier to read compared to equivalent queries using subqueries or joins.

	Ordering and Frame Specifications: They allow for specifying the order of rows and 
    defining a frame within which the window function operates, providing precise control 
    over the range of data considered for each calculation.

	Versatility: They offer a wide range of capabilities, 
    including:
		Ranking functions (RANK(), DENSE_RANK(), ROW_NUMBER()), 
		Aggregation functions (SUM(), AVG(), COUNT()) with the OVER() clause, 
		and Value functions (LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()).

	Data Windowing: They provide the ability to define specific windows of data over 
    which calculations are performed, using the ROWS or RANGE clauses. 
    
    This is essential for time-series analysis and other ordered data analyses.

Examples of Window Functions:
****************************
	Ranking Functions: ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE()
	Aggregate Functions: SUM(), AVG(), MIN(), MAX(), COUNT()
	Value Functions: LEAD(), LAG(), FIRST_VALUE(), LAST_VALUE()
*/
-- DEMO on WINDOW FUNCTIONS:
USE LTM26;
Create table employee(Id int,Name nvarchar(10), Gender nvarchar(6),Salary int,Country nvarchar(20));

Insert into employee values (1,'Mark','Male',5000,'USA'),(2,'John','Male',4500,'India'),
							(3,'Pam','Female',5500,'USA'),(4,'Sara','Female',4000,'India'),
							(5,'Todd','Male',3500,'India'),(6,'Mary','Female',5000,'UK'),
							(7,'Ben','Male',6500,'UK'),(8,'Elizabeth','Female',7000,'USA'),
							(9,'Tom','Male',5500,'UK'),(10,'Ron','Male',5000,'USA');
commit;
SELECT * FROM Employee;

/*
You can get summarization of data using GROUP BY and AGGREGATE Functions, 
but in this you loose the  original data.

If you need the summarization along with data itself, you can get 
that with the help of Window Functions. Window Functions are written with OVER CLAUSE
*/

-- Over Clause:

/* The OVER() clause in SQL is a fundamental part of window functions (also known as analytical functions). 
It defines a window or a set of rows for the window function to operate on. 

The OVER() clause allows you to specify how to partition and order 
the rows over which the window function operates.*/

-- Components of the OVER() Clause:
/*
PARTITION BY:
Divides the result set into partitions to which the window function is applied. 
-- Each partition is processed independently.

ORDER BY:
Defines the order of rows within each partition. This ordering is essential for functions that 
rely on row sequence, such as ranking functions or cumulative aggregates.

ROWS or RANGE:
Specifies a sliding window frame within the partition. This is used to define the subset of rows 
for the calculation of the window function.
*/

-- Demo Examples:
-- Get Count of Employee with Data itself

Select E.*,E.SALARY*12 AS ANNUAL_SAL from Employee E 
;
Select *,  count(*) over() as Total_Count from Employee;

-- Get avg salary of Employees with Data itself
Select *,avg(Salary) over() AvgSal,count(*) over() as Total_Count From Employee;

-- Using Partition By:
-- Get employee count country_wise
Select *, count(*) over(Partition by Country) EmployeeCountByCountry From employee;
SELECT * , COUNT(*) OVER(PARTITION BY GENDER) EMP_CNT_BY_GEN FROM EMPLOYEE;

-- Employee count and avg(Sal) by country
Select *, count(*) over(Partition by Country) EmployeeCountByCountry,
avg(salary) over(Partition by Country) AvgSalByCountry From employee;

SELECT * , avg(salary) OVER(PARTITION BY GENDER) AVG_SAL_BY_GEN FROM EMPLOYEE;

-- totalemployeecount,employee_count_by_gender
Select *,count(*) over() TotalEmployees, 
count(*) over(Partition by Gender) Employee_count_by_gender
from Employee;

-- Using Order By:
Select *, min(Salary) over() MinimumSalary from Employee;

-- get min sal and sort the data based on salary in ascending order
Select *, min(Salary) over(Order By Salary) MinimumSalary from Employee;
SELECT * , MAX(SALARY ) OVER(ORDER BY COUNTRY ) MAXSAL_CT FROM EMPLOYEE;

-- get min sal and sort the data based on Gender in Ascending + salary in Descending order
Select *, PERCENT_RANK() over(PARTITION BY GENDER ORDER BY  Salary DESC) MinimumSalary from Employee;

-- Using Combo -- Partition By and Order By:
-- PARTITION BY → creates groups.
-- ORDER BY inside OVER() → enables running/cumulative calculations.
-- Since there is an ORDER BY, SQL Server uses the default window frame:
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
Select *,
min(Salary) over(Partition by Gender Order By Salary ) MinimumSalaryByGender,
max(Salary) over(Partition by Gender Order By Salary) MaximumSalaryByGender,
min(Salary) over(Partition by Country Order By Salary) MinimumSalaryByCountry,
max(Salary) over(Partition by Country Order By Salary) MaximumSalaryByCountry
from Employee;

-- No ORDER BY → aggregate over the entire partition.
-- Then every employee in the same gender/country partition will show the same min and max values.
Select *,
min(Salary) over(Partition by Gender) MinimumSalaryByGender,
max(Salary) over(Partition by Gender) MaximumSalaryByGender,
min(Salary) over(Partition by Country) MinimumSalaryByCountry,
max(Salary) over(Partition by Country) MaximumSalaryByCountry
from Employee;


-- By Using Rows and Range (Frame Clause)

-- Default Window Frame Applied is : `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`

-- Query 1: Calculates minimum and maximum salaries up to the current row within each gender group.
Select *,
MIN(Salary) over(Partition By Gender Order By Salary) MinSalaryByGender,
MAX(Salary) over(Partition By Gender Order By Salary) MaxSalaryGender
from Employee;

-- Same Query-1 - By specifying RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
Select *,
MIN(Salary) over(Partition By Gender Order By Salary RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) MinSalaryByGender,
MAX(Salary) over(Partition By Gender Order By Salary RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) MaxSalaryGender
from Employee;

-- Query 2: Calculates the minimum salary up to the current row 
-- and the maximum salary across the entire gender group.
Select *,
MIN(Salary) over(Partition By COUNTRY Order By NAME) MinSalaryByGender,
MAX(Salary) over(Partition By COUNTRY Order By Salary RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) MaxSalaryGender
from Employee;


-- Query 3: Calculates the minimum and maximum salaries across the entire gender group for each row.
Select *,
MIN(Salary) over(Partition By Gender Order By Salary RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) MinSalaryByGender,
MAX(Salary) over(Partition By Gender Order By Salary RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) MaxSalaryGender
from Employee;

-- Key Difference:
-- RANGE: Operates on logical ranges based on the value of the ORDER BY expression. 
-- It can be affected by the presence of duplicate values. RANGE treats them as a single entity

-- ROWS: Operates on physical rows. It considers the actual rows in the result set
-- ROWS treat duplicates as distinct values.

select * from employee; 
Select *, Sum(Salary) over(Order By Salary) RunningTotalSalary From employee;	
-- Note: Row 4, 5, 6 is treated as single entity by RANGE as they have duplicate values giving wrong running total
-- Here I had not specified RANGE Clause - Because the Default Frame applied is RANGE

Select *, Sum(Salary) 
over(Order By Salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) RunningTotalSalary
From employee;


-- Categories of Window Functions:
/*
1. Aggregate Functions: AVG, SUM, COUNT, MIN, MAX etc
2. Ranking Functions: RANK, DENSE_RANK, ROW_NUMBER 
3. Analytic Functions: LEAD, LAG, FIRST_VALUE, LAST_VALUE, NTILE, CUME_DIST
*/

-- ROW_NUMBER():
Select *, ROW_NUMBER() over() rn from employee;
Select *, ROW_NUMBER() over(Order by Salary) rn from employee;
Select *, ROW_NUMBER() over(Order by Salary desc) rn from employee;
Select *, ROW_NUMBER() over(Partition By Gender) rn_countrywise from employee;
Select *, ROW_NUMBER() over(Partition By Country Order By Id) rn_countrywise from employee;

-- RANK() and DENSE_RANK():
-- RANK, DENSE_RANK: RANK Creates GAP, Dense_Rank doesn't:
Select *,ROW_NUMBER() over(order by Salary) row_no,
RANK() over(order by Salary) nrml_rnk,
DENSE_RANK() over(order by Salary) dense_rnk from employee;

Select *,ROW_NUMBER() over(Partition By Gender order by Salary) rown_0,
RANK() over(Partition By Gender order by Salary) nrml_rnk,
DENSE_RANK() over(Partition By Gender order by Salary) dense_rnk
from employee;

-- LEAD(Column_Name, Offset, Default_Value)  
-- LAG(Column_Name, Offset, Default_Value)

/* Lead: Gives next value -- Lag: Gives previous value */

Select *, LEAD(Salary) Over() NextemployeeSalary, 
LAG(Salary) Over() PreviousemployeeSalary From employee;

Select *, LEAD(Salary,2,-1) Over(Order By Id) NextToNextemployeeSalary,
LAG(Salary,2,-1) Over(Order By Id) PreviousToPreviousemployeeSalary From employee;

Select *, LEAD(Salary,2,-1) Over(Order By Id) NextToNextemployeeSalary,
LAG(Salary,2,-1) Over(Order By Id) PreviousToPreviousemployeeSalary From employee;

-- >> WORKING WITH CASE Expressions and Conditional Logic:

-- Simple CASE Expression --> Assign a label based on the job title.
SELECT ename, job,
       CASE job
            WHEN 'CLERK' THEN 'Junior Staff'
            WHEN 'MANAGER' THEN 'Management Level'
            WHEN 'ANALYST' THEN 'Senior Technical'
            WHEN 'SALESMAN' THEN 'Sales Staff'
            WHEN 'PRESIDENT' THEN 'CEO'
            ELSE 'Other Role'
       END AS job_category
FROM emp;

-- Searched CASE Expression --> Condition-based salary grade.
SELECT ename, sal,
       CASE
            WHEN sal < 1500 THEN 'Low Salary'
            WHEN sal BETWEEN 1500 AND 3000 THEN 'Medium Salary'
            WHEN sal > 3000 THEN 'High Salary'
       END AS salary_level
FROM emp;

-- Department-Wise Employee Status -- Convert deptno into department names.
SELECT ename, deptno,
       CASE deptno
            WHEN 10 THEN 'Accounts'
            WHEN 20 THEN 'Finance'
            WHEN 30 THEN 'Sales'
            WHEN 40 THEN 'Corporate'
            ELSE 'Unknown'
       END AS department_name
FROM emp;

-- Others Examples:
SELECT ename, sal,
       CASE
            WHEN sal >= 2000 THEN 'Loan Eligible'
            ELSE 'Not Eligible'
       END AS loan_status
FROM emp;

-- Calculate HRA % based on salary range.:
SELECT ename, sal,
       CASE
            WHEN sal < 1500 THEN sal * 0.10
            WHEN sal BETWEEN 1500 AND 3000 THEN sal * 0.15
            ELSE sal * 0.20
       END AS hra_amount
FROM emp;

-- Write a query to display if Salary of an employee is higher lower or 
-- equal to the previous employee
Select *,
CASE WHEN LAG(SALARY) Over() < Salary THEN 'HIGHER THAN PREVIOUS'
	 WHEN LAG(SALARY) Over() > Salary THEN 'LOWER THAN PREVIOUS' 
     WHEN LAG(SALARY) Over() = Salary THEN 'EQUAL TO PREVIOUS'
	 ELSE 'PREVIOUS employee SALARY DOES NOT EXIST' END SalaryComparison From employee;


DELIMITER //
CREATE PROCEDURE GREET()
BEGIN 
	SELECT 'HELLO WORLD';
    SELECT 'HELLO WORLD2';
END//
DELIMITER ;

CALL GREET();

DELIMITER //
CREATE PROCEDURE EMPS_INFORMATION()
BEGIN 	
	SELECT EMPNO, ENAME,DEPTNO,SAL FROM EMP ;

END // 
DELIMITER ;

CALL EMPS_INFORMATION ()

DELIMITER //
CREATE PROCEDURE EMP_INFO(IN P_EMPNO INT)
BEGIN 	
	SELECT EMPNO, ENAME,DEPTNO,SAL FROM EMP 
    WHERE EMPNO = P_EMPNO;
END // 
DELIMITER ;

CALL EMP_INFO(7369);

DELIMITER //
CREATE PROCEDURE EMP_INFO(OUT O_SAL INT)
BEGIN 	
	SELECT SAL INTO O_SAL FROM EMP 
    WHERE EMPNO = 7369;
END // 
DELIMITER ;
DROP PROCEDURE EMP_INFO;

CALL EMP_INFO(@O);
SELECT @O AS SAL ;

DELIMITER //
CREATE PROCEDURE EMP_INFO_SAL(IN IENO INT, OUT O_SAL INT)
BEGIN 	
	SELECT SAL INTO O_SAL FROM EMP 
    WHERE EMPNO = IENO;
END // 
DELIMITER ;

CALL EMP_INFO_SAL(7369,@OL);
SELECT @OL AS SAL ;


-- >> WORKING WITH FUNCTIONS: 
   
/*In MySQL, the DETERMINISTIC keyword is used to indicate that a function always 
produces the same result given the same input parameters and does not have any side effects. 
This is useful for optimization purposes because the database can assume that calling the 
function with the same parameters will always yield the same result.*/

-- SIMPLE FUNCTION:
DELIMITER &&  
CREATE FUNCTION emp_deptno_count()
RETURNS integer   
DETERMINISTIC
BEGIN 
	declare v_count integer; 
	SELECT COUNT(*) INTO v_count  FROM emp WHERE deptno = 10; 
RETURN (v_count);    
END&&  
DELIMITER ;  

-- EXECUTION OF FUNCTION:
SELECT emp_deptno_count() FROM dual; 

-- parametrized Function:
DELIMITER &&  
CREATE FUNCTION p_emp_deptno_count(dno int)
RETURNS integer   
DETERMINISTIC
BEGIN 
	declare v_count integer; 
	SELECT COUNT(*) INTO v_count  FROM emp WHERE deptno = dno; 
RETURN (v_count);    
END&&  
DELIMITER ;  

-- EXECUTION OF FUNCTION:
SELECT p_emp_deptno_count(30) FROM dual; 






-- WORKING WITH VIEWS:
	-- IS DEFINED AS "SAVED SQL STMNT" / " VIRTUAL TABLE"
    -- VIEW WILL NOT HOLD ANY DATA PERMANENTLY
    -- ONLY @ EXECUTION TIME, THE DATA IS RETRIVED FROM BASE TABLE
    -- USED FOR IMPLEMENTING DATA SECURITY / COLUMN-LEVEL SECURITY
    
-- TYPES OF VIEWS: 
	-- SIMPLE VIEW: VIEW CREATED ON ONLY ONE TABLE -- DML IS POSSIBLE
    
	-- COMPLEX VIEW: VIEW CREATED BASED ON MORE THAN 1 TABLE -- DML NOT POSSIBLE
    
    -- Updatable View: A view where you can INSERT/UPDATE/DELETE rows directly.
		-- MySQL allows update only when: 
			-- View references **one table**
			-- No GROUP BY, DISTINCT, LIMIT
			-- No aggregate functions
            -- e.g: UPDATE vw_salary_update SET SALARY = 80000 WHERE EMP_ID = 101;
	-- Non-Updatable View: A View becomes non-updatable when it has:- 
		-- GROUP BY / DISTINCT / Aggregate functions / Joins / UNION / Subqueries
		-- e.g: CREATE VIEW vw_salary_summary AS SELECT DEPT, AVG(SALARY) FROM EMP GROUP BY DEPT;
		-- UPDATE vw_salary_summary SET AVG(SALARY) = 90000; Error: View is not updatable.
        
	-- VIEW WITH CHECK OPTION: Ensures rows inserted/updated through the view must satisfy the view’s condition.
    
-- G-SYNTAX: CREATE OR REPLACE VIEW <VIEW_NAME> AS SELECT <COLUMN-NAMES> FROM <BASE_TABLE_NAME>;

-- SIMPLE VIEW:
CREATE OR REPLACE VIEW V_EMP AS SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP;
SELECT * FROM V_EMP;
CREATE OR REPLACE VIEW V_EMP AS SELECT EMPNO,ENAME,JOB,SAL,DEPTNO FROM EMP;

-- COMPLEX VIEW: - DML IS NOT POSSIBLE
CREATE VIEW V_EDJOIN AS SELECT E.EMPNO,E.ENAME,E.SAL,E.DEPTNO,D.DNAME,D.LOC FROM 
EMP E INNER JOIN DEPT D ON E.DEPTNO = D.DEPTNO;
SELECT * FROM V_EDJOIN;

CREATE VIEW V_EDJOIN11 AS SELECT D.DNAME,D.LOC,MAX(E.SAL),MIN(E.SAL),SUM(E.SAL) FROM 
EMP E INNER JOIN DEPT D ON E.DEPTNO = D.DEPTNO GROUP BY  D.DNAME,D.LOC;
SELECT * FROM V_EDJOIN11;

-- COL-LEVEL SECURITY:
CREATE VIEW V_E10 AS SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE DEPTNO = 10;
SELECT * FROM V_E10;

-- COL-LEVEL SECURITY: WITH CHECK OPTION:
CREATE VIEW V_ED10 AS SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE DEPTNO = 10 WITH CHECK OPTION;
SELECT * FROM V_ED10;
INSERT INTO V_ED10 VALUES(1000,'DINESH',1000,10);
INSERT INTO V_ED10 VALUES(1001,'SOMESH',1000,20);

SELECT * FROM EMP;
SELECT * from infor;

with dept_avg as ( select deptno, avg(sal) as avg_sal from emp group by deptno)
select * from dept_avg;
