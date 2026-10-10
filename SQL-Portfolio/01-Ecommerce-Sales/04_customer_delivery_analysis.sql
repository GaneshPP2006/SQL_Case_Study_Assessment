USE olist_ecommerce;

-- 1. Top 10 customers by total payment value
SELECT
    o.customer_id,
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_payments p
    ON o.order_id = p.order_id
GROUP BY o.customer_id, c.customer_unique_id
ORDER BY total_payment_value DESC
LIMIT 10;

-- 2. Delivery performance
SELECT
    order_status,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date THEN 1
            ELSE 0
        END
    ) AS delivered_late
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY order_status
ORDER BY total_orders DESC;

-- 3. Average delivery time in days
SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ), 2
    ) AS avg_days_from_purchase_to_delivery
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;