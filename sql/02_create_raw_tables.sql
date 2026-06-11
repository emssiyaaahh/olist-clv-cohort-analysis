/*
Phase 3 Script 02
Project: Olist D2C E-Commerce Cohort Analysis & CLV Engine
Purpose: Create raw landing tables aligned to the original Olist CSV headers.
Note: Raw tables intentionally use mostly NVARCHAR to preserve source data and prevent ingestion failures.
*/

USE OlistCLVAnalytics;
GO

DROP TABLE IF EXISTS raw.olist_order_reviews;
DROP TABLE IF EXISTS raw.olist_order_payments;
DROP TABLE IF EXISTS raw.olist_order_items;
DROP TABLE IF EXISTS raw.olist_orders;
DROP TABLE IF EXISTS raw.olist_customers;
DROP TABLE IF EXISTS raw.olist_products;
DROP TABLE IF EXISTS raw.product_category_name_translation;
DROP TABLE IF EXISTS raw.olist_sellers;
DROP TABLE IF EXISTS raw.olist_geolocation;
GO

CREATE TABLE raw.olist_customers (
    customer_id NVARCHAR(50) NULL,
    customer_unique_id NVARCHAR(50) NULL,
    customer_zip_code_prefix NVARCHAR(20) NULL,
    customer_city NVARCHAR(100) NULL,
    customer_state NVARCHAR(10) NULL
);
GO

CREATE TABLE raw.olist_orders (
    order_id NVARCHAR(50) NULL,
    customer_id NVARCHAR(50) NULL,
    order_status NVARCHAR(30) NULL,
    order_purchase_timestamp NVARCHAR(30) NULL,
    order_approved_at NVARCHAR(30) NULL,
    order_delivered_carrier_date NVARCHAR(30) NULL,
    order_delivered_customer_date NVARCHAR(30) NULL,
    order_estimated_delivery_date NVARCHAR(30) NULL
);
GO

CREATE TABLE raw.olist_order_items (
    order_id NVARCHAR(50) NULL,
    order_item_id NVARCHAR(20) NULL,
    product_id NVARCHAR(50) NULL,
    seller_id NVARCHAR(50) NULL,
    shipping_limit_date NVARCHAR(30) NULL,
    price NVARCHAR(30) NULL,
    freight_value NVARCHAR(30) NULL
);
GO

CREATE TABLE raw.olist_order_payments (
    order_id NVARCHAR(50) NULL,
    payment_sequential NVARCHAR(20) NULL,
    payment_type NVARCHAR(50) NULL,
    payment_installments NVARCHAR(20) NULL,
    payment_value NVARCHAR(30) NULL
);
GO

CREATE TABLE raw.olist_order_reviews (
    review_id NVARCHAR(50) NULL,
    order_id NVARCHAR(50) NULL,
    review_score NVARCHAR(20) NULL,
    review_comment_title NVARCHAR(MAX) NULL,
    review_comment_message NVARCHAR(MAX) NULL,
    review_creation_date NVARCHAR(30) NULL,
    review_answer_timestamp NVARCHAR(30) NULL
);
GO

CREATE TABLE raw.olist_products (
    product_id NVARCHAR(50) NULL,
    product_category_name NVARCHAR(100) NULL,
    product_name_lenght NVARCHAR(20) NULL,
    product_description_lenght NVARCHAR(20) NULL,
    product_photos_qty NVARCHAR(20) NULL,
    product_weight_g NVARCHAR(30) NULL,
    product_length_cm NVARCHAR(30) NULL,
    product_height_cm NVARCHAR(30) NULL,
    product_width_cm NVARCHAR(30) NULL
);
GO

CREATE TABLE raw.product_category_name_translation (
    product_category_name NVARCHAR(100) NULL,
    product_category_name_english NVARCHAR(100) NULL
);
GO

CREATE TABLE raw.olist_sellers (
    seller_id NVARCHAR(50) NULL,
    seller_zip_code_prefix NVARCHAR(20) NULL,
    seller_city NVARCHAR(100) NULL,
    seller_state NVARCHAR(10) NULL
);
GO

CREATE TABLE raw.olist_geolocation (
    geolocation_zip_code_prefix NVARCHAR(20) NULL,
    geolocation_lat NVARCHAR(50) NULL,
    geolocation_lng NVARCHAR(50) NULL,
    geolocation_city NVARCHAR(100) NULL,
    geolocation_state NVARCHAR(10) NULL
);
GO

PRINT 'Raw landing tables created successfully.';
