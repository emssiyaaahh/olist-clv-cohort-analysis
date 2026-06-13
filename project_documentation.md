# D2C-Style E-Commerce Cohort Analysis & Customer Lifetime Value Engine Using Olist Marketplace Data

## Project Overview

This project is an end-to-end **Data Analytics / Business Intelligence portfolio project** using the **Olist Brazilian E-Commerce Public Dataset**. The goal is to analyze e-commerce performance from a business perspective by studying revenue trends, customer behavior, retention, product category performance, delivery efficiency, seller performance, and customer satisfaction.

The final output of this project is an interactive **Power BI dashboard** supported by **SQL-based data modeling** and **Python-based analysis**.

This project is designed to demonstrate the workflow of a Data Analyst or Business Intelligence Analyst, from raw data preparation to dashboard storytelling and business recommendations.

---

## Business Problem

An e-commerce company needs to understand how its business is performing across sales, customers, products, sellers, delivery, and reviews. Raw transactional data alone is difficult to interpret, especially when the data is spread across multiple tables.

The main business problem is:

> How can an e-commerce business use order, customer, product, payment, delivery, and review data to understand revenue performance, customer retention, customer value, and operational issues affecting satisfaction?

This project focuses on transforming raw marketplace data into a structured analytics solution that can help stakeholders answer important business questions and make better decisions.

---

## Project Objectives

The objectives of this project are to:

1. Clean, transform, and model the Olist dataset using SQL and Python.
2. Build an order-level analytical dataset to prevent duplicated revenue and incorrect KPIs.
3. Analyze revenue, orders, average order value, and customer growth trends.
4. Perform customer cohort analysis to understand customer retention.
5. Calculate a historical customer lifetime value proxy and RFM customer segments.
6. Analyze product category performance by revenue, order volume, freight value, and review score.
7. Evaluate the impact of delivery performance on customer satisfaction.
8. Create an interactive Power BI dashboard for business reporting.
9. Generate business insights and recommendations for stakeholders.

---

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Google Docs / MS Word | Project documentation and final write-up |
| MS Excel / Google Sheets | Quick data inspection and data dictionary review |
| MySQL Workbench | Database setup, SQL cleaning, data quality checks, and data modeling |
| Google Colab | Python exploratory data analysis, cohort analysis, RFM, and CLV proxy |
| Power BI Desktop | Dashboard development and business reporting |
| GitHub | Portfolio repository and version control |
| dbdiagram.io / Draw.io | ERD and star schema design |

---

## Dataset

The project uses the Olist Brazilian E-Commerce dataset, which contains customer, order, product, seller, payment, delivery, review, and geolocation data.

| Dataset | Description |
|---|---|
| `olist_orders_dataset.csv` | Order status, purchase timestamp, approval date, delivery dates, and estimated delivery date |
| `olist_customers_dataset.csv` | Customer ID, unique customer ID, customer city, state, and zip code prefix |
| `olist_order_items_dataset.csv` | Product-level order items, seller ID, price, freight value, and shipping limit date |
| `olist_order_payments_dataset.csv` | Payment type, installments, payment sequence, and payment value |
| `olist_order_reviews_dataset.csv` | Review score, review comments, review creation date, and answer timestamp |
| `olist_products_dataset.csv` | Product category, product dimensions, weight, photos, and description details |
| `olist_sellers_dataset.csv` | Seller city, state, and zip code prefix |
| `olist_geolocation_dataset.csv` | Zip code prefix, latitude, longitude, city, and state |
| `product_category_name_translation.csv` | English translations of Portuguese product category names |

---

## Key Business Questions

This project aims to answer the following questions:

1. What is the total revenue, total orders, total customers, and average order value?
2. How do revenue and order volume change over time?
3. Which product categories generate the highest revenue and order volume?
4. Which customer states or regions have the highest demand?
5. What is the repeat purchase rate of customers?
6. How does customer retention behave by monthly cohort?
7. Which customers are high-value based on RFM and historical CLV proxy?
8. How does delivery performance affect review scores?
9. Which sellers or product categories have lower customer satisfaction?
10. What business actions can improve retention, satisfaction, and operational performance?

---

## Project Workflow

The project follows an end-to-end analytics workflow:

```text
1. Project Planning and Documentation
2. Data Profiling
3. SQL Database Setup
4. Data Cleaning and Transformation
5. Data Modeling
6. Python Exploratory Data Analysis
7. Cohort, RFM, and CLV Proxy Analysis
8. Power BI Dashboard Development
9. Business Insights and Recommendations
10. Portfolio Preparation
```

---

## Repository Structure

```text
olist-clv-cohort-analysis/
│
├── data/
│   ├── raw/
│   ├── processed/
│   └── dictionary/
│
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_raw_tables.sql
│   ├── 03_data_quality_checks.sql
│   ├── 04_create_clean_tables.sql
│   ├── 05_create_mart_orders.sql
│   ├── 06_create_customer_cohorts.sql
│   └── 07_create_rfm_clv.sql
│
├── notebooks/
│   └── olist_eda_cohort_clv.ipynb
│
├── powerbi/
│   └── olist_ecommerce_dashboard.pbix
│
├── docs/
│   ├── project_documentation.docx
│   ├── data_dictionary.xlsx
│   └── dashboard_screenshots/
│
├── visuals/
│   ├── erd.png
│   └── star_schema.png
│
├── README.md
└── .gitignore
```

---

## Data Modeling Approach

The Olist dataset contains several one-to-many relationships:

- One order can have multiple order items.
- One order can have multiple payment records.
- One order can have multiple review records.
- One customer unique ID can have multiple orders.

Because of this, directly joining all raw tables may duplicate revenue, payment values, review records, and order counts.

To solve this, the project creates an **order-level analytical table** by aggregating related tables before joining them together.

### Main Analytical Table

The main order-level table will include:

| Field Type | Example Fields |
|---|---|
| Order details | `order_id`, `order_status`, `purchase_date`, `delivered_date` |
| Customer details | `customer_unique_id`, `customer_city`, `customer_state` |
| Payment metrics | `total_payment_value`, `payment_records`, `max_installments` |
| Item metrics | `item_count`, `product_count`, `seller_count`, `total_item_value`, `total_freight_value` |
| Review metrics | `avg_review_score`, `review_count` |
| Delivery metrics | `delivery_days`, `delay_days`, `is_late_delivery` |

---

## Planned Data Model

The project will use an analytics-friendly star schema.

### Fact Tables

- `fact_orders`
- `fact_order_items`
- `fact_payments`
- `fact_reviews`
- `fact_customer_cohort`
- `fact_rfm`

### Dimension Tables

- `dim_customers`
- `dim_products`
- `dim_sellers`
- `dim_date`
- `dim_location`
- `dim_category`

---

## Key Metrics and KPI Definitions

| KPI | Definition |
|---|---|
| Total Revenue | Sum of payment value or item value depending on the dashboard context |
| Total Orders | Count of distinct order IDs |
| Total Customers | Count of distinct customer unique IDs |
| Average Order Value | Total revenue divided by total orders |
| Delivered Orders | Count of orders with delivered status |
| Delivered Order Rate | Delivered orders divided by total orders |
| Repeat Customers | Customers with more than one order |
| Repeat Customer Rate | Repeat customers divided by total customers |
| Average Review Score | Average customer review score |
| Average Delivery Days | Average number of days from purchase to delivery |
| Late Delivery Rate | Percentage of delivered orders delivered after the estimated delivery date |
| Historical CLV Proxy | Total historical spending of each customer in the available dataset |
| RFM Score | Customer segmentation based on recency, frequency, and monetary value |

---

## Planned Power BI Dashboard Pages

### Page 1: Executive Overview

This page provides a high-level summary of business performance.

Planned visuals:

- Total revenue
- Total orders
- Total customers
- Average order value
- Average review score
- Late delivery rate
- Monthly revenue trend
- Monthly order trend
- Revenue by customer state
- Top product categories by revenue

### Page 2: Customer Retention and CLV

This page focuses on customer behavior, retention, and customer value.

Planned visuals:

- Unique customers
- Repeat customers
- Repeat customer rate
- Revenue per customer
- Monthly cohort heatmap
- Customer retention by cohort
- RFM segment distribution
- High-value customer summary

### Page 3: Delivery and Customer Satisfaction

This page analyzes logistics performance and its impact on review scores.

Planned visuals:

- Average delivery days
- Late delivery rate
- Average delay days
- Average review score
- Review score by delivery status
- Late delivery rate by state
- Delivery days by state
- Review score trend over time

### Page 4: Product and Category Performance

This page shows which products and categories perform best.

Planned visuals:

- Top categories by revenue
- Top categories by order volume
- Average order value by category
- Freight value by category
- Review score by category
- Category performance matrix

### Page 5: Seller Performance

This page evaluates seller performance across sales, delivery, and customer satisfaction.

Planned visuals:

- Total sellers
- Top sellers by revenue
- Seller order volume
- Seller average review score
- Seller state distribution
- Late delivery rate by seller

---

## Python Analysis Plan

Python analysis will be done in Google Colab and will include:

1. Data loading and inspection
2. Exploratory data analysis
3. Revenue trend analysis
4. Customer purchase behavior analysis
5. Monthly cohort analysis
6. RFM segmentation
7. Historical CLV proxy calculation
8. Delivery performance analysis
9. Review score analysis
10. Business insights and recommendations

---

## SQL Analysis Plan

SQL will be used for data preparation and modeling.

Main SQL tasks:

1. Create database and raw tables.
2. Import all CSV files into MySQL.
3. Check row counts and column quality.
4. Identify missing values and duplicates.
5. Validate table relationships.
6. Aggregate order items at the order level.
7. Aggregate payments at the order level.
8. Aggregate reviews at the order level.
9. Create the main `mart_orders` table.
10. Create customer cohort and RFM tables.

---

## Initial Findings to Validate

The following early observations will be validated through SQL, Python, and Power BI:

1. Customer repeat purchase behavior appears to be low.
2. Late deliveries appear to be associated with lower review scores.
3. Reviews, payments, and order items must be aggregated before joining.
4. Product category, seller, and delivery performance can provide useful business insights.
5. The dataset is suitable for an end-to-end BI portfolio project.

---

## Expected Business Recommendations

The final analysis may support recommendations such as:

1. Improve customer retention through targeted campaigns for first-time buyers.
2. Prioritize high-value customer segments identified through RFM and CLV proxy analysis.
3. Monitor late deliveries because they may negatively affect customer satisfaction.
4. Track seller performance based on review score and delivery delay.
5. Focus marketing efforts on high-performing product categories and high-demand regions.
6. Investigate low-rated categories or sellers to identify operational issues.
7. Use cohort analysis to monitor retention improvement over time.

---

## Project Limitations

This project has the following limitations:

- The dataset is historical and does not represent real-time business activity.
- The dataset does not include customer demographic details such as age, gender, or income.
- The dataset does not include marketing campaign data.
- The dataset does not include profit margin or cost of goods sold.
- CLV is calculated as a historical proxy, not a fully predictive model.
- Olist is a marketplace dataset, so the project applies a D2C-style analytics approach but does not represent a pure D2C business model.
- Some tables contain one-to-many relationships, requiring aggregation before joining.

---

## Final Deliverables

The final project will include:

- SQL scripts for database setup, cleaning, and modeling
- Google Colab notebook for Python analysis
- Power BI dashboard file
- Dashboard screenshots
- ERD or star schema diagram
- Project documentation
- GitHub README file
- Interview-ready project summary

---

## Interview Summary

For my portfolio project, I built an end-to-end e-commerce business intelligence solution using the Olist Brazilian E-Commerce dataset. The goal was to analyze revenue performance, customer retention, product category trends, delivery performance, seller performance, and customer satisfaction.

I started by reviewing the business problem and defining key business questions. Then, I loaded the raw CSV files into MySQL, performed data quality checks, and created an order-level analytical table to avoid duplicated revenue caused by one-to-many table relationships.

After preparing the data in SQL, I used Python in Google Colab for exploratory data analysis, cohort analysis, RFM segmentation, and historical customer lifetime value proxy calculation. Finally, I built an interactive Power BI dashboard to communicate insights about revenue, customers, retention, delivery performance, product categories, and sellers.

This project helped me practice SQL, Python, Power BI, data cleaning, data modeling, business analysis, and dashboard storytelling.

---

## Project Status

🚧 In Progress

Current phase:

- Project planning and documentation

Next phase:

- Data profiling
- SQL database setup
- SQL data quality checks
- Order-level analytical table creation
- Python exploratory data analysis

---

## Author

**Maria Consuelo Mangonon**  
Aspiring Data Analyst / Business Intelligence Analyst
