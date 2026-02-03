/* ============================
   01 - RAW TABLES
   CSV -> raw.* (as-is)
============================ */

IF OBJECT_ID('raw.customers','U') IS NULL
CREATE TABLE raw.customers (
    customer_id   INT NULL,
    customer_name NVARCHAR(100) NULL,
    country       NVARCHAR(10) NULL
);

IF OBJECT_ID('raw.products','U') IS NULL
CREATE TABLE raw.products (
    product_id   INT NULL,
    product_name NVARCHAR(100) NULL,
    unit_cost    DECIMAL(10,2) NULL,
    unit_price   DECIMAL(10,2) NULL
);

IF OBJECT_ID('raw.sales_orders','U') IS NULL
CREATE TABLE raw.sales_orders (
    order_id    INT NULL,
    order_date  NVARCHAR(50) NULL,   -- keep flexible; cast in STG
    customer_id INT NULL,
    product_id  INT NULL,
    quantity    INT NULL,
    unit_price  DECIMAL(10,2) NULL,
    order_value DECIMAL(10,2) NULL
);

IF OBJECT_ID('raw.invoices','U') IS NULL
CREATE TABLE raw.invoices (
    order_id     INT NULL,
    order_date   NVARCHAR(50) NULL,
    customer_id  INT NULL,
    product_id   INT NULL,
    quantity     INT NULL,
    unit_price   DECIMAL(10,2) NULL,
    order_value  DECIMAL(10,2) NULL,
    invoice_id   INT NULL,
    invoice_date NVARCHAR(50) NULL
);

IF OBJECT_ID('raw.payments','U') IS NULL
CREATE TABLE raw.payments (
    invoice_id    INT NULL,
    invoice_date  NVARCHAR(50) NULL,
    amount        DECIMAL(10,2) NULL,
    payment_date  NVARCHAR(50) NULL
);
