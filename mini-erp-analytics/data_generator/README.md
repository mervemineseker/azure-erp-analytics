# ERP Data Generator

This notebook generates realistic ERP-style transactional data
to simulate an Order-to-Cash (O2C) process.

## Generated entities
- Customers
- Products
- Sales Orders
- Invoices
- Payments

## Features
- Realistic order, invoice, and payment delays
- Partial payment coverage (open AR)
- Ready-to-use CSV output for:
  - Azure SQL
  - Power BI
  - ETL pipelines (ADF)

## Output
CSV files are generated under the `erp_output/` folder.

## Usage
Run all cells in `generate_erp_data.ipynb`.
