USE olist_ecommerce;

-- Top 10 product categories by sales value
SELECT
    COALESCE(
        ct.product_category_name_english,
        'Unknown'
    ) AS product_category,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS product_sales_value
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY product_sales_value DESC
LIMIT 10;

-- 2. Top 10 products by number of items sold
SELECT
    oi.product_id,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS product_sales_value
FROM order_items oi
GROUP BY oi.product_id
ORDER BY items_sold DESC
LIMIT 10;