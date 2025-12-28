SELECT * FROM customer;
#country wise customers

SELECT country,count(country) FROM customer
GROUP BY 1
ORDER BY count(country) DESC;

#INFERENCE:USA has more customers

#City with many customers

SELECT city,COUNT(id) FROM customer
GROUP BY city
ORDER BY COUNT(id) DESC;

#INFERENCE:london has most no. of customers

#first letter of first and last name to lower
SELECT lower(substr(firstname,1,1)),lower(substr(lastname,1,1)) from customer;

#FROM ORDERS TABLE
SELECT * FROM orders;
#customer with more no. of order
SELECT CustomerId,COUNT(CustomerId)
FROM orders
GROUP BY CustomerId
ORDER BY COUNT(CustomerId) DESC LIMIT 1;

#INFERENCE:CustomerId has more no. of orders

#YEAR WITH LEAST NO. OF ORDERS placed

SELECT COUNT(YEAR(OrderDate)),YEAR(Orderdate) FROM orders
GROUP BY YEAR(Orderdate) 
ORDER BY COUNT(YEAR(OrderDate)) LIMIT 1;

#INFERENCE:2012 WITH 152

#TOP 5 CUSTOMERS WITH MORE TOTAL REVENUE

SELECT Customerid,SUM(TotalAmount) FROM orders GROUP BY Customerid
ORDER BY SUM(TotalAmount) DESC LIMIT 5;

#INFERENCE:CustomerID 63 has the highest

#TOP 10 customers WHO ordered frequently

SELECT Customerid,SUM(TotalAmount) FROM orders GROUP BY Customerid
ORDER BY SUM(TotalAmount) DESC LIMIT 10; 

#MONTH With high no. of orders but low revenue
SELECT MONTH(orderdate),SUM(TotalAmount),COUNT(id)
FROM orders GROUP BY MONTH(orderdate)
ORDER BY COUNT(id) DESC ,SUM(TotalAmount) ASC;

#INFERENCE:Month 4

#TOTAL REVENUE IN FIRST QUARTER OF YEAR 2013

SELECT SUM(TOTALAMOUNT),QUARTER(ORDERDATE)
FROM ORDERS WHERE YEAR(orderdate)=2013
GROUP BY QUARTER(ORDERDATE);

#INFERENCE IN 1SR quarter , the revenue is 140000

#ORDERITEM TABLE
SELECT * FROM orderitem;

#TOP 3 MOST frequently ordered product

SELECT COUNT(ProductId),ProductId FROM  orderitem
GROUP BY ProductId
ORDER BY COUNT(ProductId) DESC LIMIT 3;

#INFERENCE:ProductId 59,24,31 are the frequently ordered product

#ORDER placed with more no. of products

SELECT Orderid,COUNT(Productid) FROM OrderItem GROUP BY Orderid ORDER BY COUNT(ProductId) DESC LIMIT 1;

#INFERENCE:ORDERID 830 placed orders with more no. of products

#Product Table

SELECT * FROM product;

#UNIQUE products supplied by each supplier

SELECT SupplierId ,	Count(DISTINCT id) FROM product GROUP BY SupplierId ORDER BY Count(id) DESC;

/*                       SQL - Supply Chain Case Study

“Richard’s Supply” is a company which deals with different food products. The
company is associated with a pool of suppliers. Every Supplier supplies
different types of food products to Richard’s supply. This company also receives
orders for food products from various customers. Each order may have multiple
products mentioned along with the quantity. The company is maintaining the
database for 2 years.

Refer to the following Entity-Relationship diagram of the database
 
Instruction to create a supply chain database:

Section A: Level 1 Questions
*/
-- 1.	Read the data from all the tables
select * from customer;
select * from Orders;
select * from Supplier;
select * from Product;
select * from OrderItem;

-- 2.	Find the country-wise count of customers. 
SELECT country,count(country) FROM customer
GROUP BY 1
ORDER BY count(country) DESC;
-- 3.	Display the products that are not discontinued.
 SELECT ProductName FROM product WHERE ISDISCONTINUED = 0;
-- 4.	Display the list of companies along with the product name that they are supplying. 
SELECT s.CompanyName, p.ProductName FROM supplier s JOIN Product p ON s.id=p.supplierId;
-- 5.	Display customer information about who stays in 'Mexico'
SELECT * FROM customer WHERE country='Mexico';
-- Additional: Level 1 questions
-- 6.	Display the costliest item that is ordered by the customer.
SELECT ProductId FROM orderitem ORDER BY UnitPrice DESC LIMIT 1;
-- 7.	Display supplier ID who owns the highest number of products.
SELECT SupplierId,COUNT(id) FROM product GROUP BY SupplierId ORDER BY COUNT(Id) DESC LIMIT 1;
-- 8.	Display month-wise and year-wise counts of the orders placed.
SELECT MONTH(orderdate),YEAR(Orderdate),COUNT(ID) FROM orders GROUP BY MONTH(orderdate),YEAR(Orderdate);
-- 9.	Which country has the maximum number of suppliers?
SELECT country,COUNT(country) FROM supplier GROUP BY country ORDER BY COUNT(country) DESC LIMIT 1;
-- 10.	Which customers did not place any orders?
SELECT c.id,concat_ws(' ',Firstname,lastname) FROM customer c LEFT JOIN ORDERS ON c.id=o.customerid WHERE o.id is null ;
-- Section B: Level 2 Questions:

-- 1.	Arrange the Product ID and Name based on the high demand by the customer.
SELECT ProductID,ProductName,COUNT(orderid) FROM orderitem oi JOIN Product p ON p.id=oi.productid GROUP BY ProductID,ProductName ORDER BY COUNT(orderid) DESC;

#BY quantity
SELECT ProductID,ProductName,Count(Quantity) FROM orderitem oi JOIN Product p ON p.id=oi.productid GROUP BY ProductID,ProductName ORDER BY COUNT(Quantity) DESC;
-- 2.	Display the total number of orders delivered every year
SELECT YEAR(orderdate),COUNT(id) FROM orders GROUP BY YEAR(orderdate);
-- 3.	Calculate year-wise total revenue. 
SELECT YEAR(orderdate),SUM(TotalAmount) FROM orders GROUP BY YEAR(orderdate);
-- 4.	Display the customer details whose order amount is maximum including his past orders. 
SELECT C.*,SUM(TotalAmount) FROM customer c JOIN ORDERS O ON c.id=o.customerid GROUP BY C.ID ORDER BY SUM(TotalAmount) DESC LIMIT 1;
-- 5.	Display the total amount ordered by each customer from high to low.
SELECT CustomerId,SUM(Totalamount) FROM orders GROUP BY CustomerId  ORDER BY SUM(Totalamount) DESC;
-- Additional Level 2 Questions:
-- The sales and marketing department of this company wants to find out how frequently customers do business with them. (Answer Q 6 for the same) 

-- 6.	Approach - List the current and previous order dates for each customer.

-- 7.	 Find out the top 3 suppliers in terms of revenue generated by their products. 
SELECT p.supplierId , SUM(oi.UnitPrice*Quantity),productid FROM orderitem oi
JOIN product p ON oi.productid=p.id GROUP BY productid  ORDER BY SUM(oi.UnitPrice*Quantity) DESC LIMIT 3;
-- 8.	Display the latest order date (should not be the same as the first order date) of all the customers with customer details. 
SELECT c.*,MAX(orderdate) FROM customer c JOIN orders o ON c.id=o.CustomerId GROUP BY c.id HAVING COUNT(o.id)>1;
-- 9.	Display the product name and supplier name for each order
SELECT oi.OrderId,p.id,ProductName,s.companyname,s.ContactName FROM product p JOIN supplier s ON p.supplierid=s.id JOIN orderitem oi ON p.id=oi.ProductId;

-- Section C: Level 3 Questions:

-- 1.	Fetch the customer details who ordered more than 10 products in a single order.
SELECT DISTINCT c.* FROM  customer c 
JOIN orders o ON c.id=o.customerid 
JOIN orderitem oi ON o.id=oi.OrderId
 GROUP BY o.id,c.id HAVING count(oi.ProductId)>10;
-- 2.	Display all the product details with the ordered quantity size as 1. 
SELECT DISTINCT P.* 
FROM product p JOIN orderitem oi
ON p.id=oi.productid WHERE Quantity=1;
-- 3.	Display the companies that supply products whose cost is above 100.
SELECT DISTINCT CompanyName FROM Supplier s JOIN product p ON s.id=p.SupplierId WHERE unitprice>100;
-- 4.	Create a combined list to display customers and supplier lists as per the below format.
 SELECT 
  CONCAT_WS(' ', FirstName, LastName) AS Name,
  NULL AS CompanyName,
  NULL AS ContactName
FROM customer

UNION

SELECT 
  NULL AS Name,
  CompanyName,
  ContactName
FROM supplier;


-- 5.	Display the customer list who belongs to the same city and country arranged country-wise
SELECT DISTINCT c1.*
FROM customer c1
JOIN customer c2
  ON c1.city = c2.city
 AND c1.country = c2.country
 AND c1.id <> c2.id
ORDER BY c1.country;

-- Section D: Level 4 Questions:
-- 1.	The company sells the products at different discount rates.
-- Refer actual product price in the product table and the selling price in the order item table.
-- Write a query to find out the total amount saved in each order then display the orders from highest to lowest amount saved. 
SELECT oi.orderid, SUM((p.unitprice*oi.quantity)-(oi.UnitPrice*oi.quantity)) FROM orderitem oi JOIN product p ON oi.ProductId=p.id GROUP BY oi.orderid ORDER BY  SUM((p.unitprice*oi.quantity)-(oi.UnitPrice*oi.quantity))  DESC ;
-- 2.	Mr. Kavin wants to become a supplier. He got the database of "Richard's Supply" for reference. Help him to pick: 
-- a.	List a few products that he should choose based on demand.
SELECT ProductName,COUNT(orderid) 
FROM orderitem oi
JOIN product p ON p.id=oi.productid
GROUP BY ProductName
ORDER BY COUNT(orderid) DESC LIMIT 7;
-- b.	Who will be the competitors for him for the products suggested in the above questions? 
SELECT p.id,p.productname,companyname,contactname FROM product p JOIN
(SELECT ProductID,COUNT(orderid) 
FROM orderitem oi
JOIN product p ON p.id=oi.productid
GROUP BY ProductId
ORDER BY COUNT(orderid) DESC LIMIT 7) as temp 
ON p.id=temp.productid
JOIN supplier s
ON s.id=p.supplierid;
-- 3.	Create a combined list to display customers' and suppliers' details considering the following criteria 
-- a.	Both customer and supplier belong to the same country 
SELECT c.*,s.* FROM supplier s JOIN customer c ON s.country=c.country UNION
 
-- b.	Customers who do not have a supplier in their country
SELECT c.*,s.* FROM customer c LEFT JOIN supplier s ON s.country=c.country WHERE s.id is null UNION
-- c.	A supplier who does not have customers in their country 
SELECT c.*,s.* FROM customer c RIGHT JOIN supplier s ON s.country=c.country WHERE c.id is null;
-- 4.	Find out for which products, the UK is dependent on other countries for the supply. List the countries which are supplying these products in the same list.
SELECT p.id,p.ProductName FROM customer c
JOIN orders o ON o.customerid=c.id
JOIN orderitem oi ON oi.orderid=o.id 
JOIN product p ON p.id=oi.productid 
JOIN supplier s ON s.id=p.supplierid 
WHERE c.country='UK' AND s.country<>'UK'; 


