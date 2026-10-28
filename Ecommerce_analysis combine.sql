CREATE DATABASE ecommerce_analysis;

USE ecommerce_analysis;

USE ecommerce_analysis;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

ecommerce_analysis;

INSERT INTO customers (customer_id, customer_name, city, country)
VALUES
(1, 'Aarav Sharma', 'Delhi', 'India'),
(2, 'Priya Verma', 'Mumbai', 'India'),
(3, 'Rohan Mehta', 'Bengaluru', 'India'),
(4, 'Ananya Singh', 'Delhi', 'India'),
(5, 'Kabir Patel', 'Ahmedabad', 'India'),
(6, 'Sneha Gupta', 'Jaipur', 'India'),
(7, 'Arjun Reddy', 'Hyderabad', 'India'),
(8, 'Isha Kapoor', 'Pune', 'India'),
(9, 'Dev Malhotra', 'Chandigarh', 'India'),
(10, 'Meera Joshi', 'Lucknow', 'India');

SELECT * FROM customers;

USE ecommerce_analysis;

INSERT INTO products (product_id, product_name, category, price)
VALUES
(101, 'Laptop', 'Electronics', 55000.00),
(102, 'Smartphone', 'Electronics', 25000.00),
(103, 'Headphones', 'Electronics', 2000.00),
(104, 'Office Chair', 'Furniture', 7500.00),
(105, 'Study Table', 'Furniture', 12000.00),
(106, 'Notebook Set', 'Stationery', 300.00),
(107, 'Pen Pack', 'Stationery', 150.00),
(108, 'Backpack', 'Accessories', 1800.00),
(109, 'Wrist Watch', 'Accessories', 3500.00),
(110, 'Wireless Mouse', 'Electronics', 800.00);

select * from products

USE ecommerce_analysis;

INSERT INTO orders (order_id, customer_id, order_date, order_status)
VALUES
(1001, 1, '2026-01-05', 'Delivered'),
(1002, 2, '2026-01-08', 'Delivered'),
(1003, 3, '2026-01-12', 'Delivered'),
(1004, 1, '2026-02-02', 'Delivered'),
(1005, 4, '2026-02-10', 'Shipped'),
(1006, 5, '2026-02-15', 'Delivered'),
(1007, 6, '2026-03-01', 'Delivered'),
(1008, 2, '2026-03-05', 'Cancelled'),
(1009, 7, '2026-03-12', 'Delivered'),
(1010, 8, '2026-03-20', 'Shipped'),
(1011, 3, '2026-04-02', 'Delivered'),
(1012, 9, '2026-04-10', 'Delivered'),
(1013, 10, '2026-04-18', 'Delivered'),
(1014, 4, '2026-05-05', 'Delivered'),
(1015, 1, '2026-05-15', 'Delivered');

select * from orders

USE ecommerce_analysis;

INSERT INTO order_items
(order_item_id, order_id, product_id, quantity, selling_price)
VALUES
(1, 1001, 101, 1, 55000.00),
(2, 1001, 103, 2, 2000.00),
(3, 1002, 102, 1, 25000.00),
(4, 1002, 108, 1, 1800.00),
(5, 1003, 104, 2, 7500.00),
(6, 1004, 103, 1, 2000.00),
(7, 1004, 110, 2, 800.00),
(8, 1005, 105, 1, 12000.00),
(9, 1006, 106, 5, 300.00),
(10, 1007, 107, 4, 150.00),
(11, 1008, 102, 1, 25000.00),
(12, 1009, 101, 1, 55000.00),
(13, 1009, 109, 1, 3500.00),
(14, 1010, 108, 2, 1800.00),
(15, 1011, 104, 1, 7500.00),
(16, 1012, 105, 2, 12000.00),
(17, 1013, 103, 3, 2000.00),
(18, 1014, 102, 2, 25000.00),
(19, 1015, 110, 3, 800.00),
(20, 1015, 106, 10, 300.00);

select * from order_items

##1. How much revenue have we generated from delivered orders?

SELECT
    SUM(oi.quantity * oi.selling_price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered';

##2.  Which product category generates the highest revenue?
USE ecommerce_analysis;

select
p.category,
    SUM(oi.quantity * oi.selling_price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY total_revenue DESC;

##3.Who are the top 5 highest-spending customers?

USE ecommerce_analysis;

select
     c.customer_name,
     SUM(oi.quantity * oi.selling_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

##4. Which products have never been ordered?

USE ecommerce_analysis;

select
    p.product_id,
    p.product_name
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;    

##5. which month generated the highest revenue?

SELECT
    MONTHNAME(o.order_date) AS month,
    SUM(oi.quantity * oi.selling_price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)
ORDER BY total_revenue DESC;

##6.  What is the average order value?

SELECT AVG(order_total) AS average_order_value
FROM (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.selling_price) AS order_total
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_id
) AS order_totals;

##7.  How many orders has each customer placed?

select
	customer_id,
    count(order_id) as Total_order
FROM orders    
group by customer_id
order by Total_order desc;

##8. Which cities do our customers come from?

select
     city,
     count(customer_id) as Total_customers
from customers
group by city     
order by Total_customers desc;

##9. # Which products have generated the highest revenue?

SELECT
    p.product_name,
    SUM(oi.quantity * oi.selling_price) AS total_revenue
FROM products AS p
JOIN order_items AS oi
    ON p.product_id = oi.product_id
JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;

##10. Which orders have a total value greater than ₹20,000?

select
     o.order_id,
     sum(oi.quantity * oi.selling_price) as order_total
from orders as o
join order_items as oi
    on o.order_id = oi.order_id
where o.order_id = 'Delivered'
group by o.order_id
having order_total > 20000
order by order_total desc;  

##11. Which customers have placed more than one order?

select
      c.customer_name,
      count(o.order_id) as Total_orders
from customers as c
join orders as o
   on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having COUNT(o.order_id) > 1
order by total_orders desc;  


