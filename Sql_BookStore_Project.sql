#Objective: To analyze book store data using SQL to derive insights on customer behavior and revenue trends.

#Select the database
use booksstore;
#Check the tables in the database
show tables;
#Check structure of tables
desc books;
desc customers;
desc orders;
#Fix structure of tables

alter table books add primary key (book_id);
alter table orders add primary key (order_id);
alter table customers add primary key (customer_id);

ALTER TABLE Orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id);

ALTER TABLE Orders
ADD CONSTRAINT fk_book
FOREIGN KEY (book_id) REFERENCES Books(book_id);

#Data Validation
select * from books;
select * from orders;
select * from customers;

#TotalRevenue
SELECT round(SUM(o.quantity * b.price),2) AS total_revenue
FROM Orders o
JOIN Books b ON o.book_id = b.book_id;

#Total Orders
select count(order_id)as total_orders from orders;
# Total Customers
select count(Customer_ID) as total_customers from customers;

# Average Order Value

SELECT AVG(o.quantity * b.price) AS avg_order_value
FROM Orders o
JOIN Books b ON o.book_id = b.book_id;

# Top 5 Customers by Spending
select * from customers;
select * from orders;

select c.name,round(sum(o.quantity*o.total_amount),2) as total_spending_ from customers c
join orders o
on c.customer_id= o.customer_id
group by c.name
order by total_spending_ desc
limit 5;

# Best-Selling Books

select * from books;
select * from orders;

select b.book_id,sum(o.quantity) as total_quantity
from orders o
join books b on
b.book_id = o.book_id
group by o.book_id
order by total_quantity desc
limit 1;

# Revenue by Category genre
select * from books;

select * from orders;

select b.genre,round(sum(o.quantity*b.price),2)as revenue from orders o
join books b
on b.book_id = o.book_id
group by b.genre
order by revenue desc;

#Customers with No Orders

select * from customers;
select * from orders;

SELECT c.name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

#Monthly Sales Trend
SELECT 
DATE_FORMAT(order_date, '%Y-%m') AS month,
round(SUM(o.quantity * b.price),2) AS revenue
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY month
ORDER BY month;

#Repeat Customers
SELECT customer_id, COUNT(*) AS orders_count
FROM Orders
GROUP BY customer_id
HAVING orders_count > 1;

#Top 3 Customers by Spending

SELECT *
FROM (
    SELECT c.name,
    SUM(o.quantity * b.price) AS total_spent,
    DENSE_RANK() OVER (ORDER BY SUM(o.quantity * b.price) DESC) AS rnk
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
    JOIN Books b ON o.book_id = b.book_id
    GROUP BY c.name
) t
WHERE rnk <= 3;