/* ============================
   04 - DWH DIMENSIONS
============================ */

IF OBJECT_ID('dwh.dim_customer','U') IS NULL
CREATE TABLE dwh.dim_customer (
  customer_key INT IDENTITY(1,1) PRIMARY KEY,
  customer_id  INT NOT NULL UNIQUE,
  customer_name NVARCHAR(100) NULL,
  country NVARCHAR(10) NULL,
  effective_from DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

IF OBJECT_ID('dwh.dim_product','U') IS NULL
CREATE TABLE dwh.dim_product (
  product_key INT IDENTITY(1,1) PRIMARY KEY,
  product_id  INT NOT NULL UNIQUE,
  product_name NVARCHAR(100) NULL,
  unit_cost DECIMAL(10,2) NULL,
  unit_price DECIMAL(10,2) NULL,
  effective_from DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
