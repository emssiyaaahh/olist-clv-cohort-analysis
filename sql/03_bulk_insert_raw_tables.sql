/*
Phase 3 Script 03
Project: Olist D2C E-Commerce Cohort Analysis & CLV Engine
Purpose: Load raw CSV files into SQL Server raw tables using BULK INSERT.

Before running:
1. Copy all CSV files to C:\olist_data\raw\ on the SQL Server machine.
2. Make sure the SQL Server service account has read access to the folder.
3. If review comments cause CSV parsing issues, use scripts/03_load_raw_csv_to_sql_server.py instead.
*/

USE OlistCLVAnalytics;
GO

TRUNCATE TABLE raw.olist_customers;
TRUNCATE TABLE raw.olist_orders;
TRUNCATE TABLE raw.olist_order_items;
TRUNCATE TABLE raw.olist_order_payments;
TRUNCATE TABLE raw.olist_order_reviews;
TRUNCATE TABLE raw.olist_products;
TRUNCATE TABLE raw.product_category_name_translation;
TRUNCATE TABLE raw.olist_sellers;
TRUNCATE TABLE raw.olist_geolocation;
GO

BULK INSERT raw.olist_customers
FROM 'C:\olist_data\raw\olist_customers_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

BULK INSERT raw.olist_orders
FROM 'C:\olist_data\raw\olist_orders_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

BULK INSERT raw.olist_order_items
FROM 'C:\olist_data\raw\olist_order_items_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

BULK INSERT raw.olist_order_payments
FROM 'C:\olist_data\raw\olist_order_payments_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

BULK INSERT raw.olist_order_reviews
FROM 'C:\olist_data\raw\olist_order_reviews_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

BULK INSERT raw.olist_products
FROM 'C:\olist_data\raw\olist_products_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

BULK INSERT raw.product_category_name_translation
FROM 'C:\olist_data\raw\product_category_name_translation.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

BULK INSERT raw.olist_sellers
FROM 'C:\olist_data\raw\olist_sellers_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

BULK INSERT raw.olist_geolocation
FROM 'C:\olist_data\raw\olist_geolocation_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

INSERT INTO audit.ingestion_log (table_schema, table_name, source_file, expected_row_count, actual_row_count, status, notes)
VALUES
('raw', 'olist_customers', 'olist_customers_dataset.csv', 99441, (SELECT COUNT(*) FROM raw.olist_customers), 'loaded', NULL),
('raw', 'olist_orders', 'olist_orders_dataset.csv', 99441, (SELECT COUNT(*) FROM raw.olist_orders), 'loaded', NULL),
('raw', 'olist_order_items', 'olist_order_items_dataset.csv', 112650, (SELECT COUNT(*) FROM raw.olist_order_items), 'loaded', NULL),
('raw', 'olist_order_payments', 'olist_order_payments_dataset.csv', 103886, (SELECT COUNT(*) FROM raw.olist_order_payments), 'loaded', NULL),
('raw', 'olist_order_reviews', 'olist_order_reviews_dataset.csv', 99224, (SELECT COUNT(*) FROM raw.olist_order_reviews), 'loaded', NULL),
('raw', 'olist_products', 'olist_products_dataset.csv', 32951, (SELECT COUNT(*) FROM raw.olist_products), 'loaded', NULL),
('raw', 'product_category_name_translation', 'product_category_name_translation.csv', 71, (SELECT COUNT(*) FROM raw.product_category_name_translation), 'loaded', NULL),
('raw', 'olist_sellers', 'olist_sellers_dataset.csv', 3095, (SELECT COUNT(*) FROM raw.olist_sellers), 'loaded', NULL),
('raw', 'olist_geolocation', 'olist_geolocation_dataset.csv', 1000163, (SELECT COUNT(*) FROM raw.olist_geolocation), 'loaded', NULL);
GO

PRINT 'Raw CSV ingestion completed. Run 04_validate_raw_ingestion.sql next.';
