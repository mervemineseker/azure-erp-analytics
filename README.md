📊 Mini ERP Analytics Platform

End-to-End ERP-style BI Project (Azure SQL · Azure Data Factory · Power BI)

🚀 Project Overview

This project simulates a real-world ERP Order-to-Cash (O2C) analytics pipeline, built end-to-end using Microsoft Azure services and Power BI.

The goal is to demonstrate:

ERP-style layered data architecture (RAW → STG → DWH)

Idempotent ETL with MERGE-based upserts

Business-focused KPIs such as Net Sales, Open AR, DSO, AR Aging

A production-like BI workflow from ingestion to dashboarding

This project is designed as a portfolio-grade BI / Data Analytics case study.

🧱 Architecture

Data Flow

Python (CSV Generator)
        ↓
Azure Blob Storage (Raw Files)
        ↓
Azure Data Factory (Copy + Orchestration)
        ↓
Azure SQL Database
   ├─ raw   (as-is ingestion)
   ├─ stg   (typed, deduplicated)
   └─ dwh   (dimensional model)
        ↓
Power BI (Dashboards & KPIs)

🧰 Tech Stack

Python – synthetic ERP data generation

Azure Blob Storage – raw CSV ingestion

Azure Data Factory (ADF) – ETL orchestration

Azure SQL Database – RAW / STG / DWH layers

Power BI – data modeling, DAX, dashboards

🗂️ Data Model
Dimensions

dim_customer

dim_product

Fact

fact_o2c
(Order → Invoice → Payment lifecycle)

Natural keys (invoice_id, product_id) are preserved to ensure idempotent loads, while surrogate keys are used for analytics.

🔁 ETL Design Highlights

RAW layer stores data exactly as received (no transformation)

STG layer

Data type casting

Deduplication using ROW_NUMBER()

DWH layer

MERGE-based upsert logic

Idempotent fact loading (safe re-runs)

Natural-key uniqueness enforced via indexes

Repeated pipeline executions do not create duplicates.

📈 Business KPIs & Dashboards

Power BI dashboards include:

Executive KPIs

Net Sales

Paid Amount

Open Accounts Receivable

DSO (Days Sales Outstanding)

AR Analytics

AR Aging buckets: 0–30 / 31–60 / 61–90 / 90+

Customer-level overdue analysis

Monthly sales and DSO trends

🧪 Data Quality & Reliability

Idempotent ETL (re-runnable without duplication)

Deduplication at STG level

Natural key constraints at DWH level

Smoke test SQL scripts included

📂 Repository Structure
mini-erp-analytics/
├── data_generator/
│   ├── generate_erp_data.ipynb
│   └── README.md
├── sql/
│   ├── 00_schemas.sql
│   ├── 01_raw_tables.sql
│   ├── 02_stg_tables.sql
│   ├── 03_stg_proc_load_from_raw.sql
│   ├── 04_dwh_dimensions.sql
│   ├── 05_dwh_fact_o2c.sql
│   ├── 06_dwh_proc_upsert_o2c.sql
│   └── 07_smoke_tests.sql
├── adf/
│   └── pipeline_screenshots/
├── powerbi/
│   ├── dashboard_screenshots/
│   └── dax_measures.md
└── README.md

▶️ How to Run

Generate CSV data using generate_erp_data.ipynb

Upload CSVs to Azure Blob Storage

Run ADF pipeline to load RAW tables

Execute STG and DWH stored procedures

Refresh Power BI dataset

🎯 Why This Project Matters

This project reflects real enterprise BI practices, including:

Layered warehouse design

Production-safe ETL

Business-driven analytics

Azure-native data stack

It is suitable as a Data Analyst / BI Analyst portfolio project.

📌 Future Improvements

Incremental loading based on file watermark

AP (Procure-to-Pay) module

Inventory analytics

Power BI Service alerts & subscriptions
