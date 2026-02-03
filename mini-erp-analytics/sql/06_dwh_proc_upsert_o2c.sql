/* ============================
   06 - DWH UPSERT (idempotent)
   dwh.usp_load_fact_o2c_upsert_v2
============================ */

CREATE OR ALTER PROCEDURE dwh.usp_load_fact_o2c_upsert_v2
AS
BEGIN
  SET NOCOUNT ON;

  /* 1) Upsert dimensions */
  MERGE dwh.dim_customer AS tgt
  USING (SELECT DISTINCT customer_id, customer_name, country FROM stg.customers) AS src
  ON tgt.customer_id = src.customer_id
  WHEN MATCHED THEN
    UPDATE SET customer_name = src.customer_name, country = src.country
  WHEN NOT MATCHED THEN
    INSERT (customer_id, customer_name, country)
    VALUES (src.customer_id, src.customer_name, src.country);

  MERGE dwh.dim_product AS tgt
  USING (SELECT DISTINCT product_id, product_name, unit_cost, unit_price FROM stg.products) AS src
  ON tgt.product_id = src.product_id
  WHEN MATCHED THEN
    UPDATE SET product_name = src.product_name, unit_cost = src.unit_cost, unit_price = src.unit_price
  WHEN NOT MATCHED THEN
    INSERT (product_id, product_name, unit_cost, unit_price)
    VALUES (src.product_id, src.product_name, src.unit_cost, src.unit_price);

  /* 2) Source rows */
  ;WITH base AS (
    SELECT
      so.order_id,
      inv.invoice_id,
      so.customer_id,
      so.product_id,
      so.order_date,
      inv.invoice_date,
      so.quantity,
      inv.order_value AS net_amount
    FROM stg.sales_orders so
    JOIN stg.invoices inv
      ON inv.order_id = so.order_id
     AND inv.product_id = so.product_id
  ),
  pay AS (
    SELECT invoice_id, MIN(payment_date) AS payment_date
    FROM stg.payments
    GROUP BY invoice_id
  ),
  src AS (
    SELECT
      b.order_id,
      b.invoice_id,
      b.customer_id,
      b.product_id,
      dc.customer_key,
      dp.product_key,
      b.order_date,
      b.invoice_date,
      p.payment_date,
      b.quantity,
      b.net_amount
    FROM base b
    LEFT JOIN pay p ON p.invoice_id = b.invoice_id
    JOIN dwh.dim_customer dc ON dc.customer_id = b.customer_id
    JOIN dwh.dim_product  dp ON dp.product_id  = b.product_id
  )
  MERGE dwh.fact_o2c AS tgt
  USING src
    ON tgt.invoice_id = src.invoice_id
   AND tgt.product_id = src.product_id
  WHEN MATCHED THEN
    UPDATE SET
      tgt.order_id     = src.order_id,
      tgt.customer_id  = src.customer_id,
      tgt.customer_key = src.customer_key,
      tgt.product_key  = src.product_key,
      tgt.order_date   = src.order_date,
      tgt.invoice_date = src.invoice_date,
      tgt.payment_date = src.payment_date,
      tgt.quantity     = src.quantity,
      tgt.net_amount   = src.net_amount,
      tgt.load_dts     = SYSUTCDATETIME()
  WHEN NOT MATCHED THEN
    INSERT (
      invoice_id, product_id, customer_id,
      customer_key, product_key,
      order_id, order_date, invoice_date, payment_date,
      quantity, net_amount
    )
    VALUES (
      src.invoice_id, src.product_id, src.customer_id,
      src.customer_key, src.product_key,
      src.order_id, src.order_date, src.invoice_date, src.payment_date,
      src.quantity, src.net_amount
    );

END;
GO
