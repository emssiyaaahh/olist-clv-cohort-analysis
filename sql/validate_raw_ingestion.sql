/*
Phase 3 Script 04
Project: Olist D2C E-Commerce Cohort Analysis & CLV Engine
Purpose: Validate raw ingestion row counts, uniqueness, and basic join readiness.
*/

USE OlistCLVAnalytics;
GO

-- 1. Row count validation
WITH expected_counts AS (
    SELECT 'raw.olist_customers' AS table_name, 99441 AS expected_rows UNION ALL
    SELECT 'raw.olist_orders', 99441 UNION ALL
    SELECT 'raw.olist_order_items', 112650 UNION ALL
    SELECT 'raw.olist_order_payments', 103886 UNION ALL
    SELECT 'raw.olist_order_reviews', 99224 UNION ALL
    SELECT 'raw.olist_products', 32951 UNION ALL
    SELECT 'raw.product_category_name_translation', 71 UNION ALL
    SELECT 'raw.olist_sellers', 3095 UNION ALL
    SELECT 'raw.olist_geolocation', 1000163
), actual_counts AS (
    SELECT 'raw.olist_customers' AS table_name, COUNT(*) AS actual_rows FROM raw.olist_customers UNION ALL
    SELECT 'raw.olist_orders', COUNT(*) FROM raw.olist_orders UNION ALL
    SELECT 'raw.olist_order_items', COUNT(*) FROM raw.olist_order_items UNION ALL
    SELECT 'raw.olist_order_payments', COUNT(*) FROM raw.olist_order_payments UNION ALL
    SELECT 'raw.olist_order_reviews', COUNT(*) FROM raw.olist_order_reviews UNION ALL
    SELECT 'raw.olist_products', COUNT(*) FROM raw.olist_products UNION ALL
    SELECT 'raw.product_category_name_translation', COUNT(*) FROM raw.product_category_name_translation UNION ALL
    SELECT 'raw.olist_sellers', COUNT(*) FROM raw.olist_sellers UNION ALL
    SELECT 'raw.olist_geolocation', COUNT(*) FROM raw.olist_geolocation
)
SELECT
    e.table_name,
    e.expected_rows,
    a.actual_rows,
    a.actual_rows - e.expected_rows AS row_count_difference,
    CASE WHEN a.actual_rows = e.expected_rows THEN 'PASS' ELSE 'CHECK' END AS validation_status
FROM expected_counts e
JOIN actual_counts a
    ON e.table_name = a.table_name
ORDER BY e.table_name;
GO

-- 2. Primary/natural key duplicate checks
SELECT 'raw.olist_customers.customer_id' AS check_name, COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_count FROM raw.olist_customers
UNION ALL
SELECT 'raw.olist_orders.order_id', COUNT(*) - COUNT(DISTINCT order_id) FROM raw.olist_orders
UNION ALL
SELECT 'raw.olist_products.product_id', COUNT(*) - COUNT(DISTINCT product_id) FROM raw.olist_products
UNION ALL
SELECT 'raw.olist_sellers.seller_id', COUNT(*) - COUNT(DISTINCT seller_id) FROM raw.olist_sellers
UNION ALL
SELECT 'raw.product_category_name_translation.product_category_name', COUNT(*) - COUNT(DISTINCT product_category_name) FROM raw.product_category_name_translation;
GO

-- 3. Composite key duplicate checks
SELECT
    'raw.olist_order_items.order_id + order_item_id' AS check_name,
    COUNT(*) - COUNT(DISTINCT CONCAT(order_id, '|', order_item_id)) AS duplicate_count
FROM raw.olist_order_items
UNION ALL
SELECT
    'raw.olist_order_payments.order_id + payment_sequential',
    COUNT(*) - COUNT(DISTINCT CONCAT(order_id, '|', payment_sequential))
FROM raw.olist_order_payments;
GO

-- 4. Join readiness checks
SELECT
    'orders_without_matching_customer' AS check_name,
    COUNT(*) AS issue_count
FROM raw.olist_orders o
LEFT JOIN raw.olist_customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL
UNION ALL
SELECT
    'order_items_without_matching_order',
    COUNT(*)
FROM raw.olist_order_items oi
LEFT JOIN raw.olist_orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL
UNION ALL
SELECT
    'payments_without_matching_order',
    COUNT(*)
FROM raw.olist_order_payments p
LEFT JOIN raw.olist_orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL
UNION ALL
SELECT
    'reviews_without_matching_order',
    COUNT(*)
FROM raw.olist_order_reviews r
LEFT JOIN raw.olist_orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL
UNION ALL
SELECT
    'order_items_without_matching_product',
    COUNT(*)
FROM raw.olist_order_items oi
LEFT JOIN raw.olist_products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL
UNION ALL
SELECT
    'order_items_without_matching_seller',
    COUNT(*)
FROM raw.olist_order_items oi
LEFT JOIN raw.olist_sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;
GO

-- 5. Basic convertibility checks for staging readiness
SELECT 'order_purchase_timestamp_not_convertible' AS check_name, COUNT(*) AS issue_count
FROM raw.olist_orders
WHERE order_purchase_timestamp IS NOT NULL
  AND TRY_CONVERT(DATETIME2, order_purchase_timestamp) IS NULL
UNION ALL
SELECT 'price_not_convertible', COUNT(*)
FROM raw.olist_order_items
WHERE price IS NOT NULL
  AND TRY_CONVERT(DECIMAL(18,2), price) IS NULL
UNION ALL
SELECT 'freight_value_not_convertible', COUNT(*)
FROM raw.olist_order_items
WHERE freight_value IS NOT NULL
  AND TRY_CONVERT(DECIMAL(18,2), freight_value) IS NULL
UNION ALL
SELECT 'payment_value_not_convertible', COUNT(*)
FROM raw.olist_order_payments
WHERE payment_value IS NOT NULL
  AND TRY_CONVERT(DECIMAL(18,2), payment_value) IS NULL
UNION ALL
SELECT 'review_score_outside_1_to_5', COUNT(*)
FROM raw.olist_order_reviews
WHERE TRY_CONVERT(INT, review_score) NOT BETWEEN 1 AND 5;
GO

-- 6. Preview ingestion log
SELECT *
FROM audit.ingestion_log
ORDER BY logged_at DESC, ingestion_log_id DESC;
GO
