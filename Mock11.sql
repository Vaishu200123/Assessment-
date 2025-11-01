-- create table customers(customer_id int, customer_name varchar, city varchar)
-- create table orders1(order_id int, customer_id int, order_date date, total_amount int, status varchar)
-- create table payments(payment_id varchar, order_id int, payment_date date, payment_amount int)
-- SELECT o.order_id, o.order_date, p.payment_date, p.payment_amount
-- FROM orders1 o
-- JOIN payments p ON o.order_id = p.order_id
-- WHERE p.payment_date < o.order_date;


-- SELECT o1.order_id, o1.customer_id, o1.total_amount
-- FROM Orders1 o1
-- JOIN Orders1 o2 
--   ON o1.total_amount = o2.total_amount 
--  AND o1.customer_id <> o2.customer_id;

-- SELECT 
--     c.customer_name,
--     o.order_date,
--     o.total_amount,
--     p.payment_amount
-- FROM Customers c
-- JOIN Orders1 o ON c.customer_id = o.customer_id
-- LEFT JOIN Payments p ON o.order_id = p.order_id;

-- SELECT DISTINCT c.customer_id, c.customer_name
-- FROM Customers c
-- JOIN Orders1 o ON c.customer_id = o.customer_id
-- JOIN Payments p ON o.order_id = p.order_id
-- WHERE o.status = 'Delivered';

-- select* from orders1

-- SELECT o.customer_id, o.order_id, o.order_date, o.total_amount, o.total_amount - LAG(o.total_amount) 
--         OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS diff_from_prev_order FROM Orders1 o
-- ORDER BY o.customer_id, o.order_date;

-- SELECT  o.customer_id, o.order_id, o.order_date,
--     LEAD(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS next_order_date
-- FROM Orders1 o
-- ORDER BY o.customer_id, o.order_date;

-- SELECT c.city, c.customer_id, c.customer_name, SUM(o.total_amount) AS total_spent,
--     RANK() OVER (PARTITION BY c.city ORDER BY SUM(o.total_amount) DESC) AS city_rank FROM Customers c
-- JOIN Orders1 o ON c.customer_id = o.customer_id
-- GROUP BY c.city, c.customer_id, c.customer_name;

WITH diffs AS (
    SELECT o.customer_id, o.order_id, o.order_date,
        (LAG(o.total_amount) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) - o.total_amount) AS drop_amt
    FROM Orders1 o)
SELECT customer_id, MAX(drop_amt) AS biggest_drop
FROM diffs
WHERE drop_amt > 0
GROUP BY customer_id;


