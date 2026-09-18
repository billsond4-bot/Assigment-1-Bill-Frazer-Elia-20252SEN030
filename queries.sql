SELECT customers.customer_name, customers.city, orders.order_id, orders.order_date FROM customers JOIN orders ON customers.customer_id = orders.customer_id;
--Explanation: Shows order with customer name and city . I used JOIN on customer_id to connect tables. Got 15 rows.
SELECT order_items.order_id, products.product_name, products.category, products.price, order_items.quantity FROM order_items JOIN products ON order_items.product_id = products.product_id;
--Explanation: Shows product name, type, price and quality in each order.  Join on customer_id.
SELECT customers.customer_name, orders.order_id, orders.order_date FROM customers LEFT JOIN orders ON customers.customer_id = orders.customer_id;
--Explanation LEFT keeps all customers even if no order.
WITH customer_totals AS (SELECT customers.customer_name AS name, SUM(order_items.quantity * products.price) AS total_spent FROM customers JOIN orders ON customers.customer_id = orders.customer_id JOIN order_items ON orders.order_id = order_items.order_id JOIN products ON order_items.product_id = products.product_id GROUP BY customers.customer_name) SELECT * FROM customer_totals WHERE total_spent > (SELECT AVG(total_spent) FROM customer_totals);
--Explanation:  CTE calculates total per customer then filters above average.
SELECT customers.customer_name, SUM(order_items.quantity * products.price) AS total, RANK() OVER (ORDER BY SUM(order_items.quantity * products.price) DESC) AS my_rank FROM customers JOIN orders ON customers.customer_id = orders.customer_id JOIN order_items ON orders.order_id = order_items.order_id JOIN products ON order_items.product_id = products.product_id GROUP BY customers.customer_name;
--Explanation: RANK gives 1,2,3 by who spent most.
SELECT customer_id, order_id, order_date, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_num FROM orders;
--Explanation: Numbers each customer orders 1st, 2nd, 3rd.
SELECT orders.order_date, SUM(order_items.quantity * products.price) AS daily_revenue, SUM(SUM(order_items.quantity * products.price)) OVER (ORDER BY orders.order_date) AS running_total FROM orders JOIN order_items ON orders.order_id = order_items.order_id JOIN products ON order_items.product_id = products.product_id GROUP BY orders.order_date ORDER BY orders.order_date;
--Explanation:  Running total adds daily money to previous days.
SELECT customer_id, order_id, order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order, order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS days_between FROM orders;
--Explanation: LAG gets previous order date then subtract to get days between.
