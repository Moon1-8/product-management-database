-- ============================================================
-- Product Management Database - SQL Queries
-- Basic -> Intermediate -> Advanced (joins, grouping, subqueries,
-- window functions, CTEs, conditional reporting)
-- ============================================================

USE product_management_db;

-- 1. List all products
SELECT * FROM products;

-- 2. Customers from Hyderabad
SELECT * FROM customers WHERE city = 'Hyderabad';

-- 3. Products priced above 500
SELECT product_name, price FROM products WHERE price > 500;

-- 4. Orders newest first
SELECT * FROM orders ORDER BY order_date DESC;

-- 5. Count total products
SELECT COUNT(*) AS total_products FROM products;

-- 6. Cheapest and most expensive
SELECT MIN(price) AS cheapest, MAX(price) AS most_expensive FROM products;

-- 7. Distinct customer cities
SELECT DISTINCT city FROM customers;

-- 8. Pending orders
SELECT * FROM orders WHERE status = 'Pending';

-- 9. Product names starting with B
SELECT product_name FROM products WHERE product_name LIKE 'B%';

-- 10. Top 5 expensive products
SELECT product_name, price FROM products ORDER BY price DESC LIMIT 5;

-- 11. Products with category name
SELECT p.product_name, c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id;

-- 12. Customers and their orders
SELECT cu.first_name, cu.last_name, o.order_id, o.order_date
FROM customers cu
LEFT JOIN orders o ON cu.customer_id = o.customer_id;

-- 13. Total quantity sold per product
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

-- 14. Orders per customer
SELECT cu.first_name, cu.last_name, COUNT(o.order_id) AS num_orders
FROM customers cu
LEFT JOIN orders o ON cu.customer_id = o.customer_id
GROUP BY cu.customer_id;

-- 15. Categories with more than 1 product
SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) > 1;

-- 16. Products never ordered
SELECT p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- 17. Average line value per order
SELECT o.order_id, ROUND(AVG(oi.quantity * oi.unit_price), 2) AS avg_line_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

-- 18. Supplier-wise product count
SELECT s.supplier_name, COUNT(p.product_id) AS products_supplied
FROM suppliers s
LEFT JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name
ORDER BY products_supplied DESC;

-- 19. Orders in August 2026
SELECT * FROM orders WHERE order_date BETWEEN '2026-08-01' AND '2026-08-31';

-- 20. Low / out-of-stock products
SELECT p.product_name, i.quantity_in_stock, i.reorder_level
FROM products p
JOIN inventory i ON p.product_id = i.product_id
WHERE i.quantity_in_stock <= i.reorder_level;

-- 21. Products above average price
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- 22. Customer who spent the most
SELECT cu.first_name, cu.last_name, total_spent
FROM customers cu
JOIN (
    SELECT o.customer_id, SUM(oi.quantity * oi.unit_price) total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) spend ON cu.customer_id = spend.customer_id
WHERE total_spent = (
    SELECT MAX(total_spent) FROM (
        SELECT SUM(oi.quantity * oi.unit_price) total_spent
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        GROUP BY o.customer_id
    ) sub
);

-- 23. Rank products by revenue
SELECT p.product_name, SUM(oi.quantity * oi.unit_price) revenue,
       RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) revenue_rank
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

-- 24. Running revenue total by date
SELECT o.order_date, SUM(oi.quantity * oi.unit_price) daily_revenue,
       SUM(SUM(oi.quantity * oi.unit_price)) OVER (ORDER BY o.order_date) running_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- 25. Most recent order per customer
SELECT customer_id, order_id, order_date FROM (
    SELECT customer_id, order_id, order_date,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) rn
    FROM orders
) ranked
WHERE rn = 1;

-- 26. Category contribution to revenue
SELECT c.category_name, SUM(oi.quantity * oi.unit_price) category_revenue,
       ROUND(SUM(oi.quantity * oi.unit_price) * 100.0 /
             (SELECT SUM(oi2.quantity * oi2.unit_price) FROM order_items oi2), 2) pct_of_total
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY pct_of_total DESC;

-- 27. Customers buying from more than one category
SELECT cu.first_name, cu.last_name, COUNT(DISTINCT c.category_id) categories_bought
FROM customers cu
JOIN orders o ON cu.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY cu.customer_id
HAVING COUNT(DISTINCT c.category_id) > 1;

-- 28. Month-over-month revenue growth
SELECT month, revenue, revenue - LAG(revenue) OVER (ORDER BY month) change_from_prev_month
FROM (
    SELECT DATE_FORMAT(o.order_date, '%Y-%m') month, SUM(oi.quantity * oi.unit_price) revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY month
) monthly
ORDER BY month;

-- 29. Top 3 products by category
WITH product_revenue AS (
    SELECT p.product_id, p.product_name, c.category_name,
           SUM(oi.quantity * oi.unit_price) revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    GROUP BY p.product_id, p.product_name, c.category_name
),
ranked_products AS (
    SELECT *, RANK() OVER (PARTITION BY category_name ORDER BY revenue DESC) rnk
    FROM product_revenue
)
SELECT category_name, product_name, revenue
FROM ranked_products
WHERE rnk <= 3;

-- 30. Full order summary
WITH order_totals AS (
    SELECT o.order_id, o.customer_id, o.status,
           SUM(oi.quantity * oi.unit_price) order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.customer_id, o.status
)
SELECT cu.first_name, cu.last_name, ot.order_id, ot.status, ot.order_total,
       CASE
           WHEN ot.order_total >= 2000 THEN 'High Value'
           WHEN ot.order_total >= 500 THEN 'Medium Value'
           ELSE 'Low Value'
       END order_segment
FROM order_totals ot
JOIN customers cu ON ot.customer_id = cu.customer_id
ORDER BY ot.order_total DESC;
