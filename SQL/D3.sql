USE LTM26  ;
SELECT USER,HOST,PLUGIN FROM MYSQL.USER;
CREATE USER 'TEST'@'LOCALHOST' IDENTIFIED BY '1234';
GRANT SELECT , INSERT ON DEMO.* TO 'TEST'@'LOCALHOST';
SHOW GRANTS FOR 'TEST'@'LOCALHOST';
REVOKE INSERT ON DEMO.* FROM 'TEST'@'LOCALHOST';
SELECT * FROM MYSQL.USER ;

-- LECTURE

SELECT * FROM EMP ; -- 14 REC 
 SELECT * FROM DEPT; -- 4 REC
 -- COPY TABLE FROM OTHER DB 
CREATE TABLE ORDERS AS SELECT * FROM quickkart_db.ORDERS;
-- JOINS  : USED ON 2 OR MORE TABLE WITH COMMON KEY OR VALUES
	-- BASED ON KEY COL WE CAN GET REFERRED VALUES FROM OTHER TABLE 
	-- UNIVERSAL FROMULA FOR  JOIN N-1 
	-- IF JOIN CND IS NOT MEET O/P WILL BE 'NULL'
    
	-- TYPES :
		-- INNER JOIN 
        -- LEFT JOIN 
        -- RIGHT JOIN 
        -- FULL OUTER JOIN 
        -- CROSS JOIN 
        -- NON-EQUI JOIN 
        -- SELF JOIN 
	-- INNER JOIN :
    SELECT E.EMPNO , E.ENAME , E.SAL ,E.DEPTNO ,D.DNAME,D.LOC 
		FROM EMP E INNER JOIN DEPT D 
        ON E.DEPTNO = D.DEPTNO ;
        
	-- LEFT JOIN : ALL DATA FROM LEFT ANDD ONLY MATCH FROM RIGHT 
    SELECT E.EMPNO , E.ENAME , E.SAL ,E.DEPTNO ,D.DNAME,D.LOC 
		FROM EMP E LEFT JOIN DEPT D 
        ON E.DEPTNO = D.DEPTNO ;
        
	-- RIGHT JOIN : ALL DATA FROM RIGHT  ANDD ONLY MATCH FROM LEFT
    SELECT E.EMPNO , E.ENAME , E.SAL ,E.DEPTNO ,D.DNAME,D.LOC 
		FROM EMP E RIGHT JOIN DEPT D 
        ON E.DEPTNO = D.DEPTNO ;
        
	-- CROSS JOIN : CROSS PRODUCT - 14*4 = 56 REC -- CROSS WILL NOT WORK ON ANY CND
    SELECT E.* ,D.* FROM EMP E , DEPT D;
    SELECT E.* ,D.* FROM EMP E CROSS JOIN  DEPT D;
    
    -- SELF JOIN : JOIN TABLE TO ITSELF 
    SELECT E.EMPNO,E.ENAME,E.MGR,M.ENAME AS MGR_NAME FROM EMP E, EMP M 
		WHERE E.MGR =M.EMPNO ;
    
	CREATE TABLE SALGRADE (GRADE INT , LOWSAL INT , HISAL INT );
    INSERT INTO SALGRADE VALUES (1,700,1400),(2,1401,2500),(3,2501,3000),(4,3001,10000);
	
    -- NON-EQUI JOIN : NO COMMON KEY COL B/W TABLES :
    
    SELECT E.EMPNO , E.ENAME ,E.SAL,S.GRADE 
    FROM EMP E , SALGRADE S
    WHERE E.SAL BETWEEN S.LOWSAL AND S.HISAL
    ORDER BY S.GRADE;
    
    
-- WORKING WITH AGG FUNCTIONS -- SUM / AVG / MIN / MAX / COUNT 
-- IMP CLAUSE : GROUP BY / HAVING / ORDER BY 
	-- NON AGGREGATE COLUMN IN SELECT LIST MUST BE IN GROUP BY TOO
    -- NON AGGREGATE FILTER MUST BE IN 'WHERE' 
    -- AAGREGATED FILTER MUST BE IN HAVING CLAUSE 
    
    --  SELECT -> FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY 
    
    SELECT DEPTNO , SUM(SAL ) AS SUM_SAL FROM EMP GROUP BY DEPTNO ORDER BY DEPTNO ;
    
    SELECT DEPTNO , JOB , SUM(SAL) AS SUM_SAL FROM EMP GROUP BY DEPTNO,JOB ORDER BY DEPTNO ;
    
    
	SELECT DEPTNO,JOB ,SUM(SAL) AS SUM_SAL FROM EMP GROUP BY DEPTNO,JOB HAVING JOB='MANAGER' ORDER BY DEPTNO ;
    -- APPLIES FILTER AFTER GROUPING 
    -- NOT EFFICIENT 
    
    
    SELECT DEPTNO , JOB ,SUM(SAL) AS SUM_SAL FROM EMP WHERE JOB ='MANAGER' GROUP BY DEPTNO,JOB ORDER BY DEPTNO;
	-- FIRST FILTERING AND THEN GROUPING 
    -- EFFICIENT 
    
    -- SELECT DEPTNO, SUM(SAL) AS SUM_SAL FROM EMP HAVING JOB='MANAGER' GROUP BY DEPTNO ORDER BY DEPTNO -- ERROR 
    -- FOLLOW THE SEQUENCE 
    
    SELECT DEPTNO,JOB,SUM(SAL) AS SUM_SAL FROM EMP 
    WHERE SUM(SAL) >=1500 
    GROUP BY DEPTNO,JOB
    ORDER BY DEPTNO ;
		 -- THIS IS WRONG
         -- BECAUSE YOU CANNOT USE AGGREGATED FUNCT IN WHERE CLAUDE 
    SELECT DEPTNO,JOB,SUM(SAL) AS SUM_SAL FROM EMP 
    where JOB='MANAGER'
    GROUP BY DEPTNO,JOB
    HAVING SUM(SAL) >=1500 
    ORDER BY DEPTNO ;
    
    
-- SUBQUERIES 

	-- SINGLE ROW SQ : SUBQUERY RETURN EXACTLY ONE ROW AS O/P
		SELECT * FROM EMP WHERE SAL < (SELECT MAX(SAL) FROM EMP );
        SELECT * FROM EMP WHERE JOB = ( SELECT JOB FROM EMP WHERE ENAME = 'ALLEN');
        SELECT * FROM EMP WHERE SAL > ( SELECT SAL FROM EMP WHERE EMPNO= 7566);
        
	-- MULTI-ROW SA l SUBQUERY RETURNS MODER THAN ONE ROW AS O/P (LIST OF VALUES ARE RETURNED AS O/P)
		SELECT * FROM EMP WHERE JOB IN ( SELECT JOB FROM EMP WHERE JOB IN ('SALESMAN','MANAGER'));
        
        SELECT * FROM EMP WHERE SAL > ANY ( SELECT SAL FROM EMP WHERE SAL BETWEEN 2500 AND 3999); -- ALL VALUES > THAN THE SMALLEST IN THE LIST 
        -- ANY :MUST SATISFY CONDITION WITH ANY ONE OFLISTS
		SELECT * FROM EMP WHERE SAL <= ANY ( SELECT SAL FROM EMP WHERE SAL BETWEEN 2500 AND 3999);-- ALL VALUES < THAN THE HIGHEST IN THE LIST 
        SELECT * FROM EMP WHERE SAL > ALL ( SELECT SAL FROM EMP WHERE SAL BETWEEN 2500 AND 3999); -- ALL VALUES > THAN THE HIGHEST IN THE LIST 
        -- ALL: MUST SATISFY CONDITION WITH ALL IN LIST 
		SELECT * FROM EMP WHERE SAL < ALL ( SELECT SAL FROM EMP WHERE SAL BETWEEN 2500 AND 3999);-- ALL VALUES < THAN THE SMALLEST IN THE LIST 
		
	-- IN OPERATOR IN SQ 
		SELECT * FROM EMP WHERE DEPTNO IN (SELECT DEPTNO FROM EMP WHERE ENAME = 'ALLEN');
        
	-- NESTED SQ 
		-- EX1 : PROJECT EMPLOYEES GETTING 2ND HIGHEST SAL
		SELECT EMPNO , ENAME , SAL,DEPTNO FROM EMP WHERE SAL = 
        (SELECT MAX(SAL) FROM EMP WHERE SAL < ( SELECT MAX(SAL ) FROM EMP ));
        
        -- EX2: PROJECT EMPLOYEES WORKING ON LOCATION'S BASED DEPTNO 
        SELECT * FROM EMP WHERE DEPTNO = ( SELECT DEPTNO FROM DEPT  WHERE LOC =
        (SELECT LOC FROM DEPT WHERE DNAME = 'SALES'));
        
	-- SQ IN SELECT CLAUSE
		SELECT EMPNO,ENAME,SAL , (SELECT MAX(SAL) FROM EMP ) AS MAX_SAL FROM EMP ;
        
    -- CO-RELATED SQ 
		SELECT E1.EMPNO,E1.ENAME,E2.ENAME AS MGR_NAME FROM EMP E1, EMP E2 WHERE E1.MGR=E2.EMPNO AND E1.ENAME='BLAKE';
        SELECT EMPNO ,ENAME , (SELECT ENAME FROM EMP WHERE EMPNO = (SELECT MGR FROM EMP WHERE ENAME='BLAKE')) AS MGR_NAME 
        FROM EMP WHERE ENAME='BLAKE';
        
        
-- TRANSACTIONS & CONCURRENCY:

-- transaction Example:
-- A transaction is a group of steps that must all succeed or all fail.
-- Example: Bank money transfer
	-- 1. Deduct from Account A
	-- 2. Add to Account B
		--     If step 2 fails, rollback step 1.

-- Concurrency Example:
-- Two cashiers updating stock at the same time.
-- MySQL uses locks to avoid incorrect updates.
	-- Example lock: SELECT * FROM products WHERE id = 10 FOR UPDATE;
	-- This ensures only one user can modify the row at a time.

-- ACID Properties: 
--  Property		Meaning									Example
-- 	A – Atomicity	All steps succeed or all fail			Money transfer
-- 	C – Consistency	Data remains correct					Debit + Credit maintain total balance
-- 	I – Isolation	Multiple users don’t affect each other	Two cashiers updating stock
-- 	D – Durability	Data survives crashes					Once committed → safe even after power failure

-- WORKING WITH TRANSACTIONS:

-- In MySQL, transactions are used to group one or more SQL operations into a single unit of work. 
-- You use START TRANSACTION to begin a transaction and either 
-- COMMIT to save the changes or ROLLBACK to undo them.

CREATE TABLE employees_tcl (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ename VARCHAR(50),
    desgn VARCHAR(50)
);
-- Start a new transaction
START TRANSACTION;
-- Insert a new employee
INSERT INTO employees_tcl (ename, desgn) VALUES ('MUKESH', 'Developer');
-- Create a savepoint
SAVEPOINT sp1;
-- Insert another employee
INSERT INTO employees_tcl (ename, desgn) VALUES ('VIJAY', 'Designer');
-- Update an employee's position
UPDATE employees_tcl SET desgn = 'Senior Developer' WHERE ename = 'MUKESH';
-- Create another savepoint
SAVEPOINT sp2;
select * from employees_tcl;
-- Delete an employee
DELETE FROM employees_tcl WHERE ename = 'VIJAY';
-- Rollback to the second savepoint (before the delete)
ROLLBACK TO sp2;
-- Insert a different employee instead
INSERT INTO employees_tcl (ename, desgn) VALUES ('DINESH', 'Tester');
-- Commit the transaction
COMMIT;

SELECT * FROM employees_tcl;
    
-- BUSSINESS USE CASE ON TRANSACTIONS:

/* MySQL program demonstrating the use of transactions with BEGIN TRANSACTION, 
COMMIT, and ROLLBACK.

This example involves a simple banking scenario where money is transferred from 
one account to another.*/

-- Assumptions:
/* You have a database named bank.
You have a table named accounts with the following structure:*/  

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,account_holder VARCHAR(255) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL);

INSERT INTO accounts (account_holder, balance) VALUES ('Dinesh', 1000.00), ('Karthik', 500.00);
select * from accounts;

-- OPTION - 1: Procedure without Paramater;
-- Transaction Example by Implementing a Procedure:

-- Step 1: Demonstrate the transaction:
DELIMITER $$
CREATE PROCEDURE TransferFunds()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction on error
        ROLLBACK;
        SELECT 'Transaction failed: An error occurred' AS message;
    END;
    -- Start the transaction
    START TRANSACTION;
    -- Deduct 200 from Dinesh's account
    UPDATE accounts SET balance = balance - 200 WHERE account_holder = 'Dinesh';
    -- Check Dinesh's balance -- storing Dinesh Balance in Session Variable
    SELECT balance INTO @dinesh_balance FROM accounts WHERE account_holder = 'Dinesh';

    -- If Dinesh's balance is negative, rollback the transaction
    IF @dinesh_balance < 0 THEN
        ROLLBACK;
        SELECT 'Transaction failed: Insufficient funds in Dinesh\'s account' AS message;
        -- Note the use of the backslash (\) to escape the single quote within the string.
    ELSE
        -- Add 200 to Karthik's account
        UPDATE accounts SET balance = balance + 200 WHERE account_holder = 'Karthik';

        -- Commit the transaction
        COMMIT;
        SELECT 'Transaction successful' AS message;
    END IF;
END $$

-- Call the procedure to perform the transaction
CALL TransferFunds(500);
select * from accounts;

-- Key Features:
-- ✅ Atomicity: The transaction ensures that either both updates happen or none.
-- ✅ Consistency: The database remains in a valid state, preventing partial transactions.
-- ✅ Isolation: The session variable @dinesh_balance ensures data integrity during execution.
-- ✅ Durability: Once committed, the changes persist.

-- MySQL Database Administration – Server Backups:
-- Database backup = a copy of your data so you can restore it if data is lost or corrupted.

-- Why Backups Are Important:
	-- -> Server crash
	-- -> Human error (accidental DELETE)
	-- -> Ransomware / cyber attacks
	-- -> Development testing needs
	-- -> Migration from one server to another

-- User Roles and Permissions:
-- MySQL Role-Based Access Control (RBAC):

-- Real-Life Example for Permissions (Industry):
-- Example Scenario: E-commerce Company Roles:
-- Role				What They Do					MySQL Permissions
-- Data Analyst		View sales data					SELECT only
-- HR Team			Add/update employee records		INSERT, UPDATE
-- Developer		Modify database schema			ALTER, CREATE, DROP
-- Admin			Full control					ALL PRIVILEGES  
        