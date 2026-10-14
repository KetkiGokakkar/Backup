USE INVENTORY_MS;
---------------------------------------------------
-- 1. DROP EXISTING TABLES (Safeguard)
---------------------------------------------------
 
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS warehouses;
 
---------------------------------------------------
-- 2. CREATE TABLES
---------------------------------------------------
 
-- PRODUCTS Table
CREATE TABLE products (
   product_id INTEGER PRIMARY KEY,
   product_name VARCHAR(100) NOT NULL,
   category VARCHAR(50) NOT NULL,
   unit_cost DECIMAL(10, 2) NOT NULL -- The cost to the company
);
 
-- WAREHOUSES Table
CREATE TABLE warehouses (
   warehouse_id INTEGER PRIMARY KEY,
   location_city VARCHAR(100) NOT NULL,
   manager VARCHAR(100) NOT NULL
);
 
-- SALES Table (Fact Table, Simulating Large Dataset)
CREATE TABLE sales (
   sale_id INTEGER PRIMARY KEY,
   product_id INTEGER NOT NULL,
   warehouse_id INTEGER NOT NULL,
   sale_date DATE NOT NULL,
   quantity_sold INTEGER NOT NULL,
   selling_price DECIMAL(10, 2) NOT NULL, -- The price sold to the customer
   FOREIGN KEY (product_id) REFERENCES products(product_id),
   FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);
 
---------------------------------------------------
-- 3. INSERT WAREHOUSE DATA (Dimension Table)
---------------------------------------------------
 
INSERT INTO warehouses (warehouse_id, location_city, manager) VALUES
(101, 'New York', 'Alice Johnson'),
(102, 'Los Angeles', 'Bob Smith'),
(103, 'Chicago', 'Charlie Brown'),
(104, 'Miami', 'Dana White');
 
---------------------------------------------------
-- 4. INSERT PRODUCT DATA (Dimension Table)
---------------------------------------------------
 
INSERT INTO products (product_id, product_name, category, unit_cost) VALUES
(1, 'Eco-Friendly Water Bottle', 'Outdoors', 5.50),
(2, 'Noise Cancelling Headphones', 'Electronics', 55.00),
(3, 'Organic Coffee Beans (1kg)', 'Grocery', 12.00),
(4, 'Ergonomic Mouse', 'Electronics', 15.00),
(5, 'Portable Power Bank', 'Electronics', 22.50),
(6, 'Yoga Mat Pro', 'Fitness', 18.00),
(7, 'Smart Home Hub', 'Electronics', 80.00),
(8, 'High-Performance Blender', 'Kitchen', 45.00),
(9, 'Premium Backpack', 'Outdoors', 30.00),
(10, 'Wireless Charging Pad', 'Electronics', 8.50),
(11, 'LED Desk Lamp', 'Home Goods', 10.00),
(12, '4K Monitor', 'Electronics', 150.00),
(13, 'Mechanical Keyboard', 'Electronics', 65.00),
(14, 'Gourmet Tea Set', 'Grocery', 14.50),
(15, 'Jump Rope Pro', 'Fitness', 6.00);
 
---------------------------------------------------
-- 5. INSERT SALES DATA (Fact Table - 200 Records)
---------------------------------------------------
 
-- Using a pattern to simulate sales across 4 months (June, July, August, September) and different products/warehouses.
 
-- Sales Pattern Helper Function (Conceptual - data generation simplified for SQL script)
-- Note: In a real environment, this data would be generated programmatically.
-- Here we insert them manually to ensure the script is self-contained and runnable.
 
-- June 2025 Sales (IDs 1-50)
INSERT INTO sales (sale_id, product_id, warehouse_id, sale_date, quantity_sold, selling_price) VALUES
(1, 2, 101, '2025-06-05', 5, 89.99), (2, 7, 102, '2025-06-06', 2, 120.00), (3, 3, 103, '2025-06-07', 10, 19.99),
(4, 1, 104, '2025-06-08', 20, 9.99), (5, 5, 101, '2025-06-09', 8, 35.00), (6, 6, 102, '2025-06-10', 5, 29.99),
(7, 2, 103, '2025-06-11', 12, 89.99), (8, 4, 104, '2025-06-12', 15, 25.00), (9, 10, 101, '2025-06-13', 30, 15.00),
(10, 1, 102, '2025-06-14', 18, 9.99), (11, 7, 103, '2025-06-15', 3, 120.00), (12, 8, 104, '2025-06-16', 6, 65.00),
(13, 11, 101, '2025-06-17', 15, 18.00), (14, 12, 102, '2025-06-18', 2, 250.00), (15, 13, 103, '2025-06-19', 4, 99.99),
(16, 14, 104, '2025-06-20', 7, 24.99), (17, 15, 101, '2025-06-21', 10, 12.00), (18, 2, 102, '2025-06-22', 15, 89.99),
(19, 3, 103, '2025-06-23', 25, 19.99), (20, 5, 104, '2025-06-24', 12, 35.00), (21, 6, 101, '2025-06-25', 8, 29.99),
(22, 10, 102, '2025-06-26', 40, 15.00), (23, 1, 103, '2025-06-27', 35, 9.99), (24, 4, 104, '2025-06-28', 18, 25.00),
(25, 7, 101, '2025-06-29', 1, 120.00), (26, 8, 102, '2025-06-30', 5, 65.00);
 
-- July 2025 Sales (IDs 27-75) - Increased volume for Electronics
INSERT INTO sales (sale_id, product_id, warehouse_id, sale_date, quantity_sold, selling_price) VALUES
(27, 2, 101, '2025-07-01', 10, 89.99), (28, 5, 102, '2025-07-02', 15, 35.00), (29, 7, 103, '2025-07-03', 4, 120.00),
(30, 12, 104, '2025-07-04', 3, 250.00), (31, 13, 101, '2025-07-05', 6, 99.99), (32, 2, 102, '2025-07-06', 20, 89.99),
(33, 4, 103, '2025-07-07', 22, 25.00), (34, 10, 104, '2025-07-08', 35, 15.00), (35, 1, 101, '2025-07-09', 25, 9.99),
(36, 6, 102, '2025-07-10', 10, 29.99), (37, 8, 103, '2025-07-11', 7, 65.00), (38, 11, 104, '2025-07-12', 20, 18.00),
(39, 14, 101, '2025-07-13', 9, 24.99), (40, 15, 102, '2025-07-14', 15, 12.00), (41, 3, 103, '2025-07-15', 30, 19.99),
(42, 5, 104, '2025-07-16', 18, 35.00), (43, 7, 101, '2025-07-17', 2, 120.00), (44, 12, 102, '2025-07-18', 4, 250.00),
(45, 13, 103, '2025-07-19', 8, 99.99), (46, 2, 104, '2025-07-20', 18, 89.99), (47, 4, 101, '2025-07-21', 25, 25.00),
(48, 10, 102, '2025-07-22', 50, 15.00), (49, 1, 103, '2025-07-23', 45, 9.99), (50, 6, 104, '2025-07-24', 12, 29.99),
(51, 8, 101, '2025-07-25', 6, 65.00), (52, 11, 102, '2025-07-26', 25, 18.00);
 
-- August 2025 Sales (IDs 53-150) - Peak sales month
INSERT INTO sales (sale_id, product_id, warehouse_id, sale_date, quantity_sold, selling_price) VALUES
(53, 2, 103, '2025-08-01', 25, 89.99), (54, 5, 104, '2025-08-02', 30, 35.00), (55, 7, 101, '2025-08-03', 6, 120.00),
(56, 12, 102, '2025-08-04', 5, 250.00), (57, 13, 103, '2025-08-05', 10, 99.99), (58, 2, 104, '2025-08-06', 35, 89.99),
(59, 4, 101, '2025-08-07', 30, 25.00), (60, 10, 102, '2025-08-08', 60, 15.00), (61, 1, 103, '2025-08-09', 50, 9.99),
(62, 6, 104, '2025-08-10', 15, 29.99), (63, 8, 101, '2025-08-11', 8, 65.00), (64, 11, 102, '2025-08-12', 30, 18.00),
(65, 14, 103, '2025-08-13', 12, 24.99), (66, 15, 104, '2025-08-14', 20, 12.00), (67, 3, 101, '2025-08-15', 40, 19.99),
(68, 5, 102, '2025-08-16', 25, 35.00), (69, 7, 103, '2025-08-17', 3, 120.00), (70, 12, 104, '2025-08-18', 6, 250.00),
(71, 13, 101, '2025-08-19', 12, 99.99), (72, 2, 102, '2025-08-20', 40, 89.99), (73, 4, 103, '2025-08-21', 35, 25.00),
(74, 10, 104, '2025-08-22', 70, 15.00), (75, 1, 101, '2025-08-23', 60, 9.99), (76, 6, 102, '2025-08-24', 18, 29.99),
(77, 8, 103, '2025-08-25', 10, 65.00), (78, 11, 104, '2025-08-26', 35, 18.00), (79, 14, 101, '2025-08-27', 15, 24.99),
(80, 15, 102, '2025-08-28', 25, 12.00), (81, 3, 103, '2025-08-29', 50, 19.99), (82, 5, 104, '2025-08-30', 30, 35.00),
(83, 7, 101, '2025-08-31', 4, 120.00);
 
-- September 2025 Sales (IDs 84-200) - Reduced volume, simulating end-of-quarter
INSERT INTO sales (sale_id, product_id, warehouse_id, sale_date, quantity_sold, selling_price) VALUES
(84, 12, 102, '2025-09-01', 3, 250.00), (85, 13, 103, '2025-09-02', 7, 99.99), (86, 2, 104, '2025-09-03', 20, 89.99),
(87, 4, 101, '2025-09-04', 20, 25.00), (88, 10, 102, '2025-09-05', 40, 15.00), (89, 1, 103, '2025-09-06', 40, 9.99),
(90, 6, 104, '2025-09-07', 10, 29.99), (91, 8, 101, '2025-09-08', 7, 65.00), (92, 11, 102, '2025-09-09', 25, 18.00),
(93, 14, 103, '2025-09-10', 10, 24.99), (94, 15, 104, '2025-09-11', 15, 12.00), (95, 3, 101, '2025-09-12', 30, 19.99),
(96, 5, 102, '2025-09-13', 20, 35.00), (97, 7, 103, '2025-09-14', 3, 120.00), (98, 12, 104, '2025-09-15', 4, 250.00),
(99, 13, 101, '2025-09-16', 8, 99.99), (100, 2, 102, '2025-09-17', 25, 89.99);
 
-- Add another 100 random sales records distributed across the 4 months (IDs 101-200)
-- This ensures a larger, more realistic dataset for the analytics tasks.
INSERT INTO sales (sale_id, product_id, warehouse_id, sale_date, quantity_sold, selling_price) VALUES
(101, 1, 101, '2025-06-12', 15, 9.99), (102, 2, 102, '2025-06-25', 10, 89.99), (103, 3, 103, '2025-07-01', 12, 19.99),
(104, 4, 104, '2025-07-15', 18, 25.00), (105, 5, 101, '2025-07-28', 7, 35.00), (106, 6, 102, '2025-08-03', 10, 29.99),
(107, 7, 103, '2025-08-16', 2, 120.00), (108, 8, 104, '2025-08-29', 5, 65.00), (109, 9, 101, '2025-09-04', 10, 45.00),
(110, 10, 102, '2025-09-17', 20, 15.00), (111, 11, 103, '2025-06-03', 15, 18.00), (112, 12, 104, '2025-06-16', 2, 250.00),
(113, 13, 101, '2025-07-01', 4, 99.99), (114, 14, 102, '2025-07-14', 8, 24.99), (115, 15, 103, '2025-07-27', 12, 12.00),
(116, 1, 104, '2025-08-09', 25, 9.99), (117, 2, 101, '2025-08-22', 15, 89.99), (118, 3, 102, '2025-09-01', 20, 19.99),
(119, 4, 103, '2025-09-14', 25, 25.00), (120, 5, 104, '2025-06-05', 10, 35.00), (121, 6, 101, '2025-06-18', 8, 29.99),
(122, 7, 102, '2025-07-03', 3, 120.00), (123, 8, 103, '2025-07-16', 6, 65.00), (124, 9, 104, '2025-07-29', 12, 45.00),
(125, 10, 101, '2025-08-04', 30, 15.00), (126, 11, 102, '2025-08-17', 20, 18.00), (127, 12, 103, '2025-08-30', 3, 250.00),
(128, 13, 104, '2025-09-05', 5, 99.99), (129, 14, 101, '2025-09-18', 10, 24.99), (130, 15, 102, '2025-06-07', 15, 12.00),
(131, 1, 103, '2025-06-20', 20, 9.99), (132, 2, 104, '2025-07-05', 12, 89.99), (133, 3, 101, '2025-07-18', 15, 19.99),
(134, 4, 102, '2025-07-31', 20, 25.00), (135, 5, 103, '2025-08-06', 8, 35.00), (136, 6, 104, '2025-08-19', 10, 29.99),
(137, 7, 101, '2025-09-02', 2, 120.00), (138, 8, 102, '2025-09-15', 4, 65.00), (139, 9, 103, '2025-06-09', 15, 45.00),
(140, 10, 104, '2025-06-22', 25, 15.00), (141, 11, 101, '2025-07-07', 12, 18.00), (142, 12, 102, '2025-07-20', 3, 250.00),
(143, 13, 103, '2025-08-02', 6, 99.99), (144, 14, 104, '2025-08-15', 9, 24.99), (145, 15, 101, '2025-08-28', 15, 12.00),
(146, 1, 102, '2025-09-07', 30, 9.99), (147, 2, 103, '2025-09-20', 18, 89.99), (148, 3, 104, '2025-06-11', 15, 19.99),
(149, 4, 101, '2025-06-24', 20, 25.00), (150, 5, 102, '2025-07-09', 10, 35.00), (151, 6, 103, '2025-07-22', 12, 29.99),
(152, 7, 104, '2025-08-04', 4, 120.00), (153, 8, 101, '2025-08-17', 7, 65.00), (154, 9, 102, '2025-08-30', 10, 45.00),
(155, 10, 103, '2025-09-09', 25, 15.00), (156, 11, 104, '2025-09-22', 18, 18.00), (157, 12, 101, '2025-06-14', 3, 250.00),
(158, 13, 102, '2025-06-27', 5, 99.99), (159, 14, 103, '2025-07-11', 10, 24.99), (160, 15, 104, '2025-07-24', 15, 12.00),
(161, 1, 101, '2025-08-01', 35, 9.99), (162, 2, 102, '2025-08-14', 22, 89.99), (163, 3, 103, '2025-08-27', 28, 19.99),
(164, 4, 104, '2025-09-06', 15, 25.00), (165, 5, 101, '2025-09-19', 10, 35.00), (166, 6, 102, '2025-06-29', 8, 29.99),
(167, 7, 103, '2025-07-13', 3, 120.00), (168, 8, 104, '2025-07-26', 5, 65.00), (169, 9, 101, '2025-08-05', 15, 45.00),
(170, 10, 102, '2025-08-18', 35, 15.00), (171, 11, 103, '2025-08-31', 20, 18.00), (172, 12, 104, '2025-09-11', 2, 250.00),
(173, 13, 101, '2025-06-04', 6, 99.99), (174, 14, 102, '2025-06-17', 10, 24.99), (175, 15, 103, '2025-07-02', 12, 12.00),
(176, 1, 104, '2025-07-16', 20, 9.99), (177, 2, 101, '2025-07-29', 15, 89.99), (178, 3, 102, '2025-08-07', 20, 19.99),
(179, 4, 103, '2025-08-20', 25, 25.00), (180, 5, 104, '2025-09-01', 10, 35.00), (181, 6, 101, '2025-09-14', 8, 29.99),
(182, 7, 102, '2025-06-08', 3, 120.00), (183, 8, 103, '2025-06-21', 6, 65.00), (184, 9, 104, '2025-07-06', 15, 45.00),
(185, 10, 101, '2025-07-19', 30, 15.00), (186, 11, 102, '2025-08-01', 25, 18.00), (187, 12, 103, '2025-08-14', 3, 250.00),
(188, 13, 104, '2025-08-27', 5, 99.99), (189, 14, 101, '2025-09-05', 10, 24.99), (190, 15, 102, '2025-09-18', 15, 12.00),
(191, 1, 103, '2025-06-15', 25, 9.99), (192, 2, 104, '2025-06-28', 18, 89.99), (193, 3, 101, '2025-07-10', 20, 19.99),
(194, 4, 102, '2025-07-23', 25, 25.00), (195, 5, 103, '2025-08-08', 10, 35.00), (196, 6, 104, '2025-08-21', 12, 29.99),
(197, 7, 101, '2025-09-03', 4, 120.00), (198, 8, 102, '2025-09-16', 5, 65.00), (199, 9, 103, '2025-06-18', 10, 45.00),
(200, 10, 104, '2025-07-01', 30, 15.00);
 
---------------------------------------------------
-- 6. Optional INDEX CREATION (Performance Improvement Simulation)
---------------------------------------------------
 
-- In a real-world 'large dataset' scenario, indexes are critical for query performance.
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_sales_product ON sales(product_id);
CREATE INDEX idx_sales_warehouse ON sales(warehouse_id);
 
-- Check for data loaded: 
SELECT count(*) FROM WAREHOUSES;

SELECT * FROM SALES;
SELECT * FROM PRODUCTS;

-- Core Business Questions to Answer via SQL:
-- 1.   What are the top-performing products (ABC Analysis) and which ones are underperforming? 
	SELECT P.PRODUCT_NAME , P.UNIT_COST,
		SUM(S.QUANTITY_SOLD*S.SELLING_PRICE ) AS TOT_SALE
	FROM SALES S JOIN PRODUCTS P
	ON S.PRODUCT_ID = P.PRODUCT_ID
	GROUP BY P.PRODUCT_ID
	ORDER BY TOT_SALE DESC;

-- 2.   How is sales performance changing over time (Month-over-Month Growth)?
	SELECT DATE_FORMAT(SALE_DATE,'%M') AS MONTHS  , SUM(QUANTITY_SOLD * SELLING_PRICE) AS TOT_SALE 
    FROM SALES 
	GROUP BY MONTHS;
-- 3.   Which warehouses are the most efficient in terms of inventory volume handled?
	SELECT W.WAREHOUSE_ID,W.LOCATION_CITY,SUM(S.QUANTITY_SOLD) AS SOLD_UNITS 
    FROM SALES S JOIN WAREHOUSES W
    ON S.WAREHOUSE_ID =W.WAREHOUSE_ID
    GROUP BY S.WAREHOUSE_ID
    ORDER BY SOLD_UNITS DESC;
    
-- 4.   What is the total calculated profit, and what is the gross margin percentage?
-- TASK 2.1
	SELECT SUM(S.QUANTITY_SOLD *  S.SELLING_PRICE) AS TOT_REVENUE ,
		SUM(S.QUANTITY_SOLD* P.UNIT_COST) AS COGS ,
		SUM(S.QUANTITY_SOLD * ( S.SELLING_PRICE-P.UNIT_COST)) AS TOT_PROFIT, 
        SUM(S.QUANTITY_SOLD * ( S.SELLING_PRICE-P.UNIT_COST))  * 100 /SUM(S.QUANTITY_SOLD *  S.SELLING_PRICE) 
        AS 'GROSS_MARGIN(%)'
	FROM SALES S JOIN PRODUCTS P 
    ON S.PRODUCT_ID =P.PRODUCT_ID;
    
-- Task 2.2: ABC (High-Value) Product Analysis
	-- Identify the top 5 products based on Total Revenue and assign them a revenue rank.
	-- 1.   Group the data by product_name.
	-- 2.   Calculate the Total Revenue for each product.
	-- 3.   Use the RANK() Window Function to assign a rank to each product based on their revenue (highest revenue = rank 1).
	-- 4.   Filter the results to show only products with a rank of 5 or less.
	-- Required Columns: product_name, category, Total_Revenue, Revenue_Rank.
	SELECT  P.PRODUCT_NAME ,SUM(S.QUANTITY_SOLD * S.SELLING_PRICE) AS TOT_REV , 
    RANK() OVER(ORDER BY SUM(S.QUANTITY_SOLD * S.SELLING_PRICE) DESC) REV_RANK 
    FROM SALES S JOIN PRODUCTS P 
    ON S.PRODUCT_ID = P.PRODUCT_ID
    GROUP BY P.PRODUCT_NAME
    ORDER BY REV_RANK LIMIT 5;
    
-- Task 2.3: Month-over-Month (MoM) Sales Growth
	-- Analyze the sales trend by comparing the total sales revenue of the current month 
    -- to the previous month. Assume the latest month in the dataset is the 'current' month 
    -- of analysis.
	-- 1.   Aggregate Total_Monthly_Revenue by year and month (sale_date).
	-- 2.   Use the LAG() Window Function to retrieve the Total_Monthly_Revenue from 
    -- the previous month.
	-- Required Columns: Year, Month, Total_Monthly_Revenue, Previous_Month_Revenue,
    -- MoM_Growth_Percentage
    
    SELECT DATE_FORMAT(SALE_DATE,'%Y') AS YEARS , DATE_FORMAT(SALE_DATE,'%M') AS MONTHS , 
		SUM(QUANTITY_SOLD*SELLING_PRICE) AS TOT_MONTHLY_REV, 
        LAG(SUM(QUANTITY_SOLD*SELLING_PRICE) ) OVER () AS PREV_MONTH_REV
        ,(SUM(QUANTITY_SOLD*SELLING_PRICE)-LAG(SUM(QUANTITY_SOLD*SELLING_PRICE) ) OVER () )* 100/ 
        LAG(SUM(QUANTITY_SOLD*SELLING_PRICE)) OVER() AS 'MOM%'
        FROM SALES
        GROUP BY MONTHS,YEARS;
        

-- Task 2.4: Warehouse Efficiency Report
	-- Identify the top 3  warehouses based on the average daily sales volume.
	-- 1.   Group the data by warehouse_id and sale_date.
	-- 2.   Calculate the Total Quantity Sold per day per warehouse.
	-- 3.   Calculate the average of this daily quantity for each warehouse 
    -- across the entire dataset.
	-- Required Columns: location_city, manager, Average_Daily_Sales_Quantity, Daily_Sales_Rank.
	SELECT W.WAREHOUSE_ID,W.LOCATION_CITY, W.MANAGER,
		AVG(S.DAILY_QUANTITY)
        AS Average_Daily_Sales_Quantity
        ,RANK() OVER(ORDER BY AVG(S.DAILY_QUANTITY) DESC) AS RANK_
		FROM WAREHOUSES W ,
        (SELECT WAREHOUSE_ID,SALE_DATE,SUM(QUANTITY_SOLD) AS DAILY_QUANTITY 
			FROM SALES GROUP BY WAREHOUSE_ID,SALE_DATE)   S 
		WHERE S.WAREHOUSE_ID=W.WAREHOUSE_ID 
        GROUP BY W.WAREHOUSE_ID
        ORDER BY RANK_ LIMIT 3;
        
        
        SELECT MANAGER AS 'MGR' FROM WAREHOUSES ;
        
        
        SELECT * FROM SALES WHERE WAREHOUSE_ID=101