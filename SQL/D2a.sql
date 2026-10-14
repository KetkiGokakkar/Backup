-- DML commands : INSERT / UPDATE / DELETE 
	-- DML COMMANDS ARE NOT AUTO COMMIT SO CAN BE ROLLED BACK
	-- ONCE COMMIT ROLLBACK CANT BE DONE 
USE LTM26 ;
CREATE TABLE EMPLOYEE ( ID INT , NAME VARCHAR(10), DNO INT , SAL INT );

-- INSERT : INSERT RECORDS IN TBLE 
	-- OP1 INSERT ALL VALUES 
    INSERT INTO EMPLOYEE VALUES(1,'a',10,1000);
    SELECT * FROM EMPLOYEE;
    
    -- OP2 INSERT SPECIFIC VALUES 
    INSERT INTO EMPLOYEE(ID , NAME , SAL ) VALUE (2,'B',1000);
    
    -- OP2 INSERT MORE THAN 1 ROW @SAME TIME 
    INSERT INTO EMPLOYEE VALUES
    (3,'C',3,3000),
    (4,'D',3,4000),
    (5,'E',3,4000),
    (6,'F',3,6000);
    
-- UPDATE : UPDATES AN EXISTING REC /VALUE IN TABLE 
	-- NEVER DO UPDATE WITHOUT WHERE CLAUSE
	UPDATE EMPLOYEE SET DNO = 1 WHERE ID = 2;
    COMMIT ;
    SELECT * FROM EMPLOYEE;
    
	-- UPDATE ALL SAL 
    UPDATE EMPLOYEE SET SAL =SAL + 1000;
    
    
-- DELETE : DELETES AN EXISTING RECORDS / ROW FROM THE TABLE 
	-- NEVER DO DELETE WITHOUT WHERE CLAUSE
	DELETE FROM EMPLOYEE WHERE ID = 2 ;
    SELECT * FROM EMPLOYEE;
    
ROLLBACK; -- UNDO OPERATIONS


-- FULL TABLE DEFINATION QUERY 

SELECT 
	COLUMN_NAME , COLUMN_TYPE, IS_NULLABLE , COLUMN_DEFAULT , COLUMN_KEY,EXTRA 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'LTM26' AND TABLE_NAME='EMPLOYEE'
ORDER BY ORDINAL_POSITION;  -- MEANS THE COLUMNS POSITION IN THE TABLE 


-- CREATE A COPY OF TABLE ` 
	-- WITH RECORDS 
    CREATE TABLE EMP_COPY AS SELECT * FROM EMP;
		-- SELECTIVE COLS 
        CREATE TABLE EMP_COPY2 AS SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP ;
    
    -- WITHOUT RECORDS
	CREATE TABLE EMP_COPY1 AS SELECT * FROM EMP WHERE 1=2;
    
    
    DESC EMP_COPY;
    
    
-- WORKING WITH IMP CLAUSES OF MYSQL 
-- WHERE  / ORDER BY / DISTINCT /LIMIT/OFFSET 

-- WHERE IT IS USER TO RESTRICT THE DATA BASED ON A CONDITION (ACTS AS A FILTER )

	SELECT * FROM EMP WHERE DEPTNO =10 ;
    SELECT * FROM EMP WHERE SAL>1000;
    SELECT * FROM EMP WHERE JOB ='MANAGER';
    SELECT * FROM EMP WHERE COMM IS NULL ; 
    SELECT * FROM EMP WHERE COMM IS NOT NULL ;
    
    
-- ORDER BY : USED TO SORT DATA IN 2 DIRECTIONS --ASC/DESC (DEFAULT - ASC) 
	SELECT * FROM EMP ORDER BY DEPTNO;
    SELECT * FROM EMP ORDER BY DEPTNO ASC;
    SELECT * FROM EMP ORDER BY DEPTNO DESC;
    
-- DISTINCT :

    SELECT DISTINCT(DEPTNO) AS DIS_DEPT_NO FROM EMP ORDER BY DIS_DEPT_NO;
    
-- LIMIT / OFFSET 
	SELECT * FROM EMP ORDER BY SAL DESC LIMIT 5 ;
	SELECT * FROM EMP ORDER BY SAL DESC LIMIT 5 OFFSET 2;
	-- LIMIT ALWAYS APPEARS AT THE END OF SELECT STATEMENT 
    -- OFFSET IS OPTIONAL AND USED FOR SKIPPING ROWS 
    -- LIMIT CAN BE COMBINED WITH ORDER BY TO FETCH THE SORTED RESULTS 
    SELECT * FROM EMP ORDER BY SAL DESC LIMIT 1 OFFSET 1; -- 2ND HIGHSEST SALARY EMPLOYEE
    
    
    
-- MULTI-ROW FUNCTIONS -AGGREGATS : COUNT / SUM/ AVG / MIN / MAX /ROLL UP
-- IT ALWAYS WORKS ON MORE THAN ONE ROW AND ALWAYS GIVES U SINGLE ROW AS RESULT 
	
-- COUNT  
	SELECT COUNT(DISTINCT(DEPTNO)) AS CNT_DIS_DNO FROM EMP ;
    SELECT COUNT(COMM) AS TOT_COMM_CNT FROM EMP; -- WHEN YOU APPLY COUNT ON COL WHICH IS HAVING
    -- NULL VALUES THE NULL VALUES WILL BE DISCARDED IN COUNT 
    SELECT COUNT(*) AS TOT_NO_REC FROM EMP;
    
-- SUM / MIN/ MAX /AVG 
	SELECT SUM(SAL ) AS TOT_SAL FROM EMP ;
    SELECT 
		SUM(SAL ) AS TOT_SAL,
        MIN(SAL ) AS MIN_SAL,
        mAX(SAL ) AS MAX_SAL,
        AVG(SAL ) AS AVG_SAL
	FROM EMP;
    
    SELECT DEPTNO , SUM(SAL) AS SUM_SAL FROM EMP GROUP BY DEPTNO ORDER BY DEPTNO;
    SELECT DEPTNO , SUM(SAL) AS SUM_SAL FROM EMP GROUP BY DEPTNO WITH ROLLUP ORDER BY DEPTNO;
    
    
    
-- OPERATORS 
	-- ARITHMETIC OPERATORS : * / + -
	-- CONDITIONAL OP :  >  =   <   !=/<>
	-- LOGICAL : AND / OR / NOT
	-- WILDCARD : LIKE 
	-- RANNGE - BETWEEN 

	-- ARITH 
		SELECT EMP.* , SAL + 500 AS BONOUS FROM EMP ;
		
	-- CONDITIONAL 
		SELECT * FROM EMP WHERE DEPTNO =10 ;
		
	-- LOGICAL 
		-- AND : BOTH LHS AND RHS MUST BE TRUE 
		-- OR : EITHER LHR OR RHS MUST BE TRUE 
		-- NOT : NEGATION 
		
		SELECT * FROM EMP WHERE DEPTNO=10 AND JOB ='MANAGER';
		SELECT * FROM EMP WHERE DEPTNO=10 OR DEPTNO =20 ;
		
	-- WILDCARD 
	-- LIKE : '%' FOR 0 OR MORE CHARACTER SEQUENCE MATCHING 
		-- '_' FOR EXACT ONE CHARACTEF MATCH 
		SELECT * FROM EMP WHERE ENAME LIKE 'A%';
		SELECT * FROM EMP WHERE ENAME LIKE 'ALL__';
		SELECT * FROM EMP WHERE ENAME LIKE '%LL%';
		
-- SINGLE ROW FUNCTIONS:
	-- STRING FUNCTIONS	-- UPPER, LOWER, CONCAT,RPAD,LPAD,LTRIM,RTRIM,SUBSTRING,INSTRING
	-- NUMBER FUNCTIONS	-- SQRT,ROUND,TRUNC,CEIL,FLOOR,ABS,COALESCE,POWER
	-- DATE FUNCTIONS	-- CURRENT_DATE,CURRENT_TIMESTAMP,SYSDATE,DATADIFF,EXTRACT,DATEADD
    -- TYPE CASTING FUNCTIONS	-- TO_DATE,TO_NUMBER ...
    
-- MULTIROW FUNCTIONS : AGGREGATE FUNCTIONS
	-- SUM , MIN, MAX, AVG, COUNT WHICH WORKS WITH GROUP BY AND HAVING
    
-- WORKING WITH STRING FUNCTIONS:
-- Returns the length of a string in characters.
SELECT CHAR_LENGTH('Hello, World!') AS length;
SELECT CHAR_LENGTH(ENAME) FROM EMP;
-- Returns the ASCII value of the leftmost character of a string.
SELECT ASCII('A') AS ascii_value;   SELECT ASCII('TA') AS ascii_value;
SELECT ASCII('ZTA') AS ascii_value; SELECT ASCII('a') AS ascii_value;
-- Concatenates two or more strings.
SELECT CONCAT('Hello', '|| ', 'World!') AS concatenated_string;
-- Returns the position of the first occurrence of a substring in a string.
SELECT INSTR('Hello, World!', 'World') AS position;
-- Converts a string to lowercase.
SELECT LCASE('Hello, World!') AS lower_case_string; -- or
SELECT LOWER('Hello, World!') AS lower_case_string;
-- Converts a string to uppercase.
SELECT UCASE('Hello, World!') AS upper_case_string; -- OR
SELECT UPPER('Hello, World!') AS upper_case_string;
-- Extracts a substring from a string.
SELECT SUBSTR('Hello, World!', 8, 5) AS substring; -- OR
SELECT SUBSTRING('Hello, World!', 1, 4) AS substring;
-- Pads the right side / left side of a string with another string.
SELECT LPAD('Hello', 14, '*') AS left_padded_string; -- OR
SELECT RPAD('Hello', 10, '*') AS right_padded_string;
-- TRIM() function to remove both leading and trailing spaces.
SELECT TRIM('  Hello, World!  ') AS trimmed_string; -- DEFAULT OPTION 
SELECT TRIM(LEADING FROM "    Hello, World!    ") AS TrimmedString;
SELECT TRIM(TRAILING FROM "    Hello, World!    ") AS TrimmedString;
-- Removing specific characters
SELECT TRIM(BOTH '*' FROM '***Hello, World!***') AS trimmed_string; -- DEFAULT BOTH
SELECT LOWER(ENAME) AS LNAME, char_lengtH(ENAME) AS LEN_OF_NAME FROM EMP;    
    
-- WORKING WITH DATE FUNCTIONS:
SELECT CURDATE();
SELECT CURRENT_DATE();
SELECT CURRENT_TIME();
SELECT CURRENT_TIMESTAMP();
SELECT DATE("2023-10-25"); 
SELECT CURRENT_DATE FROM DUAL; -- DUMMY TABLE 
SELECT ADDDATE("2023-10-25", INTERVAL 10 DAY);
SELECT DATEDIFF("2025-06-25", "2023-10-25");
SELECT DATE_ADD("2023-10-25", INTERVAL 10 DAY);
SELECT DATE_FORMAT("2023-10-25", "%y"); -- 2 LETTER OF YEAR IE 26 FORM 2026 
SELECT DATE_FORMAT("2023-10-25", "%Y"); -- COMPLETE 4 LETTER YEAR
SELECT DATE_FORMAT("2023-10-25", "%m"); -- MONTH NUMBER 
SELECT DATE_FORMAT("2023-10-25", "%M"); -- MONTH IN ALPHABETIC JANUARY 
SELECT DAY("2023-10-25");
SELECT DAYNAME("2023-10-25");
SELECT DAYOFMONTH("2023-10-25");
SELECT DAYOFWEEK("2023-10-25");
SELECT DAYOFYEAR("2023-10-25");
SELECT EXTRACT(MONTH FROM "2023-10-25");
SELECT EXTRACT(WEEK FROM "2023-10-25");
SELECT EXTRACT(YEAR FROM "2023-10-25 09:34:21");
-- Examples:
-- Full Year in Numbers (YYYY):
SELECT DATE_FORMAT(NOW(), '%Y') AS FullYear;
-- Two-Digit Value for Month (MM):
SELECT DATE_FORMAT(NOW(), '%m') AS TwoDigitMonth;
-- Full Name of the Month (MONTH):
SELECT DATE_FORMAT(NOW(), '%M') AS FullMonthName;
-- Three-Letter Abbreviation of the Month (MON)
SELECT DATE_FORMAT(NOW(), '%b') AS ThreeLetterMonth;
-- Three-Letter Abbreviation of the Day of the Week (DY)
SELECT DATE_FORMAT(NOW(), '%a') AS ThreeLetterDay;
-- Full Name of the Day of the Week (DAY)
-- Numeric Day of the Month (DD)
SELECT DATE_FORMAT(NOW(), '%d') AS NumericDay;
-- Example Combined Query:
SELECT 
    DATE_FORMAT(NOW(), '%Y') AS FullYear,
    -- Spell out the year in English in the application layer
    DATE_FORMAT(NOW(), '%m') AS TwoDigitMonth,
    DATE_FORMAT(NOW(), '%M') AS FullMonthName,
    DATE_FORMAT(NOW(), '%b') AS ThreeLetterMonth,
    DATE_FORMAT(NOW(), '%a') AS ThreeLetterDay,
    DATE_FORMAT(NOW(), '%W') AS FullDayName,
    DATE_FORMAT(NOW(), '%d') AS NumericDay;

-- WORKING WITH NUMERIC FUNCTIONS:
SELECT ABS (5), ABS (-5), ABS (0), ABS (NULL) FROM DUAL; 
SELECT SQRT (2), SQRT (4), SQRT (9), SQRT (0), SQRT (NULL) FROM DUAL; 
SELECT SQRT(16) AS square_root;
SELECT FLOOR(123.456) AS floor_value;
SELECT ROUND(123.456, 2) AS rounded_number;
SELECT ROUND (123.2345), ROUND (123.2345, 2), ROUND (123.2354, 2) FROM DUAL; 
SELECT TRUNCATE (123.2345, 2), TRUNCATE (123.2354, 3) FROM DUAL; 

-- NULL HANDLING IN EMP TABLE:
SELECT * FROM EMP;
select empno,ename,sal,comm,sal + comm as bonus from emp;

select * from emp WHERE empno=7369; 
select e.*,coalesce(comm, 100) as new_comm , SAL + coalesce(comm, 100) as BONUS from emp e;
select coalesce(comm, 100) from emp WHERE empno=7369; 
SELECT empno,sal, comm, COALESCE(comm, 0) AS bonus, SAL + COMM AS TCOMM, 
sal + COALESCE(comm, 0) AS total_compensation 
from emp;
SELECT e.*,IFNULL(comm, 500) AS NEW_COMM FROM EMP e;
SELECT empno,sal, comm, COALESCE(comm, 100) AS new_comm, sal + comm as new_sal,
sal + COALESCE(comm, 0) AS total_compensation 
from emp;

-- RETURNS THE FIRST NOT-NULL VALUES FROM LIST OF EXP. ACCEPTS MULITPLE ARG.
SELECT e.*,coalesce(SAL,COMM, 200) AS NEW_SAL FROM EMP e;

-- Demo: IFNULL() with Sample Data
-- IFNULL(expression, replacement)

	-- If expression is NOT NULL, it returns the expression.
	-- If expression IS NULL, it returns the replacement.

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    phone_number VARCHAR(20)
);
INSERT INTO customers (customer_name, phone_number) VALUES
('DK', '123-456-7890'),
('AK', NULL),
('MK', '987-654-3210'),
('SK', NULL);

SELECT * FROM customers;

-- Query using IFNULL()
SELECT 
  customer_name,
  IFNULL(phone_number, 'Not Provided') AS phone_display
FROM customers;

-- User Sales with NULL amounts
CREATE TABLE user_sales (
    user_id INT,
    sales_amount DECIMAL(10,2)
);
INSERT INTO user_sales (user_id, sales_amount) VALUES
(101, 2500.00),
(102, NULL),
(103, 1800.00),
(104, NULL);

-- Query using IFNULL() to replace NULL with 0
SELECT 
  user_id,
  IFNULL(sales_amount, 0) AS adjusted_sales
FROM user_sales;


-- IFNULL(expression, replacement) with both sides as columns or expressions
CREATE TABLE customers_extended (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    phone_number VARCHAR(20),
    backup_phone VARCHAR(20)
);
INSERT INTO customers_extended (customer_id, customer_name, phone_number, backup_phone) VALUES
(1, 'JK', '123-456-7890', NULL),
(2, 'AK', NULL, '555-111-2222'),
(3, 'MK', NULL, NULL),
(4, 'SK', '888-999-0000', '777-000-1111');

SELECT * FROM customers_extended;

-- Query using IFNULL(expression, replacement) 
-- If phone_number is not null, it's returned.
-- If phone_number is null, backup_phone is returned.
-- If both are null, result is null.

SELECT 
  customer_name,
  phone_number,
  backup_phone,
  IFNULL(phone_number, backup_phone) AS preferred_contact
FROM customers_extended;

-- Query using COALESCE
-- If both are NULL, it returns the string 'Not Available'.
-- If phone_number is not NULL → use phone_number.
-- Else if backup_phone is not NULL → use backup_phone.
-- Else → use 'Not Available'.

SELECT 
  customer_name,
  phone_number,
  backup_phone,
  COALESCE(phone_number, backup_phone, 'Not Available') AS preferred_contact
FROM customers_extended;

-- Why Use This?
-- Helps handle NULL values gracefully.
-- Ensures you always display a meaningful contact method (or fallback message).
-- Useful in customer reporting or dashboards where missing phone numbers should not break the logic.

-- Demo: MySQL Type Casting
use ltimb9;

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(50),
    price_str 	VARCHAR(20),      -- Price stored as string
    launch_date_str VARCHAR(20) -- Date stored as string
);
    
INSERT INTO products (name, price_str, launch_date_str) VALUES
('Gadget A', '99.99', '2024-12-01'),
('Widget B', '149.50', '2025-01-15'),
('Device C', '75.25', '2025-03-20');

INSERT INTO products (name, price_str, launch_date_str) VALUES
('Gadget C', '12K', '2024-12-01');

SELECT * FROM products;

-- Query with Type Casting using CAST()
-- Convert price_str to DECIMAL and calculate discounted price
SELECT 
    name,price_str,
    price_str + 1000,
    CAST(price_str AS DECIMAL(10,2)) AS price,
    CAST(price_str AS DECIMAL(10,2)) * 0.9 AS discounted_price
FROM products;

-- Convert date string to DATE using CONVERT()
SELECT 
    name,launch_date_str,
    CONVERT(launch_date_str, DATE) AS launch_date
FROM products WHERE CONVERT(launch_date_str, DATE) > '2025-01-01';

-- Order by numeric price (originally stored as VARCHAR)
SELECT 
    name,price_str
FROM products
ORDER BY CAST(price_str AS DECIMAL(10,2)) DESC;

-- Implicit Type Conversion Example
-- '100' (string) will be implicitly cast to integer -- Output: 150
SELECT '100' + 50;  
SELECT '12K' + 1000;
  
-- Cast integer to string:
SELECT CAST(123 AS CHAR);
-- Cast string to decimal:
SELECT CAST('123.456' AS DECIMAL(10,2));
-- Cast datetime to date:
SELECT CAST(NOW() AS DATE);		
		
-- SET OPERATORS : UNION / UNION ALL / INTERSECT 
-- SELECT * FROM <TB1> <SET-OP> SELECT * FROM /<TB2>
CREATE TABLE EMP10 AS SELECT * FROM EMP WHERE DEPTNO =10 ;
CREATE TABLE EMP20 AS SELECT * FROM EMP WHERE DEPTNO =20 ;
CREATE TABLE EMP30 AS SELECT * FROM EMP WHERE DEPTNO =30 ;

-- UNION : NO DUPLICATES ALLOWED IN RESULT 
SELECT * FROM EMP10 UNION SELECT * FROM EMP20 ;

-- UNION ALL: DUPLICATES ALLOWED IN RESULT
CREATE TABLE EMP1020 AS SELECT * FROM EMP WHERE DEPTNO IN(10,20);
CREATE TABLE EMP2030 AS SELECT * FROM EMP WHERE DEPTNO IN(20,30);
SELECT * FROM EMP1020 UNION SELECT * FROM EMP2030;
SELECT * FROM EMP1020 UNION ALL SELECT * FROM EMP2030 ;
SELECT * FROM EMP1020 INTERSECT SELECT * FROM EMP2030;

-- DIFFERENCE : A-B 
SELECT * FROM EMP1020 WHERE DEPTNO NOT IN (SELECT DEPTNO FROM EMP2030); -- A-B
SELECT * FROM EMP2030 WHERE DEPTNO NOT IN (SELECT DEPTNO FROM EMP1020); -- B-A
