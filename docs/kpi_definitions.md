# 📊 KPI Definition Sheet

## D2C E-Commerce Cohort Analysis & Customer Lifetime Value Engine

<p align="center">
  <img src="https://img.shields.io/badge/KPI%20Status-Draft-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Data-Olist%20Brazilian%20E--Commerce-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/BI%20Output-Power%20BI-yellow?style=for-the-badge" />
</p>

---

## 1. Purpose of this Document

This KPI Definition Sheet standardizes the metrics used in the Olist D2C-style e-commerce analytics project. It ensures that all calculations are clear, reproducible, and consistent across SQL Server, Python, and Power BI.

The KPIs are grouped into the following areas:

1. Sales Performance
2. Customer Retention
3. Cohort Analysis
4. RFM Segmentation
5. Customer Lifetime Value
6. Logistics Performance
7. Customer Experience
8. Product and Geography Strategy

---

## 2. KPI Summary Table

| KPI Category | KPI Name               | Primary Business Use                     |
| ------------ | ---------------------- | ---------------------------------------- |
| Sales        | Total Revenue          | Measure marketplace sales performance    |
| Sales        | Average Order Value    | Understand average customer spending     |
| Customer     | Total Customers        | Measure customer base size               |
| Customer     | Repeat Customer Rate   | Measure customer retention strength      |
| Cohort       | Cohort Retention Rate  | Track repeat purchase behavior over time |
| RFM          | RFM Segment            | Classify customers for targeting         |
| CLV          | Historical CLV         | Measure actual customer value to date    |
| CLV          | Predicted CLV          | Estimate future customer value           |
| Logistics    | Average Delivery Days  | Measure delivery speed                   |
| Logistics    | Freight-to-Order Ratio | Measure shipping cost burden             |
| Experience   | Average Review Score   | Measure customer satisfaction            |
| Strategy     | Revenue by Category    | Identify strong product categories       |
| Strategy     | Revenue by State       | Identify strong geographic markets       |

---

# 3. Sales Performance KPIs

## 3.1 Total Revenue

| Field        | Definition                                                             |
| ------------ | ---------------------------------------------------------------------- |
| KPI Name     | Total Revenue                                                          |
| Description  | Total item sales revenue, excluding freight                            |
| Formula      | `SUM(price)`                                                           |
| Main Table   | `olist_order_items_dataset`                                            |
| Grain        | Order item level                                                       |
| Business Use | Measures product sales performance                                     |
| Notes        | Freight is excluded to separate product revenue from logistics charges |

---

## 3.2 Total Freight

| Field        | Definition                                             |
| ------------ | ------------------------------------------------------ |
| KPI Name     | Total Freight                                          |
| Description  | Total freight value charged across order items         |
| Formula      | `SUM(freight_value)`                                   |
| Main Table   | `olist_order_items_dataset`                            |
| Grain        | Order item level                                       |
| Business Use | Measures logistics cost charged to customers           |
| Notes        | Used for freight ratio and logistics friction analysis |

---

## 3.3 Total Order Value

| Field        | Definition                                                                                  |
| ------------ | ------------------------------------------------------------------------------------------- |
| KPI Name     | Total Order Value                                                                           |
| Description  | Combined value of product price and freight                                                 |
| Formula      | `SUM(price + freight_value)`                                                                |
| Main Table   | `olist_order_items_dataset`                                                                 |
| Grain        | Order item level                                                                            |
| Business Use | Measures total customer payment obligation before payment aggregation                       |
| Notes        | Should not be confused with payment value because payments can have multiple rows per order |

---

## 3.4 Average Order Value

| Field        | Definition                                               |
| ------------ | -------------------------------------------------------- |
| KPI Name     | Average Order Value                                      |
| Abbreviation | AOV                                                      |
| Description  | Average product revenue per order                        |
| Formula      | `Total Revenue / Number of Orders`                       |
| Main Tables  | `olist_order_items_dataset`, `olist_orders_dataset`      |
| Grain        | Order level                                              |
| Business Use | Shows average spending behavior per order                |
| Notes        | Aggregate item revenue to order level before calculating |

---

## 3.5 Monthly Revenue

| Field        | Definition                                          |
| ------------ | --------------------------------------------------- |
| KPI Name     | Monthly Revenue                                     |
| Description  | Total revenue grouped by purchase month             |
| Formula      | `SUM(price) GROUP BY purchase_month`                |
| Main Tables  | `olist_order_items_dataset`, `olist_orders_dataset` |
| Date Field   | `order_purchase_timestamp`                          |
| Business Use | Tracks sales trend over time                        |

---

# 4. Customer KPIs

## 4.1 Total Customers

| Field          | Definition                                                               |
| -------------- | ------------------------------------------------------------------------ |
| KPI Name       | Total Customers                                                          |
| Description    | Count of unique customers based on `customer_unique_id`                  |
| Formula        | `COUNT(DISTINCT customer_unique_id)`                                     |
| Main Table     | `olist_customers_dataset`                                                |
| Business Use   | Measures unique customer base                                            |
| Important Rule | Use `customer_unique_id`, not `customer_id`, for customer-level analysis |

---

## 4.2 New Customers

| Field        | Definition                                                                       |
| ------------ | -------------------------------------------------------------------------------- |
| KPI Name     | New Customers                                                                    |
| Description  | Customers whose first purchase occurred in the selected period                   |
| Formula      | `COUNT(DISTINCT customer_unique_id WHERE first_purchase_month = selected_month)` |
| Main Tables  | `olist_customers_dataset`, `olist_orders_dataset`                                |
| Business Use | Measures acquisition volume by month                                             |

---

## 4.3 Repeat Customers

| Field        | Definition                                                           |
| ------------ | -------------------------------------------------------------------- |
| KPI Name     | Repeat Customers                                                     |
| Description  | Customers with more than one delivered order                         |
| Formula      | `COUNT(DISTINCT customer_unique_id WHERE delivered_order_count > 1)` |
| Main Tables  | `olist_customers_dataset`, `olist_orders_dataset`                    |
| Business Use | Identifies customers with repeat purchase behavior                   |

---

## 4.4 Repeat Customer Rate

| Field          | Definition                                                    |
| -------------- | ------------------------------------------------------------- |
| KPI Name       | Repeat Customer Rate                                          |
| Description    | Percentage of customers who purchased more than once          |
| Formula        | `Repeat Customers / Total Customers`                          |
| Main Tables    | `olist_customers_dataset`, `olist_orders_dataset`             |
| Business Use   | Measures overall customer retention strength                  |
| Interpretation | Higher rate indicates stronger customer loyalty and retention |

---

## 4.5 One-Time Buyer Rate

| Field          | Definition                                            |
| -------------- | ----------------------------------------------------- |
| KPI Name       | One-Time Buyer Rate                                   |
| Description    | Percentage of customers with only one delivered order |
| Formula        | `One-Time Buyers / Total Customers`                   |
| Main Tables    | `olist_customers_dataset`, `olist_orders_dataset`     |
| Business Use   | Measures dependency on first-time buyers              |
| Interpretation | High rate indicates weak repeat purchase behavior     |

---

# 5. Cohort Analysis KPIs

## 5.1 Cohort Month

| Field        | Definition                                         |
| ------------ | -------------------------------------------------- |
| KPI Name     | Cohort Month                                       |
| Description  | The month of a customer’s first delivered purchase |
| Formula      | `MIN(order_purchase_month) BY customer_unique_id`  |
| Main Tables  | `olist_customers_dataset`, `olist_orders_dataset`  |
| Business Use | Groups customers based on acquisition period       |

---

## 5.2 Cohort Size

| Field        | Definition                                            |
| ------------ | ----------------------------------------------------- |
| KPI Name     | Cohort Size                                           |
| Description  | Number of unique customers acquired in a cohort month |
| Formula      | `COUNT(DISTINCT customer_unique_id) BY cohort_month`  |
| Main Tables  | `olist_customers_dataset`, `olist_orders_dataset`     |
| Business Use | Establishes base size for retention calculation       |

---

## 5.3 Cohort Period

| Field        | Definition                                                               |
| ------------ | ------------------------------------------------------------------------ |
| KPI Name     | Cohort Period                                                            |
| Description  | Number of months since the customer’s first purchase                     |
| Formula      | `purchase_month - cohort_month`                                          |
| Main Tables  | `olist_orders_dataset`, `olist_customers_dataset`                        |
| Business Use | Tracks customer activity after acquisition                               |
| Example      | Month 0 = first purchase month, Month 1 = one month after first purchase |

---

## 5.4 Cohort Retention Rate

| Field            | Definition                                                                  |
| ---------------- | --------------------------------------------------------------------------- |
| KPI Name         | Cohort Retention Rate                                                       |
| Description      | Percentage of customers from a cohort who made a purchase in a later period |
| Formula          | `Active Customers in Cohort Period / Cohort Size`                           |
| Main Tables      | `olist_orders_dataset`, `olist_customers_dataset`                           |
| Business Use     | Measures retention over time                                                |
| Dashboard Visual | Cohort heatmap                                                              |

---

## 5.5 Cohort Revenue

| Field        | Definition                                                                     |
| ------------ | ------------------------------------------------------------------------------ |
| KPI Name     | Cohort Revenue                                                                 |
| Description  | Revenue generated by a cohort in each cohort period                            |
| Formula      | `SUM(price) BY cohort_month, cohort_period`                                    |
| Main Tables  | `olist_orders_dataset`, `olist_order_items_dataset`, `olist_customers_dataset` |
| Business Use | Shows value generated by acquisition cohorts over time                         |

---

# 6. RFM Segmentation KPIs

## 6.1 Recency

| Field          | Definition                                                     |
| -------------- | -------------------------------------------------------------- |
| KPI Name       | Recency                                                        |
| Description    | Number of days since the customer’s most recent purchase       |
| Formula        | `Analysis Date - Last Purchase Date`                           |
| Main Tables    | `olist_orders_dataset`, `olist_customers_dataset`              |
| Business Use   | Measures how recently a customer purchased                     |
| Interpretation | Lower recency value means the customer purchased more recently |

---

## 6.2 Frequency

| Field        | Definition                                        |
| ------------ | ------------------------------------------------- |
| KPI Name     | Frequency                                         |
| Description  | Number of delivered orders made by a customer     |
| Formula      | `COUNT(DISTINCT order_id) BY customer_unique_id`  |
| Main Tables  | `olist_orders_dataset`, `olist_customers_dataset` |
| Business Use | Measures repeat purchase behavior                 |

---

## 6.3 Monetary Value

| Field        | Definition                                                                     |
| ------------ | ------------------------------------------------------------------------------ |
| KPI Name     | Monetary Value                                                                 |
| Description  | Total product revenue generated by a customer                                  |
| Formula      | `SUM(price) BY customer_unique_id`                                             |
| Main Tables  | `olist_order_items_dataset`, `olist_orders_dataset`, `olist_customers_dataset` |
| Business Use | Measures customer spending value                                               |

---

## 6.4 RFM Score

| Field        | Definition                                                              |
| ------------ | ----------------------------------------------------------------------- |
| KPI Name     | RFM Score                                                               |
| Description  | Combined customer score based on recency, frequency, and monetary value |
| Formula      | `R_Score + F_Score + M_Score` or concatenated `RFM_Code`                |
| Main Output  | Customer-level analytical table                                         |
| Business Use | Supports customer segmentation and campaign targeting                   |

---

## 6.5 RFM Segment

| Field            | Definition                                                                              |
| ---------------- | --------------------------------------------------------------------------------------- |
| KPI Name         | RFM Segment                                                                             |
| Description      | Customer group based on RFM behavior                                                    |
| Example Segments | Champions, Loyal Customers, Big Spenders, New Customers, At Risk, Lost, One-Time Buyers |
| Business Use     | Helps marketing teams target customers more effectively                                 |

---

# 7. Customer Lifetime Value KPIs

## 7.1 Historical CLV

| Field        | Definition                                                                     |
| ------------ | ------------------------------------------------------------------------------ |
| KPI Name     | Historical Customer Lifetime Value                                             |
| Abbreviation | Historical CLV                                                                 |
| Description  | Total revenue generated by a customer to date                                  |
| Formula      | `SUM(price) BY customer_unique_id`                                             |
| Main Tables  | `olist_order_items_dataset`, `olist_orders_dataset`, `olist_customers_dataset` |
| Business Use | Identifies customers who already generated high value                          |
| Limitation   | Revenue-based only; does not include product cost or profit margin             |

---

## 7.2 Predicted CLV

| Field            | Definition                                                     |
| ---------------- | -------------------------------------------------------------- |
| KPI Name         | Predicted Customer Lifetime Value                              |
| Abbreviation     | Predicted CLV                                                  |
| Description      | Estimated future customer value using statistical modeling     |
| Suggested Method | BG/NBD and Gamma-Gamma model                                   |
| Main Output      | Predicted 12-month customer value                              |
| Business Use     | Helps prioritize future retention and customer investment      |
| Limitation       | Model may be limited because many customers only purchase once |

---

## 7.3 Expected Number of Future Purchases

| Field            | Definition                                                           |
| ---------------- | -------------------------------------------------------------------- |
| KPI Name         | Expected Future Purchases                                            |
| Description      | Estimated number of purchases a customer may make in a future period |
| Suggested Method | BG/NBD model                                                         |
| Business Use     | Supports retention forecasting and customer prioritization           |

---

## 7.4 Expected Average Transaction Value

| Field            | Definition                                                        |
| ---------------- | ----------------------------------------------------------------- |
| KPI Name         | Expected Average Transaction Value                                |
| Description      | Estimated future average purchase value                           |
| Suggested Method | Gamma-Gamma model                                                 |
| Business Use     | Supports CLV calculation                                          |
| Important Note   | Should be applied carefully only where assumptions are reasonable |

---

## 7.5 CLV-to-CAC Ratio

| Field                 | Definition                                                      |
| --------------------- | --------------------------------------------------------------- |
| KPI Name              | CLV-to-CAC Ratio                                                |
| Description           | Estimated customer value compared with assumed acquisition cost |
| Formula               | `Predicted CLV / Assumed CAC`                                   |
| CAC Source            | Scenario-based assumption                                       |
| Example CAC Scenarios | R$20, R$40, R$60                                                |
| Business Use          | Supports acquisition efficiency analysis                        |
| Limitation            | Actual CAC is not available in the dataset                      |

---

# 8. Logistics KPIs

## 8.1 Average Delivery Days

| Field        | Definition                                                      |
| ------------ | --------------------------------------------------------------- |
| KPI Name     | Average Delivery Days                                           |
| Description  | Average number of days from purchase to customer delivery       |
| Formula      | `AVG(order_delivered_customer_date - order_purchase_timestamp)` |
| Main Table   | `olist_orders_dataset`                                          |
| Business Use | Measures delivery speed                                         |
| Filter       | Delivered orders only                                           |

---

## 8.2 Delivery Delay Days

| Field          | Definition                                                                   |
| -------------- | ---------------------------------------------------------------------------- |
| KPI Name       | Delivery Delay Days                                                          |
| Description    | Number of days an order was delivered after the estimated delivery date      |
| Formula        | `order_delivered_customer_date - order_estimated_delivery_date`              |
| Main Table     | `olist_orders_dataset`                                                       |
| Business Use   | Measures late delivery severity                                              |
| Interpretation | Positive value = late delivery, negative or zero = on-time or early delivery |

---

## 8.3 On-Time Delivery Rate

| Field        | Definition                                                                  |
| ------------ | --------------------------------------------------------------------------- |
| KPI Name     | On-Time Delivery Rate                                                       |
| Description  | Percentage of delivered orders that arrived on or before the estimated date |
| Formula      | `On-Time Delivered Orders / Total Delivered Orders`                         |
| Main Table   | `olist_orders_dataset`                                                      |
| Business Use | Measures logistics reliability                                              |

---

## 8.4 Late Delivery Rate

| Field        | Definition                                                           |
| ------------ | -------------------------------------------------------------------- |
| KPI Name     | Late Delivery Rate                                                   |
| Description  | Percentage of delivered orders that arrived after the estimated date |
| Formula      | `Late Delivered Orders / Total Delivered Orders`                     |
| Main Table   | `olist_orders_dataset`                                               |
| Business Use | Identifies logistics risk and customer dissatisfaction drivers       |

---

## 8.5 Freight-to-Order Ratio

| Field          | Definition                                                           |
| -------------- | -------------------------------------------------------------------- |
| KPI Name       | Freight-to-Order Ratio                                               |
| Description    | Freight cost as a percentage of item revenue                         |
| Formula        | `Total Freight / Total Revenue`                                      |
| Main Table     | `olist_order_items_dataset`                                          |
| Business Use   | Measures logistics cost burden                                       |
| Interpretation | Higher ratio may indicate weaker unit economics or customer friction |

---

# 9. Customer Experience KPIs

## 9.1 Average Review Score

| Field        | Definition                                 |
| ------------ | ------------------------------------------ |
| KPI Name     | Average Review Score                       |
| Description  | Average customer rating from order reviews |
| Formula      | `AVG(review_score)`                        |
| Main Table   | `olist_order_reviews_dataset`              |
| Business Use | Measures customer satisfaction             |
| Scale        | 1 to 5                                     |

---

## 9.2 Low Review Rate

| Field        | Definition                                   |
| ------------ | -------------------------------------------- |
| KPI Name     | Low Review Rate                              |
| Description  | Percentage of reviews with a score of 1 or 2 |
| Formula      | `Reviews with Score 1 or 2 / Total Reviews`  |
| Main Table   | `olist_order_reviews_dataset`                |
| Business Use | Identifies dissatisfaction risk              |

---

## 9.3 High Review Rate

| Field        | Definition                                     |
| ------------ | ---------------------------------------------- |
| KPI Name     | High Review Rate                               |
| Description  | Percentage of reviews with a score of 4 or 5   |
| Formula      | `Reviews with Score 4 or 5 / Total Reviews`    |
| Main Table   | `olist_order_reviews_dataset`                  |
| Business Use | Identifies strong customer experience segments |

---

# 10. Product and Geography KPIs

## 10.1 Revenue by Product Category

| Field        | Definition                                                                                 |
| ------------ | ------------------------------------------------------------------------------------------ |
| KPI Name     | Revenue by Product Category                                                                |
| Description  | Total product revenue grouped by English product category                                  |
| Formula      | `SUM(price) BY product_category_name_english`                                              |
| Main Tables  | `olist_order_items_dataset`, `olist_products_dataset`, `product_category_name_translation` |
| Business Use | Identifies strongest product categories                                                    |

---

## 10.2 AOV by Product Category

| Field        | Definition                                            |
| ------------ | ----------------------------------------------------- |
| KPI Name     | AOV by Product Category                               |
| Description  | Average order value grouped by product category       |
| Formula      | `Revenue by Category / Orders by Category`            |
| Main Tables  | `olist_order_items_dataset`, `olist_products_dataset` |
| Business Use | Finds higher-value categories                         |

---

## 10.3 Revenue by Customer State

| Field        | Definition                                                                     |
| ------------ | ------------------------------------------------------------------------------ |
| KPI Name     | Revenue by Customer State                                                      |
| Description  | Total product revenue grouped by customer state                                |
| Formula      | `SUM(price) BY customer_state`                                                 |
| Main Tables  | `olist_customers_dataset`, `olist_orders_dataset`, `olist_order_items_dataset` |
| Business Use | Identifies high-value geographic markets                                       |

---

## 10.4 Delivery Days by State

| Field        | Definition                                        |
| ------------ | ------------------------------------------------- |
| KPI Name     | Delivery Days by State                            |
| Description  | Average delivery time grouped by customer state   |
| Formula      | `AVG(delivery_days) BY customer_state`            |
| Main Tables  | `olist_customers_dataset`, `olist_orders_dataset` |
| Business Use | Identifies regions with logistics issues          |

---

## 10.5 CLV by State

| Field        | Definition                                        |
| ------------ | ------------------------------------------------- |
| KPI Name     | CLV by State                                      |
| Description  | Average customer value grouped by state           |
| Formula      | `AVG(customer_clv) BY customer_state`             |
| Main Output  | Customer-level CLV table                          |
| Business Use | Supports regional growth and acquisition strategy |

---

# 11. Recommended Dashboard KPIs

## Executive Overview Page

| KPI Card              | Description                     |
| --------------------- | ------------------------------- |
| Total Revenue         | Overall product sales           |
| Total Orders          | Number of orders                |
| Total Customers       | Unique customer count           |
| AOV                   | Average order value             |
| Repeat Customer Rate  | Customer retention indicator    |
| Average Review Score  | Satisfaction indicator          |
| Average Delivery Days | Logistics performance indicator |

---

## Cohort Retention Page

| Visual                | Metric                          |
| --------------------- | ------------------------------- |
| Cohort Heatmap        | Cohort Retention Rate           |
| Cohort Size Bar Chart | Cohort Size                     |
| Revenue by Cohort     | Cohort Revenue                  |
| Retention Trend Line  | Retention Rate by Cohort Period |

---

## CLV and RFM Page

| Visual               | Metric                              |
| -------------------- | ----------------------------------- |
| Segment Distribution | RFM Segment Count                   |
| CLV by Segment       | Average Historical or Predicted CLV |
| Top Customers Table  | Customer ID, RFM Segment, CLV       |
| CLV/CAC Scenario     | CLV-to-CAC Ratio                    |

---

## Logistics Impact Page

| Visual                          | Metric                 |
| ------------------------------- | ---------------------- |
| Delivery Time by State          | Average Delivery Days  |
| Freight Ratio by Category       | Freight-to-Order Ratio |
| Review Score by Delivery Status | Average Review Score   |
| Late Delivery Trend             | Late Delivery Rate     |

---

## Product and Geography Page

| Visual                      | Metric                                |
| --------------------------- | ------------------------------------- |
| Revenue by Category         | Total Revenue                         |
| AOV by Category             | Average Order Value                   |
| Revenue by State Map        | Revenue by Customer State             |
| CLV by State                | Average CLV                           |
| Category Performance Matrix | Revenue, Review Score, Retention, CLV |

---

# 12. KPI Governance Rules

| Rule                   | Description                                                          |
| ---------------------- | -------------------------------------------------------------------- |
| Customer identity rule | Use `customer_unique_id` for customer-level analysis                 |
| Order revenue rule     | Use item price for product revenue                                   |
| Freight rule           | Analyze freight separately from product revenue                      |
| Delivery rule          | Use delivered orders only for delivery performance KPIs              |
| Retention rule         | Use delivered orders only for repeat purchase and cohort analysis    |
| CLV rule               | State clearly that CLV is revenue-based, not profit-based            |
| CAC rule               | Use scenario-based CAC because real CAC is unavailable               |
| Payment rule           | Aggregate payments before joining to avoid duplicated payment values |
| Product category rule  | Use English category names for reporting                             |
| Dashboard rule         | Power BI metrics must match SQL/Python validation outputs            |

---

## 13. Phase 1 Status

| Item                             | Status |
| -------------------------------- | ------ |
| KPI Definitions Drafted          | ✅ Done |
| Metrics Grouped by Business Area | ✅ Done |
| Dashboard KPI Mapping Included   | ✅ Done |
| Ready for Data Inventory Phase   | ✅ Yes  |

---

<p align="center">
  <b>Next Step:</b> Build the Data Inventory and Data Dictionary before SQL ingestion.
</p>

