USE olist_ecommerce;

-- 1. Total payment value recorded
SELECT
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM order_payments;

-- 2. Payment methods used
SELECT
    payment_type,
    COUNT(*) AS payment_records,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;

-- 3. Monthly payment value
SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    ROUND(SUM(p.payment_value), 2) AS monthly_payment_value
FROM orders o
JOIN order_payments p
    ON o.order_id = p.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY order_year, order_month;
