# 🏗️ Phase 3 — SQL Server Database Setup & Raw Table Ingestion Plan

## Purpose

This phase prepares the SQL Server environment for the Olist D2C E-Commerce Cohort Analysis & CLV Engine. The goal is to create a reproducible database setup where raw Kaggle CSV files can be loaded, validated, and prepared for staging transformations.

## Database Layers

| Layer          | Schema  | Purpose                                                                   |
| -------------- | ------- | ------------------------------------------------------------------------- |
| Raw / Landing  | `raw`   | Stores source CSV data with minimal transformation                        |
| Staging        | `stg`   | Cleans, casts, standardizes, and derives fields                           |
| Analytics Mart | `mart`  | Stores star schema facts, dimensions, cohort tables, RFM, and CLV outputs |
| Audit          | `audit` | Stores ingestion logs, row counts, and QA checks                          |

## Script Execution Order

| Step | Script                               | Purpose                                              |
| ---- | ------------------------------------ | ---------------------------------------------------- |
| 1    | `01_create_database_and_schemas.sql` | Creates `OlistCLVAnalytics` database and schemas     |
| 2    | `02_create_raw_tables.sql`           | Creates raw landing tables for all 9 Olist CSV files |
| 3    | `03_bulk_insert_raw_tables.sql`      | Loads CSV files into SQL Server                      |
| 4    | `04_validate_raw_ingestion.sql`      | Validates row counts, uniqueness, and join readiness |

## Important Ingestion Rule

Use this local folder for your CSV files:

```text
C:\olist_data\raw\
```

Do not commit raw CSV files to GitHub. Add this to `.gitignore`:

```gitignore
data/raw/*.csv
*.bak
*.trn
```

## Expected Raw Row Counts

| Raw Table                               | Expected Rows |
| --------------------------------------- | ------------: |
| `raw.olist_customers`                   |        99,441 |
| `raw.olist_orders`                      |        99,441 |
| `raw.olist_order_items`                 |       112,650 |
| `raw.olist_order_payments`              |       103,886 |
| `raw.olist_order_reviews`               |        99,224 |
| `raw.olist_products`                    |        32,951 |
| `raw.product_category_name_translation` |            71 |
| `raw.olist_sellers`                     |         3,095 |
| `raw.olist_geolocation`                 |     1,000,163 |

## Phase 3 Completion Criteria

| Task                                          | Status |
| --------------------------------------------- | ------ |
| Database creation script prepared             | ✅ Done |
| Raw, staging, mart, and audit schemas created | ✅ Done |
| Raw landing tables scripted                   | ✅ Done |
| SQL bulk ingestion script prepared            | ✅ Done |
| Python fallback ingestion script prepared     | ✅ Done |
| Raw validation script prepared                | ✅ Done |
| Ready for Phase 4                             | ✅ Yes  |
