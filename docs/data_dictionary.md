# 📖 Data Dictionary

## Olist D2C E-Commerce Cohort Analysis & CLV Engine

<p align="center">
  <img src="https://img.shields.io/badge/Phase%202-%20Data%20Dictionary-purple?style=for-the-badge" />
  <img src="https://img.shields.io/badge/SQL%20Target-SQL%20Server-red?style=for-the-badge" />
  <img src="https://img.shields.io/badge/BI%20Use-Power%20BI-yellow?style=for-the-badge" />
</p>

---

## 1. Purpose of this Document

This Data Dictionary defines the fields used in the Olist e-commerce analytics project.

It documents:

* Raw column names
* Business meaning
* Suggested SQL Server data type
* Key role
* Analytical use
* Data quality rules

Raw file names and raw column names are preserved for traceability. Cleaned names may be created later in staging tables.

---

## 2. Data Type Standards

| Source Type                  | SQL Server Target Type | Notes                                                     |
| ---------------------------- | ---------------------- | --------------------------------------------------------- |
| Text IDs                     | `VARCHAR(50)`          | Used for order, customer, product, seller, and review IDs |
| City / state / category text | `VARCHAR(100)`         | Use larger size for category and city names               |
| Zip code prefix              | `INT`                  | Stored as numeric prefix in raw files                     |
| Timestamp fields             | `DATETIME2`            | Convert from raw text during staging                      |
| Date-only fields             | `DATE` or `DATETIME2`  | Use `DATETIME2` if time exists                            |
| Price / freight / payment    | `DECIMAL(12,2)`        | Required for financial calculations                       |
| Latitude / longitude         | `DECIMAL(10,6)`        | Required for map visuals                                  |
| Counts / quantities          | `INT`                  | Used for item sequence, installments, photos              |

---

# 3. `olist_customers_dataset.csv`

## Table Summary

| Attribute               | Value                                              |
| ----------------------- | -------------------------------------------------- |
| Grain                   | One row per `customer_id`                          |
| Primary Key             | `customer_id`                                      |
| Important Analytical ID | `customer_unique_id`                               |
| Main Join               | `customer_id` → `olist_orders_dataset.customer_id` |
| Main Use                | Customer identity, geography, retention, RFM, CLV  |

## Column Dictionary

| Column Name                | Suggested SQL Type | Key Role                | Business Meaning                            | Analytical Use              | Data Quality Rule                              |
| -------------------------- | ------------------ | ----------------------- | ------------------------------------------- | --------------------------- | ---------------------------------------------- |
| `customer_id`              | `VARCHAR(50)`      | Primary key             | Customer identifier tied to an order record | Join to orders              | Must be unique and non-null                    |
| `customer_unique_id`       | `VARCHAR(50)`      | Analytical customer key | Unique real-world customer identifier       | Retention, cohort, RFM, CLV | Non-null; can repeat across orders             |
| `customer_zip_code_prefix` | `INT`              | Geography key           | Customer zip code prefix                    | Geographic joins and maps   | Non-null; may not always match geolocation     |
| `customer_city`            | `VARCHAR(100)`     | Attribute               | Customer city                               | Geographic segmentation     | Non-null; standardize casing in staging        |
| `customer_state`           | `CHAR(2)`          | Attribute               | Customer Brazilian state abbreviation       | State-level analysis        | Non-null; should be valid Brazilian state code |

---

# 4. `olist_orders_dataset.csv`

## Table Summary

| Attribute   | Value                                                 |
| ----------- | ----------------------------------------------------- |
| Grain       | One row per `order_id`                                |
| Primary Key | `order_id`                                            |
| Foreign Key | `customer_id`                                         |
| Main Join   | `customer_id` → `olist_customers_dataset.customer_id` |
| Main Use    | Order lifecycle, delivery performance, retention base |

## Column Dictionary

| Column Name                     | Suggested SQL Type | Key Role            | Business Meaning                      | Analytical Use                         | Data Quality Rule                                |
| ------------------------------- | ------------------ | ------------------- | ------------------------------------- | -------------------------------------- | ------------------------------------------------ |
| `order_id`                      | `VARCHAR(50)`      | Primary key         | Unique order identifier               | Join to items, payments, reviews       | Must be unique and non-null                      |
| `customer_id`                   | `VARCHAR(50)`      | Foreign key         | Customer record linked to order       | Join to customers                      | Must exist in customers table                    |
| `order_status`                  | `VARCHAR(20)`      | Attribute           | Current/final status of order         | Delivered vs canceled/shipped analysis | Must be known status value                       |
| `order_purchase_timestamp`      | `DATETIME2`        | Date key            | Date and time when order was placed   | Sales trend, cohort month, recency     | Non-null; convert from text                      |
| `order_approved_at`             | `DATETIME2`        | Process timestamp   | Date and time when order was approved | Approval lag analysis                  | Can be null for some orders                      |
| `order_delivered_carrier_date`  | `DATETIME2`        | Logistics timestamp | Date order was handed to carrier      | Fulfillment lead time                  | Can be null for non-delivered/non-shipped orders |
| `order_delivered_customer_date` | `DATETIME2`        | Logistics timestamp | Date order was delivered to customer  | Delivery days, delay analysis          | Required for delivery KPIs                       |
| `order_estimated_delivery_date` | `DATETIME2`        | Logistics benchmark | Promised/estimated delivery date      | Delay and on-time delivery analysis    | Non-null in raw data                             |

## Recommended Derived Fields

| Derived Field    | Formula                                                         | Use                       |
| ---------------- | --------------------------------------------------------------- | ------------------------- |
| `purchase_date`  | `CAST(order_purchase_timestamp AS DATE)`                        | Date-level analysis       |
| `purchase_month` | Month of `order_purchase_timestamp`                             | Cohort analysis           |
| `approval_days`  | `order_approved_at - order_purchase_timestamp`                  | Approval lag              |
| `carrier_days`   | `order_delivered_carrier_date - order_approved_at`              | Fulfillment lag           |
| `delivery_days`  | `order_delivered_customer_date - order_purchase_timestamp`      | Delivery speed            |
| `delay_days`     | `order_delivered_customer_date - order_estimated_delivery_date` | Late/early delivery       |
| `is_delivered`   | `order_status = 'delivered'`                                    | Delivered-order filtering |
| `is_late`        | `order_delivered_customer_date > order_estimated_delivery_date` | Late delivery KPI         |

---

# 5. `olist_order_items_dataset.csv`

## Table Summary

| Attribute    | Value                                               |
| ------------ | --------------------------------------------------- |
| Grain        | One row per order item                              |
| Primary Key  | Composite: `order_id` + `order_item_id`             |
| Foreign Keys | `order_id`, `product_id`, `seller_id`               |
| Main Use     | Revenue, freight, product category, seller analysis |

## Column Dictionary

| Column Name           | Suggested SQL Type | Key Role            | Business Meaning                      | Analytical Use                    | Data Quality Rule                |
| --------------------- | ------------------ | ------------------- | ------------------------------------- | --------------------------------- | -------------------------------- |
| `order_id`            | `VARCHAR(50)`      | Foreign key         | Order containing the item             | Join to orders                    | Must exist in orders table       |
| `order_item_id`       | `INT`              | Composite key       | Item sequence number within an order  | Item-level uniqueness             | Must be unique within each order |
| `product_id`          | `VARCHAR(50)`      | Foreign key         | Product sold in the order item        | Join to products                  | Must exist in products table     |
| `seller_id`           | `VARCHAR(50)`      | Foreign key         | Seller responsible for item           | Join to sellers                   | Must exist in sellers table      |
| `shipping_limit_date` | `DATETIME2`        | Logistics timestamp | Seller shipping deadline              | Seller fulfillment analysis       | Convert from text                |
| `price`               | `DECIMAL(12,2)`    | Measure             | Product item price, excluding freight | Revenue, AOV, CLV                 | Should be positive               |
| `freight_value`       | `DECIMAL(12,2)`    | Measure             | Freight charged for the item          | Freight ratio, logistics friction | Should be zero or positive       |

## Recommended Derived Fields

| Derived Field            | Formula                          | Use                              |
| ------------------------ | -------------------------------- | -------------------------------- |
| `item_total_value`       | `price + freight_value`          | Total item-level customer charge |
| `freight_to_price_ratio` | `freight_value / price`          | Logistics cost burden            |
| `order_item_key`         | `order_id + '-' + order_item_id` | Surrogate key support            |

---

# 6. `olist_order_payments_dataset.csv`

## Table Summary

| Attribute   | Value                                                    |
| ----------- | -------------------------------------------------------- |
| Grain       | One row per order payment sequence                       |
| Primary Key | Composite: `order_id` + `payment_sequential`             |
| Foreign Key | `order_id`                                               |
| Main Use    | Payment type, installments, payment value reconciliation |

## Column Dictionary

| Column Name            | Suggested SQL Type | Key Role            | Business Meaning                  | Analytical Use          | Data Quality Rule                   |
| ---------------------- | ------------------ | ------------------- | --------------------------------- | ----------------------- | ----------------------------------- |
| `order_id`             | `VARCHAR(50)`      | Foreign key         | Order linked to payment           | Join to orders          | Must exist in orders table          |
| `payment_sequential`   | `INT`              | Composite key       | Payment sequence number for order | Multi-payment detection | Must be unique within each order    |
| `payment_type`         | `VARCHAR(30)`      | Attribute           | Payment method used               | Payment method analysis | Should be known payment type        |
| `payment_installments` | `INT`              | Measure / attribute | Number of installments            | Installment behavior    | Should usually be greater than zero |
| `payment_value`        | `DECIMAL(12,2)`    | Measure             | Payment amount                    | Payment reconciliation  | Should be non-negative              |

## Known Payment Types

| Payment Type  | Notes                                     |
| ------------- | ----------------------------------------- |
| `credit_card` | Main card payment method                  |
| `boleto`      | Brazilian bank slip payment               |
| `voucher`     | Voucher payment                           |
| `debit_card`  | Debit card payment                        |
| `not_defined` | Undefined payment type; should be flagged |

## Recommended Derived Fields

| Derived Field          | Formula                           | Use                                |
| ---------------------- | --------------------------------- | ---------------------------------- |
| `order_payment_total`  | `SUM(payment_value) BY order_id`  | Order-level payment reconciliation |
| `payment_method_count` | `COUNT(payment_type) BY order_id` | Multi-payment detection            |
| `uses_installments`    | `payment_installments > 1`        | Installment behavior segmentation  |

---

# 7. `olist_order_reviews_dataset.csv`

## Table Summary

| Attribute   | Value                                               |
| ----------- | --------------------------------------------------- |
| Grain       | One row per review record                           |
| Primary Key | `review_id`, but duplicates should be checked       |
| Foreign Key | `order_id`                                          |
| Main Use    | Customer satisfaction and logistics impact analysis |

## Column Dictionary

| Column Name               | Suggested SQL Type | Key Role          | Business Meaning              | Analytical Use                    | Data Quality Rule                                          |
| ------------------------- | ------------------ | ----------------- | ----------------------------- | --------------------------------- | ---------------------------------------------------------- |
| `review_id`               | `VARCHAR(50)`      | Review identifier | Identifier for review record  | Review-level tracking             | Duplicates may exist; validate before using as primary key |
| `order_id`                | `VARCHAR(50)`      | Foreign key       | Order being reviewed          | Join to orders                    | Must exist in orders table                                 |
| `review_score`            | `INT`              | Measure           | Customer rating from 1 to 5   | Satisfaction KPI                  | Must be between 1 and 5                                    |
| `review_comment_title`    | `VARCHAR(255)`     | Optional text     | Review comment title          | Text analysis, optional           | Can be null                                                |
| `review_comment_message`  | `VARCHAR(MAX)`     | Optional text     | Full review comment           | Sentiment/text analysis, optional | Can be null                                                |
| `review_creation_date`    | `DATETIME2`        | Date field        | Date review was created       | Review timing                     | Convert from text                                          |
| `review_answer_timestamp` | `DATETIME2`        | Timestamp         | Date/time review was answered | Response timing                   | Convert from text                                          |

## Recommended Derived Fields

| Derived Field          | Formula                                          | Use                               |
| ---------------------- | ------------------------------------------------ | --------------------------------- |
| `is_low_review`        | `review_score IN (1,2)`                          | Dissatisfaction rate              |
| `is_high_review`       | `review_score IN (4,5)`                          | Satisfaction rate                 |
| `review_response_days` | `review_answer_timestamp - review_creation_date` | Review response timing            |
| `order_review_score`   | Aggregated score by `order_id`                   | Order-level satisfaction analysis |

---

# 8. `olist_products_dataset.csv`

## Table Summary

| Attribute   | Value                                                           |
| ----------- | --------------------------------------------------------------- |
| Grain       | One row per `product_id`                                        |
| Primary Key | `product_id`                                                    |
| Foreign Key | `product_category_name`                                         |
| Main Use    | Product category, physical product attributes, freight analysis |

## Column Dictionary

| Column Name                  | Suggested SQL Type | Key Role     | Business Meaning                   | Analytical Use             | Data Quality Rule                       |
| ---------------------------- | ------------------ | ------------ | ---------------------------------- | -------------------------- | --------------------------------------- |
| `product_id`                 | `VARCHAR(50)`      | Primary key  | Unique product identifier          | Join to order items        | Must be unique and non-null             |
| `product_category_name`      | `VARCHAR(100)`     | Category key | Product category in Portuguese     | Join to translation table  | Can be null; fallback required          |
| `product_name_lenght`        | `INT`              | Attribute    | Length of product name text        | Product content quality    | Raw typo should be corrected in staging |
| `product_description_lenght` | `INT`              | Attribute    | Length of product description text | Product content quality    | Raw typo should be corrected in staging |
| `product_photos_qty`         | `INT`              | Attribute    | Number of product photos           | Product listing quality    | Can be null                             |
| `product_weight_g`           | `DECIMAL(12,2)`    | Attribute    | Product weight in grams            | Freight/logistics analysis | Should be positive where available      |
| `product_length_cm`          | `DECIMAL(12,2)`    | Attribute    | Product length in centimeters      | Freight/logistics analysis | Should be positive where available      |
| `product_height_cm`          | `DECIMAL(12,2)`    | Attribute    | Product height in centimeters      | Freight/logistics analysis | Should be positive where available      |
| `product_width_cm`           | `DECIMAL(12,2)`    | Attribute    | Product width in centimeters       | Freight/logistics analysis | Should be positive where available      |

## Recommended Cleaned Column Names

| Raw Column                   | Cleaned Column               |
| ---------------------------- | ---------------------------- |
| `product_name_lenght`        | `product_name_length`        |
| `product_description_lenght` | `product_description_length` |

## Recommended Derived Fields

| Derived Field                | Formula                                                                 | Use                            |
| ---------------------------- | ----------------------------------------------------------------------- | ------------------------------ |
| `product_volume_cm3`         | `product_length_cm * product_height_cm * product_width_cm`              | Freight and logistics analysis |
| `product_category_reporting` | English category if available, else Portuguese category, else `unknown` | Power BI reporting             |
| `has_product_category`       | `product_category_name IS NOT NULL`                                     | Product data quality           |
| `has_product_dimensions`     | weight and dimensions are not null                                      | Logistics analysis readiness   |

---

# 9. `product_category_name_translation.csv`

## Table Summary

| Attribute   | Value                                         |
| ----------- | --------------------------------------------- |
| Grain       | One row per Portuguese product category       |
| Primary Key | `product_category_name`                       |
| Main Use    | English product category labels for reporting |

## Column Dictionary

| Column Name                     | Suggested SQL Type | Key Role    | Business Meaning               | Analytical Use           | Data Quality Rule           |
| ------------------------------- | ------------------ | ----------- | ------------------------------ | ------------------------ | --------------------------- |
| `product_category_name`         | `VARCHAR(100)`     | Primary key | Product category in Portuguese | Join to products         | Must be unique and non-null |
| `product_category_name_english` | `VARCHAR(100)`     | Attribute   | English category translation   | Dashboard category label | Must be non-null            |

## Known Translation Gap

Some product categories in the products table are not available in the translation table.
Recommended staging fallback:

```sql
COALESCE(
    product_category_name_english,
    product_category_name,
    'unknown'
) AS product_category_reporting
```

---

# 10. `olist_sellers_dataset.csv`

## Table Summary

| Attribute   | Value                                                               |
| ----------- | ------------------------------------------------------------------- |
| Grain       | One row per `seller_id`                                             |
| Primary Key | `seller_id`                                                         |
| Main Join   | `seller_id` → `olist_order_items_dataset.seller_id`                 |
| Main Use    | Seller geography, seller performance, business development analysis |

## Column Dictionary

| Column Name              | Suggested SQL Type | Key Role      | Business Meaning                    | Analytical Use                 | Data Quality Rule                              |
| ------------------------ | ------------------ | ------------- | ----------------------------------- | ------------------------------ | ---------------------------------------------- |
| `seller_id`              | `VARCHAR(50)`      | Primary key   | Unique seller identifier            | Join to order items            | Must be unique and non-null                    |
| `seller_zip_code_prefix` | `INT`              | Geography key | Seller zip code prefix              | Join to aggregated geolocation | Non-null; may not always match geolocation     |
| `seller_city`            | `VARCHAR(100)`     | Attribute     | Seller city                         | Seller geography analysis      | Non-null; standardize casing                   |
| `seller_state`           | `CHAR(2)`          | Attribute     | Seller Brazilian state abbreviation | Seller state analysis          | Non-null; should be valid Brazilian state code |

---

# 11. `olist_geolocation_dataset.csv`

## Table Summary

| Attribute     | Value                             |
| ------------- | --------------------------------- |
| Grain         | Multiple rows per zip code prefix |
| Primary Key   | None in raw format                |
| Main Join Key | `geolocation_zip_code_prefix`     |
| Main Use      | Customer and seller map analysis  |

## Column Dictionary

| Column Name                   | Suggested SQL Type | Key Role      | Business Meaning             | Analytical Use                     | Data Quality Rule                    |
| ----------------------------- | ------------------ | ------------- | ---------------------------- | ---------------------------------- | ------------------------------------ |
| `geolocation_zip_code_prefix` | `INT`              | Geography key | Brazilian zip code prefix    | Join to customer/seller zip prefix | Duplicate prefixes expected          |
| `geolocation_lat`             | `DECIMAL(10,6)`    | Measure       | Latitude coordinate          | Map visuals                        | Non-null                             |
| `geolocation_lng`             | `DECIMAL(10,6)`    | Measure       | Longitude coordinate         | Map visuals                        | Non-null                             |
| `geolocation_city`            | `VARCHAR(100)`     | Attribute     | City linked to zip prefix    | Geographic reporting               | Standardize casing and accents       |
| `geolocation_state`           | `CHAR(2)`          | Attribute     | Brazilian state abbreviation | State-level reporting              | Should be valid Brazilian state code |

## Required Staging Rule

The raw geolocation table should not be joined directly to customers or sellers because it contains duplicate zip code prefixes.

Create a staged geography table:

```sql
CREATE VIEW stg_geolocation_zip AS
SELECT
    geolocation_zip_code_prefix,
    AVG(geolocation_lat) AS avg_latitude,
    AVG(geolocation_lng) AS avg_longitude,
    MIN(geolocation_city) AS geolocation_city,
    MIN(geolocation_state) AS geolocation_state
FROM raw_olist_geolocation
GROUP BY geolocation_zip_code_prefix;
```

---

# 12. Key Relationship Dictionary

| Relationship             | Join Condition                                                       | Join Type for Analytics                  | Notes                                |
| ------------------------ | -------------------------------------------------------------------- | ---------------------------------------- | ------------------------------------ |
| Customers to Orders      | `customers.customer_id = orders.customer_id`                         | Inner or left join depending on analysis | Required to get `customer_unique_id` |
| Orders to Order Items    | `orders.order_id = order_items.order_id`                             | Inner join for revenue analysis          | Use item grain carefully             |
| Orders to Payments       | `orders.order_id = payments.order_id`                                | Left join after payment aggregation      | Avoid duplicate revenue              |
| Orders to Reviews        | `orders.order_id = reviews.order_id`                                 | Left join after review aggregation       | Some orders may not have reviews     |
| Order Items to Products  | `order_items.product_id = products.product_id`                       | Left join                                | Product category may be missing      |
| Products to Translation  | `products.product_category_name = translation.product_category_name` | Left join                                | Use fallback for unmapped categories |
| Order Items to Sellers   | `order_items.seller_id = sellers.seller_id`                          | Left join                                | Required for seller analysis         |
| Customers to Geolocation | `customer_zip_code_prefix = geolocation_zip_code_prefix`             | Left join to aggregated geo table        | Some zip prefixes may not match      |
| Sellers to Geolocation   | `seller_zip_code_prefix = geolocation_zip_code_prefix`               | Left join to aggregated geo table        | Some zip prefixes may not match      |

---

# 13. Recommended Staging Table Names

| Raw Table                           | Staging Table              | Purpose                                                  |
| ----------------------------------- | -------------------------- | -------------------------------------------------------- |
| `olist_customers_dataset`           | `stg_customers`            | Clean customer fields and standardize city/state         |
| `olist_orders_dataset`              | `stg_orders`               | Convert dates and derive delivery metrics                |
| `olist_order_items_dataset`         | `stg_order_items`          | Standardize financial fields and item keys               |
| `olist_order_payments_dataset`      | `stg_payments`             | Clean payment fields                                     |
| `olist_order_reviews_dataset`       | `stg_reviews`              | Clean review fields and derive review flags              |
| `olist_products_dataset`            | `stg_products`             | Rename typo columns and assign product category fallback |
| `product_category_name_translation` | `stg_category_translation` | Standardize category labels                              |
| `olist_sellers_dataset`             | `stg_sellers`              | Clean seller city/state                                  |
| `olist_geolocation_dataset`         | `stg_geolocation_zip`      | Aggregate to one row per zip prefix                      |

---

# 14. Recommended Analytics Tables

| Analytics Table         | Grain                                      | Built From                                 | Main Use                      |
| ----------------------- | ------------------------------------------ | ------------------------------------------ | ----------------------------- |
| `dim_customer`          | One row per `customer_unique_id`           | Customers + orders                         | Customer segmentation         |
| `dim_product`           | One row per `product_id`                   | Products + translation                     | Product reporting             |
| `dim_seller`            | One row per `seller_id`                    | Sellers + geolocation                      | Seller reporting              |
| `dim_geography`         | One row per zip prefix                     | Aggregated geolocation                     | Mapping                       |
| `dim_date`              | One row per calendar date                  | Generated date table                       | Time intelligence             |
| `fact_orders`           | One row per `order_id`                     | Orders + aggregated items/payments/reviews | Order-level KPIs              |
| `fact_order_items`      | One row per order item                     | Order items + product/seller keys          | Revenue and category analysis |
| `fact_customer_monthly` | One row per customer per month             | Orders + customers + items                 | Cohort and retention          |
| `fact_cohort_retention` | One row per cohort month and cohort period | Customer monthly table                     | Retention heatmap             |
| `fact_customer_rfm`     | One row per customer                       | Orders + item revenue                      | RFM segmentation              |
| `fact_customer_clv`     | One row per customer                       | RFM + CLV model output                     | Historical and predictive CLV |

---

# 15. Data Quality Expectations by Field Type

| Field Type          | Quality Rule                                                  |
| ------------------- | ------------------------------------------------------------- |
| ID fields           | Should be non-null; primary keys should be unique             |
| Foreign keys        | Should match parent table where applicable                    |
| Date fields         | Should be converted to `DATETIME2` and validated for sequence |
| Financial fields    | Should be non-negative and stored as decimal                  |
| Review scores       | Must be integers from 1 to 5                                  |
| Product dimensions  | Should be positive when available                             |
| Zip code prefixes   | Should be validated against aggregated geolocation table      |
| Category fields     | Missing or unmapped categories should not break reporting     |
| Text comment fields | Missing values are acceptable                                 |
| Geolocation fields  | Duplicate zip prefixes should be aggregated before use        |

---

# 16. Known Data Quality Issues to Handle

| Issue                              | Affected Table         | Recommended Handling                                                |
| ---------------------------------- | ---------------------- | ------------------------------------------------------------------- |
| Missing delivery timestamps        | Orders                 | Exclude from delivery KPI calculations unless analyzing open orders |
| Non-delivered orders               | Orders                 | Exclude from retention, RFM, and CLV base tables                    |
| Multiple items per order           | Order items            | Aggregate to order level when calculating AOV                       |
| Multiple payment rows per order    | Payments               | Aggregate payments before joining to order facts                    |
| Multiple reviews per order         | Reviews                | Aggregate or select latest review per order                         |
| Missing product categories         | Products               | Assign `unknown` category label                                     |
| Unmapped English categories        | Products + translation | Use Portuguese category as fallback                                 |
| Duplicate geolocation zip prefixes | Geolocation            | Aggregate to one row per zip prefix                                 |
| Raw typo column names              | Products               | Rename in staging, preserve raw names in raw table                  |
| Zero freight values                | Order items            | Keep as valid but monitor in freight analysis                       |
| Zero payment values                | Payments               | Flag for QA and reconciliation                                      |
| Undefined payment type             | Payments               | Keep but label as `not_defined`                                     |

---

# 17. Phase 2 Completion Checklist

| Task                                     | Status |
| ---------------------------------------- | ------ |
| Data inventory documented                | ✅ Done |
| Table grain documented                   | ✅ Done |
| Primary and foreign keys documented      | ✅ Done |
| Data dictionary drafted                  | ✅ Done |
| SQL Server target data types recommended | ✅ Done |
| Data quality rules defined               | ✅ Done |
| Staging table plan created               | ✅ Done |
| Analytics table plan created             | ✅ Done |
| Ready for SQL ingestion planning         | ✅ Yes  |

---
