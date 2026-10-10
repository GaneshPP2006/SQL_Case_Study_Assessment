USE olist_ecommerce;

-- 1. Total number of orders
SELECT
    COUNT(*) AS total_orders
FROM orders;

-- 2. Order status distribution
SELECT
    order_status,
    COUNT(*) AS number_of_orders
FROM orders
GROUP BY order_status
ORDER BY number_of_orders DESC;

-- 3. Orders by year and month
SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    COUNT(*) AS total_orders
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY order_year, order_month;