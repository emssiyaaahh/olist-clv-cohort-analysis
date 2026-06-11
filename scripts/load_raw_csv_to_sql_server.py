"""
Phase 3 Python Fallback Loader
Project: Olist D2C E-Commerce Cohort Analysis & CLV Engine
Purpose: Load Olist CSV files into SQL Server raw schema when BULK INSERT has CSV parsing issues.

Before running:
    pip install pandas sqlalchemy pyodbc

Update SERVER, DATABASE, and DATA_DIR based on your local environment.
"""

from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine, text

SERVER = "localhost"  # Example: "localhost", ".\\SQLEXPRESS", or "YOUR_SERVER_NAME"
DATABASE = "OlistCLVAnalytics"
DRIVER = "ODBC Driver 17 for SQL Server"
DATA_DIR = Path(r"C:\olist_data\raw")

CONNECTION_STRING = (
    f"mssql+pyodbc://@{SERVER}/{DATABASE}"
    f"?driver={DRIVER.replace(' ', '+')}"
    "&trusted_connection=yes"
)

CSV_TABLE_MAP = {
    "olist_customers_dataset.csv": "olist_customers",
    "olist_orders_dataset.csv": "olist_orders",
    "olist_order_items_dataset.csv": "olist_order_items",
    "olist_order_payments_dataset.csv": "olist_order_payments",
    "olist_order_reviews_dataset.csv": "olist_order_reviews",
    "olist_products_dataset.csv": "olist_products",
    "product_category_name_translation.csv": "product_category_name_translation",
    "olist_sellers_dataset.csv": "olist_sellers",
    "olist_geolocation_dataset.csv": "olist_geolocation",
}

EXPECTED_COUNTS = {
    "olist_customers": 99441,
    "olist_orders": 99441,
    "olist_order_items": 112650,
    "olist_order_payments": 103886,
    "olist_order_reviews": 99224,
    "olist_products": 32951,
    "product_category_name_translation": 71,
    "olist_sellers": 3095,
    "olist_geolocation": 1000163,
}


def load_csv_to_sql(engine, csv_file: str, table_name: str) -> None:
    file_path = DATA_DIR / csv_file
    if not file_path.exists():
        raise FileNotFoundError(f"Missing file: {file_path}")

    print(f"Loading {csv_file} into raw.{table_name}...")

    # Read as strings to preserve raw landing data.
    # keep_default_na=False keeps blanks as empty strings for raw-layer traceability.
    df = pd.read_csv(file_path, dtype=str, keep_default_na=False, encoding="utf-8")

    with engine.begin() as conn:
        conn.execute(text(f"TRUNCATE TABLE raw.{table_name};"))

    df.to_sql(
        name=table_name,
        con=engine,
        schema="raw",
        if_exists="append",
        index=False,
        chunksize=5000,
        method=None,
    )

    actual_count = len(df)
    expected_count = EXPECTED_COUNTS[table_name]
    status = "loaded" if actual_count == expected_count else "check"

    with engine.begin() as conn:
        conn.execute(
            text(
                """
                INSERT INTO audit.ingestion_log
                (table_schema, table_name, source_file, expected_row_count, actual_row_count, status, notes)
                VALUES
                (:table_schema, :table_name, :source_file, :expected_row_count, :actual_row_count, :status, :notes)
                """
            ),
            {
                "table_schema": "raw",
                "table_name": table_name,
                "source_file": csv_file,
                "expected_row_count": expected_count,
                "actual_row_count": actual_count,
                "status": status,
                "notes": "Loaded via Python pandas fallback loader.",
            },
        )

    print(f"Loaded raw.{table_name}: {actual_count:,} rows | Expected: {expected_count:,} | Status: {status}")


def main() -> None:
    engine = create_engine(CONNECTION_STRING, fast_executemany=True)

    for csv_file, table_name in CSV_TABLE_MAP.items():
        load_csv_to_sql(engine, csv_file, table_name)

    print("All raw CSV files loaded. Run sql/04_validate_raw_ingestion.sql next.")


if __name__ == "__main__":
    main()
