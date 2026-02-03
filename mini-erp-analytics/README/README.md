# Mini ERP Analytics (Azure SQL + ADF + Power BI)

End-to-end ERP-style analytics project simulating Order-to-Cash (O2C).

## Stack
- Python (data generation)
- Azure Blob Storage (raw files)
- Azure Data Factory (ingestion + orchestration)
- Azure SQL Database (RAW → STG → DWH)
- Power BI (Executive + AR/AP)

## Data Flow
Blob CSV → ADF Copy → raw.* → stg.usp_load_from_raw → dwh.usp_load_fact_o2c_upsert_v2 → Power BI

## Key Features
- Layered architecture (RAW/STG/DWH)
- Idempotent upsert (MERGE) to prevent duplicates across reruns
- KPIs: Net Sales, Open AR, DSO, AR Aging buckets

## Dashboards
- Executive overview
- AR Aging (0-30/31-60/61-90/90+)
- Customer-level Open AR drilldown
