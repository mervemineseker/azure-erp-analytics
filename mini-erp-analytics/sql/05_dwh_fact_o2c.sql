/* ============================
   05 - DWH FACT (O2C)
   Natural keys included for idempotent MERGE
============================ */

IF OBJECT_ID('dwh.fact_o2c','U') IS NULL
CREATE TABLE dwh.fact_o2c (
  fact_key BIGINT IDENTITY(1,1) PRIMARY KEY,

  -- natural keys
  invoice_id  INT NOT NULL,
  product_id  INT NOT NULL,
  customer_id INT NULL,

  -- surrogate keys
  customer_key INT NOT NULL,
  product_key  INT NOT NULL,

  -- business fields
  order_id INT NULL,
  order_date DATE NULL,
  invoice_date DATE NULL,
  payment_date DATE NULL,
  quantity INT NULL,
  net_amount DECIMAL(10,2) NULL,

  load_dts DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1
  FROM sys.indexes
  WHERE name = 'UX_fact_o2c_nk'
    AND object_id = OBJECT_ID('dwh.fact_o2c')
)
BEGIN
  CREATE UNIQUE INDEX UX_fact_o2c_nk
  ON dwh.fact_o2c (invoice_id, product_id);
END;
