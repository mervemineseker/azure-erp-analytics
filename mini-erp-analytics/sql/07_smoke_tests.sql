/* ============================
   07 - SMOKE TESTS
============================ */

-- RAW
SELECT 'raw.customers' AS tbl, COUNT(*) AS cnt FROM raw.customers
UNION ALL SELECT 'raw.products', COUNT(*) FROM raw.products
UNION ALL SELECT 'raw.sales_orders', COUNT(*) FROM raw.sales_orders
UNION ALL SELECT 'raw.invoices', COUNT(*) FROM raw.invoices
UNION ALL SELECT 'raw.payments', COUNT(*) FROM raw.payments;

-- STG + DWH
EXEC stg.usp_load_from_raw;
EXEC dwh.usp_load_fact_o2c_upsert_v2;

SELECT 'stg.customers' AS tbl, COUNT(*) AS cnt FROM stg.customers
UNION ALL SELECT 'stg.products', COUNT(*) FROM stg.products
UNION ALL SELECT 'stg.sales_orders', COUNT(*) FROM stg.sales_orders
UNION ALL SELECT 'stg.invoices', COUNT(*) FROM stg.invoices
UNION ALL SELECT 'stg.payments', COUNT(*) FROM stg.payments
UNION ALL SELECT 'dwh.fact_o2c', COUNT(*) FROM dwh.fact_o2c;

-- Idempotency test (2nd run should NOT increase)
EXEC stg.usp_load_from_raw;
EXEC dwh.usp_load_fact_o2c_upsert_v2;

SELECT COUNT(*) AS fact_cnt_after_second_run FROM dwh.fact_o2c;

SELECT TOP 20
  order_id, invoice_id, product_id, customer_id,
  order_date, invoice_date, payment_date, quantity, net_amount
FROM dwh.fact_o2c
ORDER BY fact_key DESC;
