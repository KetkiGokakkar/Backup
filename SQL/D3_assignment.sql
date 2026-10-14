-- SET 1 

-- JOINS WITH AGGREGATES - HANDS-ON:
-- *************************************

-- Write Down the below Queries by using EMP and DEPT Table:

-- EG1:Department-Wise Employee Statistics:
	-- Department Employee Statistics: Write a MySQL query using EMP and DEPT to display department number, 
	-- department name, location, employee count, total salary, average salary, maximum salary, 
	-- and minimum salary for each department. Sort the output by average salary from highest to lowest.
	SELECT D.DEPTNO , D.DNAME ,D.LOC,COUNT(E.EMPNO) AS EMP_COUNT , SUM(E.SAL) AS TOTAL_SALARY ,
			AVG(E.SAL) AS AVG_SALARY , MIN(E.SAL) AS MIN_SALARY , MAX(E.SAL) AS MAX_SALARY
	FROM EMP E INNER JOIN DEPT D 
    ON E.DEPTNO = D.DEPTNO
    GROUP BY D.DEPTNO , D.DNAME ,D.LOC
    ORDER BY D.DEPTNO;
-- EG2:Job-wise Salary Report:
	-- Job-Wise Salary Analysis: Write a MySQL query to display each job, the number of 
    -- employees performing that job, 
	-- total salary,and average salary. Sort the output by total salary from highest to lowest.
	SELECT E.JOB , COUNT(E.EMPNO) AS TOT_EMP , 
			SUM(E.SAL) AS TOT_SALARY , AVG(E.SAL) AS AVG_SALARY
	FROM EMP E 
    GROUP BY E.JOB
    ORDER BY TOT_SALARY DESC;
    
-- EG3:Top Department Using LIMIT / TOP:
	-- Highest-Paying Department: Write a MySQL query using EMP and DEPT to find the department 
	-- with the highest average employee salary. 
	-- Display only the department name and average salary. 
    -- Use LIMIT to return only the highest-ranked department.
    SELECT  D.DNAME ,AVG(E.SAL) AS AVG_SALARY 
    FROM EMP E INNER JOIN DEPT D
	ON E.DEPTNO = E.DEPTNO
    GROUP BY D.DNAME 
    ORDER BY AVG_SALARY DESC 
    LIMIT 1;

-- EG4:Monthly Payroll:
	-- Department Payroll Summary: Write a MySQL query to display department number, 
    -- employee count, total payroll, 
	-- and average salary rounded to two decimal places for every department. 
	-- Sort the departments by total payroll from highest to lowest.
	SELECT D.DEPTNO , COUNT(E.EMPNO) AS EMP_COUNT , SUM(E.SAL) AS TOT_PAYROLL ,ROUND(AVG(SAL),2) AS AVG_SAL
    FROM EMP E JOIN DEPT D 
    ON E.DEPTNO =D.DEPTNO
    GROUP BY D.DEPTNO
    ORDER BY D.DEPTNO,TOT_PAYROLL DESC;

-- SET 2
-- PERFORMING JOIN ON 3 TABLES: HANDS-ON:
-- *****************************************

CREATE TABLE Customers2 (customer_id INT PRIMARY KEY,customer_name VARCHAR(100),email VARCHAR(100));

INSERT INTO Customers2 VALUES 
(1, 'Dinesh Karthik', 'DK@gmail.com'),(2, 'Ajay Krish', 'ak@gmail.com'),(3, 'Mukesh', 'Mukesh@gmail.com');

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,customer_id INT, 
    product_name VARCHAR(100),order_date DATE,amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id));

INSERT INTO Orders VALUES 
(101, 1, 'Laptop', '2024-03-01', 1200.00), 
(102, 2, 'Smartphone', '2024-03-05', 800.00),
(103, 3, 'Tablet', '2024-03-10', 500.00);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,order_id INT,
    payment_date DATE,payment_method VARCHAR(50),payment_status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id));

INSERT INTO Payments VALUES 
(201, 101, '2024-03-02', 'Credit Card', 'Completed'),
(202, 102, '2024-03-06', 'PayPal', 'Completed'),
(203, 103, '2024-03-11', 'Bank Transfer', 'Pending');

SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Payments;

-- Query1: Retrive name,email,prdtname,paydate,paymethod,paystatus from all 3 tables:
	SELECT C.CUSTOMER_NAME,O.PRODUCT_NAME , C.EMAIL,P.PAYMENT_DATE,P.PAYMENT_METHOD,P.PAYMENT_STATUS
    FROM CUSTOMERS2 C 
    INNER JOIN ORDERS O 
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
    INNER JOIN PAYMENTS  P
    ON O.ORDER_ID = P.ORDER_ID;

-- Query2: - Filter by Payment Status "Completed", 
		-- Filter by Customer Name like k or Email like gmail, and Sort by Most Recent Orders 
        -- and Highest Amount
	SELECT C.CUSTOMER_NAME,O.PRODUCT_NAME,O.ORDER_DATE , C.EMAIL,P.PAYMENT_DATE,
		P.PAYMENT_METHOD,P.PAYMENT_STATUS,O.AMOUNT
    FROM CUSTOMERS2 C 
    INNER JOIN ORDERS O 
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
    INNER JOIN PAYMENTS  P
    ON O.ORDER_ID = P.ORDER_ID 
    WHERE P.PAYMENT_STATUS ='Completed' 
		AND C.CUSTOMER_NAME LIKE '%K%' 
			OR EMAIL LIKE '%gmail%'
	ORDER BY O.ORDER_DATE DESC ,O.AMOUNT DESC;
    
-- 1 WAQTD ENAME & DNAME OF AN EMP WHO IS WORKING AS A CLERK IN THE DALLAS. 
	SELECT E.ENAME , D.DNAME 
    FROM EMP E INNER JOIN DEPT D 
    ON E.DEPTNO = D.DEPTNO 
    WHERE E.JOB = 'CLERK' AND D.LOC='DALLAS' ;
-- 2 WAQTD NAME, SAL & LOCATION WITH DEPTNO OF AN EMP 
	-- WHO IS EARNING MORE THAN ‘TURNER’ IN THE DEPTNO 10 OR 30  
    SELECT E.ENAME , E.SAL ,E.DEPTNO , D.LOC
    FROM EMP E JOIN DEPT D 
    ON E.DEPTNO =D.DEPTNO
    WHERE E.SAL>(SELECT SAL FROM EMP WHERE ENAME='TURNER') AND E.DEPTNO IN (10,30);
	SELECT * FROM EMP;

-- 3  WAQTD NAME WITH DNAME IF EMP IS HIRED BEFORE ‘JONES’ IN THE SAME DNAME AS THAT OF ‘FORD’. 
	SELECT E.ENAME , D.DNAME 
    FROM EMP E JOIN DEPT D 
    ON E.DEPTNO = D.DEPTNO 
    WHERE E.HIREDATE < (SELECT HIREDATE FROM EMP WHERE ENAME='JONES')
		AND E.DEPTNO = (SELECT DEPTNO FROM EMP WHERE ENAME='FORD');
-- 4 WAQTD EMP NAME WITH THERE MANAGERS IF EMP IS HAVING CHAR ‘R’ IN THE NAME BUT NOT MANAGER.
	SELECT E1.EMPNO,E1.ENAME,E2.ENAME AS MGR1 
    FROM EMP E1 LEFT JOIN EMP E2 ON E1.MGR=E2.EMPNO 
    WHERE E1.JOB !='MANAGER' AND E1.ENAME LIKE '%R%';
    
-- 5 WAQTD EMP NAME MANAGER NAME ALONG WITH THEIR DESIGNATION AND HIREDATE 
	-- IF EMP IS WORKING IN THE SAME DESIGNATION AS THAT OF ‘ALLEN’,  
	-- MANAGER IS WORKING WITH SAME DESIGNATION AS THAT OF ‘CLARK’  
	-- & EMP SHOULD HIRED IN THE MONTH OF ‘FEBRUARY’ MANAGER IN ‘MAY’.
    SELECT E.ENAME , E.JOB ,E.HIREDATE, M.ENAME AS MGR_NAME , M.JOB AS MGR_JOB  ,M.HIREDATE AS MGR_HIREDATE
    FROM EMP E , EMP M 
    WHERE E.MGR=M.EMPNO AND
		E.JOB=(SELECT JOB FROM EMP WHERE ENAME ='ALLEN') 
        AND M.JOB = (SELECT JOB FROM EMP WHERE ENAME ='CLARK') 
        AND DATE_FORMAT(E.HIREDATE,'%M') = 'FEBRUARY'
        AND DATE_FORMAT(M.HIREDATE,'%M') = 'MAY';
    
-- 10 WAQTD EMP NAME , DNAME, MGR NAME & MGR DNAME OF AN EMP 
-- WHO IS EARNING 4TH MAXIMUM SALARY IN EMP TABLE. 
	SELECT E.ENAME , D.DNAME , M.ENAME ,DM.DNAME
    FROM EMP E JOIN DEPT D 
    ON E.DEPTNO =D.DEPTNO 
    JOIN EMP M 
    ON E.MGR=M.EMPNO 
    JOIN DEPT DM 
    ON M.DEPTNO =DM.DEPTNO 
    WHERE E.SAL = (SELECT SAL FROM EMP ORDER BY SAL DESC LIMIT 1 OFFSET 3);
