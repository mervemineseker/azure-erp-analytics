/* ============================
   02 - STG TABLES (typed)
============================ */

IF OBJECT_ID('stg.customers','U') IS NULL
CREATE TABLE stg.customers (
  customer_id   INT NOT NULL,
  customer_name NVARCHAR(100) NULL,
  country       NVARCHAR(10) NULL,
  load_dts      DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

IF OBJECT_ID('stg.products','U') IS NULL
CREATE TABLE stg.products (
  product_id    INT NOT NULL,
  product_name  NVARCHAR(100) NULL,
  unit_cost     DECIMAL(10,2) NULL,
  unit_price    DECIMAL(10,2) NULL,
  load_dts      DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

IF OBJECT_ID('stg.sales_orders','U') IS NULL
CREATE TABLE stg.sales_orders (
  order_id    INT NOT NULL,
  order_date  DATE NULL,
  customer_id INT NULL,
  product_id  INT NULL,
  quantity    INT NULL,
  unit_price  DECIMAL(10,2) NULL,
  order_value DECIMAL(10,2) NULL,
  load_dts    DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

IF OBJECT_ID('stg.invoices','U') IS NULL
CREATE TABLE stg.invoices (
  invoice_id   INT NOT NULL,
  invoice_date DATE NULL,
  order_id     INT NULL,
  order_date   DATE NULL,
  customer_id  INT NULL,
  product_id   INT NULL,
  quantity     INT NULL,
  unit_price   DECIMAL(10,2) NULL,
  order_value  DECIMAL(10,2) NULL,
  load_dts     DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

IF OBJECT_ID('stg.payments','U') IS NULL
CREATE TABLE stg.payments (
  invoice_id   INT NOT NULL,
  invoice_date DATE NULL,
  amount       DECIMAL(10,2) NULL,
  payment_date DATE NULL,
  load_dts     DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
