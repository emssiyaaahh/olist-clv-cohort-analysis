# D2C-Style E-Commerce Cohort Analysis & Customer Lifetime Value Engine Using Olist Marketplace Data

## 1. Project Overview

This project analyzes the Olist Brazilian E-Commerce dataset to
understand customer behavior, revenue performance, product category
trends, delivery performance, seller performance, and customer
satisfaction. The goal of this project is to build an end-to-end
business intelligence solution using SQL, Python, and Power BI.

The final output of this project will be an interactive Power BI
dashboard supported by SQL-based data modeling and Python-based
exploratory analysis. The project is designed to simulate how a Data
Analyst or Business Intelligence Analyst would help an e-commerce
company understand performance, identify business problems, and
recommend data-driven actions.

## 2. Project Title

D2C-Style E-Commerce Cohort Analysis & Customer Lifetime Value Engine
Using Olist Marketplace Data

Alternative interview-friendly title:

E-Commerce Customer Retention, CLV, and Business Performance Dashboard

## 3. Background of the Study

E-commerce businesses generate large amounts of transactional data from
customers, products, payments, sellers, deliveries, and reviews.
However, raw transaction data does not immediately show useful business
insights unless it is cleaned, modeled, analyzed, and visualized
properly.

The Olist dataset provides marketplace-style e-commerce data that
includes customer orders, product categories, sellers, payment details,
delivery dates, and customer reviews. Although Olist is a marketplace
dataset, this project applies a D2C-style business intelligence
perspective by focusing on customer value, retention, purchase behavior,
delivery experience, and satisfaction.

This project aims to transform raw e-commerce data into a structured
analytics solution that can help stakeholders answer important business
questions such as:

- How is the business performing in terms of revenue and order volume?
- Which customers and product categories contribute the most value?
- How strong is customer retention?
- How does delivery performance affect customer satisfaction?
- Which areas, categories, or sellers need operational improvement?

## 4. Business Problem

The business problem is that an e-commerce company needs a clear
understanding of its sales performance, customer retention, product
performance, delivery efficiency, and customer satisfaction. Without a
proper analytics system, decision-makers may struggle to identify where
revenue is coming from, which customers are valuable, why customers do
not return, and what operational issues affect review scores.

Based on the initial inspection of the dataset, the business has a large
number of customers and orders, but the repeat purchase rate appears to
be low. This suggests that customer retention may be a key business
challenge. Delivery performance also appears to be an important factor
because late deliveries are associated with lower review scores.

Therefore, this project focuses on building a BI solution that helps
stakeholders monitor business performance and identify opportunities to
improve customer retention, customer satisfaction, and operational
efficiency.

## 5. Project Objectives

The main objective of this project is to build an end-to-end e-commerce
analytics dashboard using the Olist dataset.

Specific objectives:

1.  To clean, transform, and model the Olist e-commerce dataset using
    SQL and Python.
2.  To create an order-level analytical dataset that avoids duplicated
    revenue caused by one-to-many table relationships.
3.  To analyze revenue, order volume, average order value, and customer
    growth trends.
4.  To perform customer cohort analysis to understand retention
    behavior.
5.  To calculate customer value using historical CLV proxy and RFM
    segmentation.
6.  To analyze product category performance based on revenue, orders,
    freight value, and review score.
7.  To evaluate the relationship between delivery performance and
    customer satisfaction.
8.  To create an interactive Power BI dashboard for business reporting
    and decision-making.
9.  To generate business insights and recommendations based on the
    analysis.

## 6. Target Stakeholders

The dashboard and analysis are intended for the following stakeholders:

- Business owners and executives
- E-commerce managers
- Sales and marketing teams
- Customer experience teams
- Operations and logistics teams
- Seller management teams
- Data and business intelligence teams

## 7. Tools and Technologies

The following tools will be used in this project:

### MS Word or Google Docs

Used for project documentation, methodology, findings, recommendations,
and final project write-up.

### MS Excel or Google Sheets

Used only for quick data inspection, checking sample records, reviewing
column names, and creating a data dictionary. Since the geolocation
dataset has more than one million rows, Excel or Google Sheets will not
be used for full data cleaning.

### MySQL Workbench

Used for importing raw CSV files, creating raw tables, performing SQL
data quality checks, joining datasets, aggregating one-to-many
relationships, and creating analytical views or tables.

### Google Colab

Used for Python-based exploratory data analysis, cohort analysis, RFM
segmentation, CLV proxy calculation, visual analysis, and notebook
documentation.

### Power BI Desktop

Used for building the final interactive dashboard, creating
relationships, defining DAX measures, and presenting insights visually.

### GitHub

Used for storing and presenting the project portfolio, including SQL
scripts, notebook files, documentation, dashboard screenshots, and
README file.

### Optional Tools

- dbdiagram.io for ERD and star schema design
- Draw.io or diagrams.net for workflow diagrams
- Canva for portfolio visuals or project cover image
- dbt Core for future advanced SQL transformation workflow

## 8. Dataset Description

The project uses the following Olist dataset files:

| Dataset                               | Row Count | Description                                                                                                                   |
|---------------------------------------|-----------|-------------------------------------------------------------------------------------------------------------------------------|
| olist_orders_dataset.csv              | 99,441    | Contains order ID, customer ID, order status, purchase timestamp, approval date, delivery dates, and estimated delivery date. |
| olist_customers_dataset.csv           | 99,441    | Contains customer ID, unique customer ID, city, state, and zip code prefix.                                                   |
| olist_order_items_dataset.csv         | 112,650   | Contains product-level order items, seller ID, product ID, price, freight value, and shipping limit date.                     |
| olist_order_payments_dataset.csv      | 103,886   | Contains payment type, payment installments, payment sequence, and payment value.                                             |
| olist_order_reviews_dataset.csv       | 104,719   | Contains review ID, order ID, review score, review comments, review creation date, and answer timestamp.                      |
| olist_products_dataset.csv            | 32,951    | Contains product ID, product category, product dimensions, weight, photo quantity, and product description details.           |
| olist_sellers_dataset.csv             | 3,095     | Contains seller ID, seller city, seller state, and seller zip code prefix.                                                    |
| olist_geolocation_dataset.csv         | 1,000,163 | Contains zip code prefix, latitude, longitude, city, and state.                                                               |
| product_category_name_translation.csv | 71        | Contains Portuguese product category names and their English translations.                                                    |

## 9. Initial Data Observations

Based on the initial review of the uploaded datasets:

- The dataset contains 99,441 orders.
- The dataset contains 96,096 unique customers.
- The dataset contains 96,478 delivered orders.
- The order purchase dates range from September 4, 2016 to October 17,
  2018.
- The total item revenue is approximately R\$13.59 million.
- The total payment value is approximately R\$16.01 million.
- The average review score is approximately 4.09.
- The repeat customer rate is approximately 3.12%.
- The late delivery rate among delivered orders is approximately 8.11%.
- On-time or early deliveries have an average review score of
  approximately 4.29.
- Late deliveries have an average review score of approximately 2.57.
- The reviews table has more rows than the orders table, which means
  some orders may have multiple review records.
- The payments table also has more rows than the orders table, which
  means some orders may have multiple payment records.
- The order items table has more rows than the orders table because one
  order can contain multiple items.

These observations show that the data must be modeled carefully before
creating KPIs. Directly joining all tables without aggregation may cause
duplicated revenue, duplicated payment values, and inaccurate results.

## 10. Main Business Questions

This project will answer the following business questions:

1.  What is the total revenue, total orders, total customers, and
    average order value?
2.  How do revenue and order volume change over time?
3.  Which product categories generate the highest revenue and order
    volume?
4.  Which states or regions have the highest number of customers and
    orders?
5.  What is the repeat purchase rate of customers?
6.  How does customer retention behave by monthly cohort?
7.  Which customers are high-value based on RFM and historical CLV
    proxy?
8.  How does delivery performance affect customer review scores?
9.  Which sellers or product categories have lower customer
    satisfaction?
10. What business actions can improve retention, customer satisfaction,
    and operational performance?

## 11. Scope of the Project

This project will focus on descriptive and diagnostic business
analytics.

Included in scope:

- Data profiling
- Data cleaning
- SQL transformation
- Data modeling
- Revenue analysis
- Customer analysis
- Cohort analysis
- RFM segmentation
- Historical CLV proxy calculation
- Delivery performance analysis
- Review score analysis
- Product category analysis
- Seller performance analysis
- Power BI dashboard creation
- Business recommendations

Not included in scope:

- Real-time data pipeline
- Predictive machine learning deployment
- Actual production system deployment
- External marketing campaign data
- Actual company profit margin data
- Customer demographic data beyond location

## 12. Methodology

The project will follow an end-to-end analytics workflow.

### Phase 1: Project Planning and Documentation

The first phase defines the business problem, project objectives, tools,
datasets, business questions, expected outputs, and dashboard structure.

Output:

- Project documentation
- Business questions
- Tool stack
- Dataset overview
- Project scope

### Phase 2: Data Profiling

The second phase focuses on understanding the raw data. This includes
checking row counts, column names, missing values, duplicate records,
date ranges, order status distribution, and table relationships.

Output:

- Row count checks
- Missing value checks
- Duplicate checks
- Relationship checks
- Initial data quality report

### Phase 3: SQL Database Setup and Cleaning

The third phase imports all CSV files into MySQL as raw tables. After
loading the raw data, SQL queries will be used to clean, aggregate, and
transform the data into analysis-ready views or tables.

Output:

- Raw database tables
- Cleaned SQL views
- Aggregated order-level tables
- Data quality SQL scripts

### Phase 4: Data Modeling

The fourth phase creates a structured data model for analysis and
reporting. Since some tables contain multiple rows per order,
aggregation will be done before joining data into the main analytical
table.

Output:

- Order-level analytical table
- Fact tables
- Dimension tables
- ERD or star schema diagram

### Phase 5: Python Analysis in Google Colab

The fifth phase uses Python for exploratory data analysis and deeper
customer analytics. This includes cohort analysis, RFM segmentation, CLV
proxy calculation, revenue trends, delivery analysis, and review score
analysis.

Output:

- Google Colab notebook
- EDA charts
- Cohort retention table
- RFM customer segments
- CLV proxy analysis
- Python-generated insights

### Phase 6: Power BI Dashboard Development

The sixth phase creates the final interactive Power BI dashboard. The
dashboard will include executive KPIs, customer retention, CLV, delivery
performance, product category performance, and seller analysis.

Output:

- Power BI dashboard file
- Dashboard screenshots
- DAX measures
- Interactive filters and visuals

### Phase 7: Findings and Recommendations

The seventh phase summarizes the key findings and translates them into
business recommendations.

Output:

- Final insights
- Business recommendations
- Project limitations
- Interview explanation

### Phase 8: Portfolio Preparation

The final phase prepares the project for portfolio presentation. This
includes organizing files, uploading to GitHub, writing a README file,
and preparing a short project explanation for interviews.

Output:

- GitHub repository
- README.md
- Final documentation
- Dashboard screenshots
- SQL scripts
- Python notebook
- Portfolio summary

## 13. Planned Data Model

The project will use a star schema or analytics-friendly model.

### Main Fact Tables

- fact_orders
- fact_order_items
- fact_payments
- fact_reviews
- fact_customer_cohort
- fact_rfm

### Dimension Tables

- dim_customers
- dim_products
- dim_sellers
- dim_date
- dim_location
- dim_category

The most important table will be the order-level analytical table. This
table will combine order information, customer details, aggregated
payment values, aggregated item values, aggregated review scores, and
delivery metrics.

## 14. Important Data Modeling Consideration

The Olist dataset contains several one-to-many relationships:

- One order can have multiple order items.
- One order can have multiple payment records.
- One order can have multiple review records.
- One customer unique ID can have multiple orders.

Because of this, directly joining all raw tables may duplicate revenue
or create incorrect KPIs. To avoid this, the project will first
aggregate order items, payments, and reviews at the order level before
combining them with the orders table.

This ensures that each order appears once in the main analytical table.

## 15. Key Metrics and KPI Definitions

The project will use the following KPIs:

| KPI                   | Definition                                                                  |
|-----------------------|-----------------------------------------------------------------------------|
| Total Revenue         | Total payment value or total item value depending on the dashboard context. |
| Total Orders          | Count of distinct order IDs.                                                |
| Total Customers       | Count of distinct customer unique IDs.                                      |
| Average Order Value   | Total revenue divided by total orders.                                      |
| Delivered Orders      | Count of orders with delivered status.                                      |
| Delivered Order Rate  | Delivered orders divided by total orders.                                   |
| Repeat Customers      | Customers with more than one order.                                         |
| Repeat Customer Rate  | Repeat customers divided by total customers.                                |
| Average Review Score  | Average customer review score.                                              |
| Average Delivery Days | Number of days between purchase date and customer delivery date.            |
| Late Delivery Rate    | Percentage of delivered orders delivered after the estimated delivery date. |
| Historical CLV Proxy  | Historical total customer spending based on available transaction data.     |
| RFM Score             | Customer segmentation based on recency, frequency, and monetary value.      |

## 16. Planned Dashboard Pages

The final Power BI dashboard will have the following pages:

### Page 1: Executive Overview

This page will show overall business performance.

Planned visuals:

- Total revenue card
- Total orders card
- Total customers card
- Average order value card
- Average review score card
- Late delivery rate card
- Monthly revenue trend
- Monthly order trend
- Revenue by state
- Top product categories by revenue

### Page 2: Customer Retention and CLV

This page will show customer behavior and customer value.

Planned visuals:

- Unique customers
- Repeat customers
- Repeat customer rate
- Revenue per customer
- Monthly cohort heatmap
- Customer retention by cohort
- RFM segment distribution
- High-value customer segment summary

### Page 3: Delivery and Customer Satisfaction

This page will show logistics performance and customer review impact.

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

This page will show which products and categories perform best.

Planned visuals:

- Top categories by revenue
- Top categories by order volume
- Average order value by category
- Freight value by category
- Review score by category
- Category performance matrix

### Page 5: Seller Performance

This page will show seller-level performance.

Planned visuals:

- Total sellers
- Top sellers by revenue
- Seller order volume
- Seller average review score
- Seller state distribution
- Late delivery rate by seller

## 17. Expected Insights

The project is expected to generate insights such as:

- Which months have the highest and lowest revenue.
- Which product categories contribute the most to revenue.
- Which states have the highest customer demand.
- Whether customer retention is strong or weak.
- Which customer groups create the most value.
- Whether late delivery negatively affects customer satisfaction.
- Which sellers or categories may need operational improvement.
- Which areas may be good targets for marketing or logistics
  improvement.

## 18. Initial Findings to Validate

The following findings are based on initial dataset inspection and will
be validated further using SQL, Python, and Power BI:

1.  Customer repeat purchase behavior appears to be low, with a repeat
    customer rate of around 3.12%.
2.  Late delivery appears to have a strong negative relationship with
    customer review score.
3.  On-time or early deliveries have an average review score of around
    4.29.
4.  Late deliveries have an average review score of around 2.57.
5.  Reviews, payments, and order items must be aggregated first before
    joining to avoid duplicated metrics.
6.  The dataset is suitable for an end-to-end BI project because it
    includes customers, orders, products, sellers, payments, delivery
    dates, and reviews.

## 19. Expected Business Recommendations

The final recommendations may include:

1.  Improve customer retention by targeting first-time buyers with
    follow-up campaigns.
2.  Prioritize high-value customer segments identified through RFM and
    CLV proxy analysis.
3.  Monitor late deliveries because they are strongly associated with
    lower customer satisfaction.
4.  Improve seller performance monitoring by tracking review scores and
    delivery delays.
5.  Focus marketing efforts on high-performing product categories and
    high-demand regions.
6.  Investigate low-rated categories or sellers to identify operational
    problems.
7.  Use cohort analysis to measure whether retention improves over time.

## 20. Project Limitations

This project has the following limitations:

- The dataset is historical and does not represent real-time business
  activity.
- The dataset does not include customer demographic information such as
  age, gender, or income.
- The dataset does not include marketing campaign data.
- The dataset does not include profit margin or cost of goods sold.
- CLV will be calculated as a historical CLV proxy, not a fully
  predictive CLV model.
- Some tables have one-to-many relationships, so careful aggregation is
  required before analysis.
- Olist is a marketplace dataset, so the project uses a D2C-style
  analytics approach but does not represent a pure D2C business model.

## 21. Final Deliverables

The final project will include:

- Project documentation in Google Docs or MS Word
- SQL scripts for table creation, data cleaning, and data modeling
- Data quality check queries
- Google Colab notebook for Python analysis
- Power BI dashboard file
- Dashboard screenshots
- ERD or star schema diagram
- GitHub repository
- README file
- Interview-ready project explanation

## 22. Interview Explanation Draft

For my portfolio project, I built an end-to-end e-commerce business
intelligence solution using the Olist Brazilian e-commerce dataset. The
goal was to analyze revenue performance, customer retention, product
category trends, delivery performance, seller performance, and customer
satisfaction.

I started by reviewing the business problem and identifying key
questions that an e-commerce company would want to answer. Then, I
loaded the raw CSV files into MySQL, performed data quality checks, and
created an order-level analytical table to avoid duplicated revenue
caused by one-to-many relationships in the data.

After preparing the data in SQL, I used Python in Google Colab for
exploratory data analysis, customer cohort analysis, RFM segmentation,
and historical CLV proxy calculation. Finally, I built an interactive
Power BI dashboard that allows stakeholders to monitor revenue, orders,
customers, retention, delivery performance, product categories, and
seller performance.

One important insight from the initial analysis is that repeat customer
behavior appears to be low, which suggests a customer retention
opportunity. Another key finding is that late deliveries are associated
with much lower review scores, showing that logistics performance has a
direct impact on customer satisfaction.

This project helped me practice SQL, Python, Power BI, data modeling,
data cleaning, business analysis, and dashboard storytelling.
