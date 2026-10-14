USE QUICKKART_DB ;
SELECT * FROM CUSTOMERS;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM returns;
SELECT * FROM order_items;
SELECT * FROM marketing_leads;
-- 1
SELECT * FROM CUSTOMERS WHERE CITY ='CHENNAI';

-- 2
SELECT product_name ,category , unit_price
FROM products 
WHERE status = 'Active';

-- 3
SELECT * FROM orders
WHERE payment_mode = 'UPI';

-- 4
SELECT * FROM order_items
ORDER BY selling_price DESC;

-- 5
SELECT * FROM CUSTOMERS 
WHERE CUSTOMER_TYPE='Premium' AND CITY IN ('Chennai','Banglore');

-- 6
SELECT * FROM PRODUCTS WHERE STATUS = 'Inctive';

-- 7 
SELECT 
	ORDER_ID AS order_number,
    ORDER_DATE AS date_of_purchase,
    order_status,payment_mode 
FROM ORDERS;

-- 8
select sum(distinct(customer_id)) from customers;

-- 9
select sum(stock_quantity) as Total_Stock  from products;

-- 10 
select avg(selling_price) 
from (
select DISTINCT(product_id),selling_price from order_items) as a;

-- 11
select Min(selling_price) as Min_prod_price ,Max(selling_price) as Max_Prod_price
from order_items;

-- 12 
select order_id , sum(selling_price* quantity) as generated_revenue
from order_items
group by order_id;

-- 13 
select p.category , sum(o.quantity*o.selling_price) as category_total_revenue 
from order_items as o 
inner join products as p
on o.product_id = p.product_id
group by p.category;

-- 14 
select category, count(distinct(product_id))
from products
group by category ;

select * from orders;
-- 15
select * from orders 
where order_status='Delivered' and payment ='UPI';

-- 16 
select email from marketing_leads
Union 
select email from customers;

-- 18
select lead_name from marketing_leads
except 
select customer_name from customers;

-- 17
select lead_name from marketing_leads
Intersect 
select customer_name from customers;

-- 19 
START TRANSACTION ;
UPDATE PRODUCTS P
        JOIN
    ORDER_ITEMS OD ON P.PRODUCT_ID = OD.PRODUCT_ID 
SET 
    P.STOCK_QUANTITY = P.STOCK_QUANTITY - OD.QUANTITY
WHERE
    OD.ORDER_ID = 1001;
COMMIT;

SELECT * FROM PRODUCTS;
-- 20
delete from orders where order_id ='1004';
rollback;

INSERT INTO customers 
(customer_id, customer_name, city, state, email, customer_type, registered_date)
VALUES
(9, 'Anand Kumar', 'Chennai', 'Tamil Nadu', 'anand.kumar@gmail.com', 'Premium', '2024-11-10');


UPDATE customers  SET CUSTOMER_TYPE='Premium' where customer_id =2;

DELETE FROM PRODUCTS WHERE STATUS='Inactive';