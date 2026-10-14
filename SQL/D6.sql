-- W2 D1 

-- MY SQL USE FILESORT FOR SORTING BY DEFAULT 
-- AFTER INDEX NO FILESORT 
-- USE EXPLAIN TO SEE QUERY PERFORMANCE 
-- ATTRIBUTE :
	-- TYPE - ALL MEANS ENTIRE TABLE IS SCANNED
    -- KEY : ON WHICH KEY INDEX IS BEING USED
    -- ROWS - ROWS SCANNED 
    -- INDEX USED - INDEX NAME USED 


-- Indexes 
	-- FASTER RETRIVAL OF DATA FASTER THAN SCANNING ENTURE TABLE 
	-- CREATED ON TOP OF COLUMN
    -- USE B-TREE(BALANCED TREE) FOR RANGE AND EQUALITY LOOKUPS 
    -- INDEXES TRADE READ PERFORMANCE FOR EXTRA STORAGE AND SLOWER WRITES (INSERT/UPDATE/DELETE)
    
	-- TYPES 
		-- 1 UNIQUE : ANY COL MARKED WITH UNQ - WITH NOT ALLOW DUP INCLUDING FOR INSERT 
        -- 2 NON-UNIQUE
        
	-- An index is a data structure that lets MySQL find rows faster than scanning the entire table. 
	-- Most common index type uses a B-Tree (balanced tree) for range and equality lookups. 
	-- Indexes trade read performance for extra storage and slower writes (INSERT/UPDATE/DELETE).
	
    
	-- SUMMARY for Indexes for (All Optimizations):

	-- Scenario		Before				After				Benefit
	-- ORDER BY		Filesort, slow		Sorted via index	No sort, faster
	-- JOIN			Full scan on EMP	Index lookup		Join cost drops 10x
	-- WHERE Filter	Full table scan		Range lookup		Reads minimal rows
	
    -- POINTD TO BE NOTED :
		-- ALWASE USE EXPLAIN TO SEE HOW MYSQL EXECUTES QUERIES 
        -- ADD INDEXED ON COLUMNS USED IN :
			-- WHERE / JOIN / ORDER BY / GROUP BY 
		-- TOO MANY INDEXED ALSO SLOW INSERT / UPDATE , 
        -- SO BALANCE WISELY
        -- OPTIMIZATION = RIGHT INDEX + RIGHT QUERY DESIGN 
        
        
-- DEMOS on INDEXES: BEFORE and AFTER:
-- UNIQUE / NON-UNIQUE : ANY COL MARKED WITH UNQ - WILL NOT ALLOW DUP
SHOW INDEX FROM  EMPL_IDX;
CREATE TABLE EMPL_IDX AS SELECT * FROM EMP;
SELECT * FROM EMPL_IDX;
EXPLAIN SELECT * FROM EMPL_IDX;
set profiling =1 ;
SELECT * FROM EMPL_IDX WHERE DEPTNO = 10;
show profile ;
EXPLAIN SELECT * FROM EMPL_IDX WHERE DEPTNO = 10;

-- INDEX CREATION: AFTER:
CREATE INDEX NUIDX_DEPTNO ON EMPL_IDX(DEPTNO); 
EXPLAIN SELECT * FROM EMPL_IDX WHERE DEPTNO = 10;

CREATE TABLE EMP_IDX_CP AS SELECT * FROM EMP WHERE 1=2;
SELECT * FROM EMP_IDX WHERE DEPTNO = 10;
SELECT * FROM EMP_IDX_CP;
EXPLAIN SELECT * FROM EMP_IDX WHERE DEPTNO = 10 AND SAL > 2500;

-- Meaning:
-- type = ALL → Full Table Scan
-- rows = 100 → MySQL checks almost every row
-- key = NULL → No useful index

CREATE INDEX idx_emp_dept_salary ON EMP_IDX(DEPTNO, SAL);
ANALYZE TABLE EMP_IDX;
DESC EMP_IDX;

EXPLAIN SELECT * FROM EMP_IDX WHERE DEPTNO = 10 AND SAL > 1500;
-- Meaning:
-- type = range → Uses index for filtering
-- key = idx_emp_dept_salary → index is being used
-- rows = 3 → Only scans needed rows
-- Extra = Using index condition → Good performance

-- BEFORE vs AFTER (Clear Comparison):
-- Feature			Before Index			After Index
-- Access 			Type ALL (Full scan)	range (Index scan)
-- Rows Scanned		~100					~3
-- Index Used		none					idx_emp_dept_salary
-- Performance		❌ Slow					✅ Fast

-- ORDER BY Optimization Example
CREATE TABLE EMP_SORT AS SELECT * FROM EMP;
SELECT * FROM EMP_SORT WHERE DEPTNO = 10 ORDER BY SAL DESC LIMIT 5;
-- BEFORE INDEX — MySQL Does Filesort
EXPLAIN SELECT * FROM EMP_SORT WHERE DEPTNO = 10 ORDER BY SAL DESC LIMIT 5;
-- Problems:
-- Full table scan
-- MySQL sorts the rows manually → slow on large tables
CREATE INDEX idx_emp_dept_salary ON EMP_SORT(DEPTNO, SAL); 
ANALYZE TABLE EMP_COPY;

-- AFTER INDEX — No Filesort Needed
EXPLAIN SELECT * FROM EMP_SORT WHERE DEPTNO = 10 ORDER BY SAL DESC LIMIT 5;
-- Benefits:
-- MySQL reads rows directly in sorted order
-- No filesort
-- Only scans few rows

-- JOIN Optimization Example: BEFORE INDEX — JOIN Uses Full Scan
SELECT E.ENAME, E.SAL, D.DEPTNO,D.DNAME,D.LOC FROM EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO;
-- RUN EXPLAIN:
EXPLAIN SELECT E.ENAME, E.SAL, D.DEPTNO,D.DNAME,D.LOC FROM EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO;

-- EMP table is fully scanned because DEPT column is not indexed.
-- table: EMP
-- type: ALL
-- key: NULL
-- rows: 100

-- table: DEPT
-- type: ref
-- key: PRIMARY

-- CREATE INDEX to Optimize JOIN
CREATE INDEX idx_emp_dept ON EMP(DEPTNO);
ANALYZE TABLE EMP;

-- AFTER INDEX — Efficient Index Lookup
EXPLAIN SELECT E.ENAME, E.SAL, D.DEPTNO,D.DNAME,D.LOC FROM EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO;
-- Benefits:
-- EMP join becomes index-based
-- Only matching rows scanned
-- Join becomes much faster

-- table: EMP
-- type: ref
-- key: idx_emp_dept
-- rows: 10

-- table: DEPT
-- type: ref
-- key: PRIMARY

-- UNIQUE INDEX:
CREATE TABLE DEPT_UIDX AS SELECT * FROM DEPT;
SELECT * FROM DEPT_UIDX;

CREATE UNIQUE INDEX UNQ_IDX_DNO ON DEPT_UIDX(DEPTNO);
SELECT * FROM DEPT_UIDX WHERE DEPTNO = 10;
EXPLAIN SELECT * FROM DEPT_UIDX WHERE DEPTNO = 10;

INSERT INTO DEPT_UIDX VALUES (10,'HR','USA');

-- Query Optimization and Execution Plans:

-- What is Query Optimization?
-- When you write SQL, the database has to figure out the fastest way to run it.
-- The Query Optimizer is like a GPS that finds the shortest route to get results.
-- Even if two SQL queries look different, the optimizer decides which route (plan) is most efficient.

-- Query Optimization means improving SQL query performance — 
-- so MySQL executes it faster and uses fewer resources (CPU, I/O, memory).

-- MySQL’s Query Optimizer decides the best way to access data — 
-- whether to use indexes, table scans, joins, etc.

-- Execution Plan (or EXPLAIN PLAN):
-- An Execution Plan shows how the database executes your SQL — which indexes it uses, 
-- how it joins tables, and the cost of each step..

 -- E.g:Think of it like seeing your Google Maps route before you start driving.
 # What Is an Execution Plan?

-- An Execution Plan shows how MySQL executes your SQL:
-- 	- Which indexes are used
-- 	- How many rows are scanned
-- 	- What type of join is used
-- 	- Whether a full table scan happens
CREATE TABLE EMPCP AS SELECT * FROM EMP WHERE 1=2;
INSERT INTO EMPCP VALUES ( SELECT * FROM EMP );	
-- Temporary Tables and Clustering:

-- Temporary Tables:
	-- A Temporary Table is a short-term table created by a user or session that exists 
	-- only during that session or transaction. (Exists only for your current session)
    -- Is automatically dropped when your session ends or when you manually drop it
	-- It’s like using a scratchpad — you can store intermediate results, 
	-- perform calculations, then throw it away.
    -- Is perfect for storing intermediate results that you want to 
    -- reuse in multiple steps of a complex query

CREATE TABLE Sales (
    Sale_ID INT AUTO_INCREMENT PRIMARY KEY,
    Region VARCHAR(50),
    Sales_Amount DECIMAL(10,2),
    Sale_Date DATE
);

INSERT INTO Sales (Region, Sales_Amount, Sale_Date) VALUES
('North',   1200.50, '2023-01-10'),
('South',   850.00,  '2023-01-12'),
('East',    430.75,  '2023-01-14'),
('West',    999.00,  '2023-01-15'),
('North',   540.00,  '2023-01-20'),
('South',   780.25,  '2023-01-21'),
('East',    1200.00, '2023-01-22'),
('West',    650.00,  '2023-01-23'),
('North',   300.00,  '2023-02-01'),
('South',   1500.00, '2023-02-03'),
('East',    900.50,  '2023-02-04'),
('West',    2200.75, '2023-02-05'),

-- Extra rows for more realistic totals
('North',   1500.25, '2023-02-10'),
('South',   620.00,  '2023-02-11'),
('East',    450.00,  '2023-02-12'),
('West',    300.00,  '2023-02-13');


CREATE TEMPORARY TABLE temp_sales AS
SELECT Region, SUM(Sales_Amount) AS TotalSales
FROM Sales
GROUP BY Region;

SELECT * FROM temp_sales;
-- table automatically disappears when session ends

-- When to Use Temporary Tables:
	-- 	>> Need intermediate calculations in complex queries
	-- 	>> Want to reduce repeated subquery execution
	--  >> Perform data transformations before final insert/update

-- Example-2:

CREATE TABLE Qproducts (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT
);

INSERT INTO Qproducts (product_name, category, price, stock) VALUES
('Smartphone A10',          'Electronics', 550.00,  40),
('Laptop Pro 15',           'Electronics', 1200.00, 20),
('Bluetooth Speaker X2',    'Electronics', 150.00,  60),
('LED TV 42 inch',          'Electronics', 750.00,  15),

('Men T-Shirt Cotton',      'Clothing',    25.00,   200),
('Women Jeans Blue',        'Clothing',    45.00,   120),
('Sports Jacket Nylon',     'Clothing',    80.00,   75),

('Rice (5kg pack)',         'Grocery',     12.50,   500),
('Olive Oil (1L Bottle)',   'Grocery',     8.99,    350),
('Breakfast Cereal Box',    'Grocery',     4.50,    700),

('Novel - The Great Story', 'Books',       15.00,   150),
('Programming in Python',   'Books',       35.00,   90),
('Business Strategies 101', 'Books',       28.00,   110),

('Toy Car Speedster',       'Toys',        20.00,   300),
('Puzzle 1000-Piece',       'Toys',        18.00,   250),
('Soft Teddy Bear',         'Toys',        30.00,   180);

CREATE TEMPORARY TABLE temp_category_sales (
    category VARCHAR(50),
    avg_price DECIMAL(10,2),
    total_stock INT
);

INSERT INTO temp_category_sales
SELECT
    category,
    AVG(price),
    SUM(stock)
FROM Qproducts
GROUP BY category;

CREATE TEMPORARY TABLE temp_category_sales1 AS
SELECT
    category,
    CAST(AVG(price) AS DECIMAL(10,2)) AS avg_price,
    SUM(stock) AS total_stock
FROM Qproducts
GROUP BY category;

SELECT * FROM temp_category_sales;

-- Get only categories with total stock above 5000
SELECT * FROM temp_category_sales1 WHERE total_stock > 500;

-- Find the category with the highest average price
SELECT category, avg_price FROM temp_category_sales1 ORDER BY avg_price DESC LIMIT 1;

-- Use results in another insert (final reporting table)
CREATE TABLE final_category_report (
    category VARCHAR(50),
    avg_price DECIMAL(10,2),
    total_stock INT,
    report_date DATE
);

INSERT INTO final_category_report (category, avg_price, total_stock, report_date)
SELECT category, avg_price, total_stock, CURDATE()
FROM temp_category_sales;

SELECT * FROM final_category_report;

-- After successfull transformation, filteration, and once u store the data efficiently we can Drop
SELECT * FROM final_category_report;

-- Drop the temporary table (optional):
DROP TEMPORARY TABLE IF EXISTS temp_category_sales;

-- Benefits of Temp Table:
	-- Benefit				Explanation
	-- Reusability			Use the same summarized data multiple times
	-- Performance			Avoid recalculating expensive aggregations
	-- Isolation			Each user/session gets its own version of the temp table
	-- Transformation		Great for step-by-step ETL or data prep

-- Use Temporary Tables when:
	-- >> Query is too complex to handle in a single SQL
	-- >> You need to reuse partial results multiple times
	-- >> You are doing intermediate calculations or transformations 
    
-- What is Clustering?

	-- Clustering is a way of storing related rows together on disk — to improve query performance.
	-- Think of it like keeping all students from the same class in the 
	-- same folder rather than scattered across different places.
    
-- MySQL Clustering Concept:

-- MySQL doesn’t have Oracle-style clusters, but it supports:
	-- >> Clustered Indexes in InnoDB
    -- 	→ The table’s primary key defines physical storage order.
    
-- Data is physically organized by emp_id.
-- Secondary indexes store primary key pointers — improving lookup speed.

-- The data rows are physically stored in the order of their Primary Key.
-- This is called a Clustered Index.

-- So:
	-- 	>> Every InnoDB table is automatically clustered by its PRIMARY KEY.
	-- 	>> The PRIMARY KEY index and the data are stored together.
	-- 	>> There can be only one clustered index per table.
	--  >> Other indexes (non-primary indexes) are called secondary indexes, 
    -- 	>> which point back to the clustered index.

USE QOPTIMEXP;
    
CREATE TABLE employees1 (
    emp_id INT PRIMARY KEY,         -- This is the clustered index
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2)
) ENGINE=InnoDB;

-- What Happens Internally:
	-- MySQL automatically creates a clustered index on `emp_id`.
	-- Rows are physically stored sorted by emp_id.

-- Insert Data in Random Order
INSERT INTO employees1 VALUES
(103, 'AK', 'HR', 40000),
(101, 'BK', 'IT', 55000),
(105, 'CK', 'Finance', 60000),
(102, 'DK', 'IT', 45000),
(104, 'EK', 'Sales', 50000);

-- Now Check Physical Order (Clustered by PRIMARY KEY):
SELECT * FROM employees1;
-- Even though you inserted records randomly,  
-- The data is physically clustered and stored in emp_id order.

-- Add a Secondary Index
CREATE INDEX idx_department ON employees1(department);

-- Now if you search by `department`, MySQL uses:
	-- - The secondary index (idx_department) to find department values
	-- - Then goes back to the clustered index (emp_id) to fetch full row data

EXPLAIN SELECT * FROM employees1 WHERE department = 'IT';

-- SIMPLE	employees		ref	idx_department	idx_department	203	const	2	100.00	

-- This shows MySQL is using your non-clustered index (department)
-- and then internally jumping to the clustered index to fetch the actual rows.

-- Notes:
	-- Index Type					What It Stores					Data Lookup Path
	-- Clustered Index (PRIMARY)	Key + Row Data					Direct access (fast)
	-- Secondary Index				Key + Clustered Key				Lookup via Clustered Key

-- Now View the Execution Path:
EXPLAIN FORMAT=JSON SELECT * FROM employees1 WHERE department = 'IT';


-- COMMON TABLE EXPRESSIONS
	
-- What is a CTE (Common Table Expression)?

-- A CTE (Common Table Expression) is like a temporary named result set (virtual table) that you can use within a single SQL query.

-- “A short-term, reusable view created inside your SQL query — that disappears once your query finishes.”

/*
It helps you:
- Make long SQL queries easier to read and maintain
- Reuse complex logic or subqueries
- Break down big problems into smaller steps
*/

-- CTE Syntax (Generic Form):
WITH cte_name AS ( 
-- your SQL query here
) SELECT * FROM cte_name ;

-- You can even have multiple CTEs separated by commas.
WITH cte1 AS (...),
     cte2 AS (...)
SELECT ...
FROM cte1 JOIN cte2 ON ...


-- Example 1: Simple CTE – Filter & Reuse:
CREATE TABLE EMP AS SELECT * FROM emp;
CREATE TABLE DEPT AS SELECT * FROM DEPT;

-- Find all employees with a salary above 2000, then show their department names.
WITH HighSalary AS (SELECT EMPNO, ENAME, SAL, DEPTNO FROM EMP WHERE SAL > 2000)
SELECT H.ENAME, H.SAL, D.DNAME
FROM HighSalary H
JOIN DEPT D ON H.DEPTNO = D.DEPTNO;

-- Notes:
-- - Step 1: CTE `HighSalary` selects employees whose salary > 2000.
-- - Step 2: The main query joins that temporary list with DEPT to show department names.
-- - After the query runs, **HighSalary** disappears automatically.

-- Example 2: Multiple CTEs – Chain Logic:
-- Find each department’s average salary, and list employees earning more than that department’s average.
WITH DeptAvg AS (
    SELECT DEPTNO, AVG(SAL) AS AVG_SAL
    FROM EMP
    GROUP BY DEPTNO
),
EmpWithDept AS (
    SELECT E.ENAME, E.SAL, E.DEPTNO, D.AVG_SAL
    FROM EMP E
    JOIN DeptAvg D ON E.DEPTNO = D.DEPTNO
)
SELECT ENAME, SAL, DEPTNO, AVG_SAL
FROM EmpWithDept
WHERE SAL > AVG_SAL;

WITH CTE_EMP AS ( SELECT AVG(SAL) AS AVG_SAL , DEPTNO FROM EMP GROUP BY DEPTNO ),
CTE_FIN AS( SELECT E.EMPNO ,E.SAL , C.AVG_SAL , E.DEPTNO FROM EMP E JOIN CTE_EMP C ON E.DEPTNO = C.DEPTNO 
WHERE E.SAL > C.AVG_SAL)
SELECT * FROM CTE_FIN ;
-- Notes:
-- - `DeptAvg`: finds each department’s average salary
-- - `EmpWithDept`: joins that result with employee data
-- - Final SELECT: filters employees above average salary in their department
--   This is much cleaner than writing nested subqueries!

-- Additional Examples - Performance using EXPLAIN: With and WithOut

-- Without CTE — Using Nested Subquery
EXPLAIN
SELECT e.ename, e.sal, d.dname
FROM emp e
JOIN dept d ON e.deptno = d.deptno
WHERE e.sal > (
    SELECT AVG(sal)
    FROM emp
    WHERE deptno = e.deptno
);

-- --Interpretation:
-- - The subquery runs once for each employee (correlated subquery).
-- - MySQL must repeatedly scan the employees table to compute `AVG(salary)` for each department.
-- - So, for 5 employees → 5 subquery scans = inefficient when data grows.

-- With CTE — Simplified Query:
EXPLAIN
WITH DeptAvg AS (
    SELECT deptno, AVG(sal) AS avg_sal
    FROM emp
    GROUP BY deptno
)
SELECT e.ename, e.sal, d.dname
FROM emp e
JOIN DeptAvg da ON e.deptno = da.deptno
JOIN dept d ON e.deptno = d.deptno
WHERE e.sal > da.avg_sal;

-- Interpretation:
-- - The CTE (DeptAvg) runs once, grouped by department.
-- - MySQL “materializes” it (creates a temporary result set in memory).
-- - Then the main query simply joins to that small 3-row result.
-- - Faster because we replaced multiple subquery scans with one grouped precomputation.

-- CTE Vs. Subquery:
-- Concept			CTE												Subquery
-- Readability		Easier, named query								Harder to read if nested
-- Reusability		Can be reused multiple times in same query		Cannot be reused
-- Performance		Usually same as subquery (depends on DB engine)	Same
-- Maintenance		Easier to modify								Harder to debug

-- When to Use a CTE: When your query has:
	-- 	- Repeated subqueries
	-- 	- Step-by-step calculations
	-- 	- Need for recursive logic
	-- 	- Complex joins that you want to simplify

-- Business Scenario: for CTE:

CREATE TABLE SalesCS (
    Sale_ID INT AUTO_INCREMENT PRIMARY KEY,
    Region VARCHAR(50),
    Customer_ID INT,
    Sales_Amount DECIMAL(10,2),
    Sale_Date DATE
);

INSERT INTO SalesCS (Region, Customer_ID, Sales_Amount, Sale_Date) VALUES
-- NORTH Region
('North', 101, 1200.00, '2023-01-10'),
('North', 101, 800.00, '2023-01-15'),
('North', 102, 400.00, '2023-01-12'),
('North', 102, 700.00, '2023-01-25'),
('North', 103, 1500.00, '2023-01-28'),
('North', 104, 300.00, '2023-01-20'),

-- SOUTH Region
('South', 201, 900.00, '2023-02-01'),
('South', 201, 750.00, '2023-02-05'),
('South', 202, 600.00, '2023-02-10'),
('South', 202, 500.00, '2023-02-15'),
('South', 203, 1500.00, '2023-02-20'),
('South', 204, 300.00, '2023-02-22'),

-- EAST Region
('East', 301, 400.00, '2023-03-01'),
('East', 301, 600.00, '2023-03-05'),
('East', 302, 1000.00, '2023-03-08'),
('East', 303, 800.00, '2023-03-12'),
('East', 303, 900.00, '2023-03-18'),
('East', 304, 250.00, '2023-03-20'),

-- WEST Region
('West', 401, 700.00, '2023-04-01'),
('West', 401, 900.00, '2023-04-04'),
('West', 402, 1200.00, '2023-04-07'),
('West', 403, 500.00, '2023-04-10'),
('West', 403, 300.00, '2023-04-15'),
('West', 404, 150.00, '2023-04-18');


-- CTE Query for CustomerSales - Finds Top 3 Customers per Region wise Sales:
WITH CustomerSales AS (
    SELECT
        Region,
        Customer_ID,
        SUM(Sales_Amount) AS Total_Sales,
        ROW_NUMBER() OVER (PARTITION BY Region ORDER BY SUM(Sales_Amount) DESC) AS RankNo
    FROM SalesCS
    GROUP BY Region, Customer_ID
)
SELECT Region, Customer_ID, Total_Sales
FROM CustomerSales
WHERE RankNo <= 3
ORDER BY Region, Total_Sales DESC;

-- Recursive CTEs: What are they?

-- Recursive CTEs are CTEs that refer to themselves — perfect for hierarchical data 
-- (like org charts, category trees, etc.)

-- You define:
	-- 1. Anchor member – the starting point (like root)
	-- 2. Recursive member – repeatedly joins the CTE to itself

-- Example 1: Recursive CTE – Manager Hierarchy (MySQL 8+):

	-- CTEs can also be recursive, meaning they refer to themselves.
	-- Find the employee-manager hierarchy, starting from the top (KING).

WITH RECURSIVE EmpHierarchy AS (
    -- Anchor: start with top-level manager
    SELECT EMPNO, ENAME, MGR, 1 AS LEVEL
    FROM EMP
    WHERE MGR IS NULL

    UNION ALL

    -- Recursive part: get employees who report to the previous level
    SELECT E.EMPNO, E.ENAME, E.MGR, EH.LEVEL + 1
    FROM EMP E
    JOIN EmpHierarchy EH ON E.MGR = EH.EMPNO
)
SELECT * FROM EmpHierarchy;

-- Notes:
-- - The first part finds KING (no manager).
-- - The second part recursively finds everyone reporting to someone above.
-- - It keeps expanding until no more employees remain.

-- Anchor Member: The first query selects the root of the hierarchy—the top-level boss(es) 
-- who have no manager (WHERE MGR IS NULL). It initializes their LEVEL at 1.

-- The second query joins the base EMP table with the EmpHierarchy results from the previous step. 
-- It matches the manager ID (E.MGR) of the next layer of employees to the employee ID (EH.EMPNO) 
-- of the layer just processed, incrementing the LEVEL by 1 each time.

-- Termination: The recursion stops automatically when a level is reached where no employees report 
-- to the managers found in the previous step.Final Output: 

-- The trailing SELECT * outputs the entire corporate ladder, showing each employee, their manager, 
-- and their relative rank/depth (LEVEL) in the organization.

-- This helps build organization charts or reporting hierarchies.

-- Performance Benchmarking:

### Without Recursive CTE (manual joins)

-- If you tried to fetch all levels manually:

SELECT e1.emp_name AS Level1, e2.emp_name AS Level2, e3.emp_name AS Level3
FROM employees e1
LEFT JOIN employees e2 ON e2.manager_id = e1.emp_id
LEFT JOIN employees e3 ON e3.manager_id = e2.emp_id;

	-- - You must know exact depth (3 levels in this case).
	-- - If new levels appear, you must rewrite the query.
	-- - Complex to maintain.

-- With Recursive CTE's:
	-- - Automatically handles any number of levels.
	-- - Uses depth-first traversal via recursion.
	-- - MySQL optimizer rewrites it efficiently into iterative joins in-memory.

## When to Use Recursive CTEs:
-- Use Recursive CTE when:
-- - You have hierarchical data (like org charts, categories, BOMs).
-- - You need dynamic-depth traversal (no fixed join depth).
-- - You want readable, maintainable code.

-- Avoid Recursive CTE if:
-- - The hierarchy is very deep (e.g., >1000 levels) — it may cause stack overhead.
-- - You can flatten the hierarchy using materialized paths for faster lookups.

SELECT E.EMPNO , E.SAL , E.DEPTNO, AVG(E.SAL) OVER(PARTITION BY E.DEPTNO) AS AVG_SAL
FROM EMP E HAVING E.SAL>(SELECT AVG(SAL ) FROM EMP WHERE DEPTNO =E.DEPTNO
GROUP BY DEPTNO ) ;

 
SELECT E.EMPNO,  E.SAL , E.DEPTNO ,AVG(E.SAL) OVER(PARTITION BY DEPTNO ORDER BY DEPTNO ) AS AVG_SAL 
FROM EMP E ;












