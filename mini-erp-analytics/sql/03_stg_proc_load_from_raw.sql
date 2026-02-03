/* ============================
   03 - RAW -> STG (cast + dedupe)
============================ */

CREATE OR ALTER PROCEDURE stg.usp_load_from_raw
AS
BEGIN
  SET NOCOUNT ON;

  /* Customers */
  TRUNCATE TABLE stg.customers;
  INSERT INTO stg.customers (customer_id, customer_name, country)
  SELECT
    TRY_CONVERT(INT, customer_id),
    customer_name,
    country
  FROM raw.customers
  WHERE TRY_CONVERT(INT, customer_id) IS NOT NULL;

  /* Products */
  TRUNCATE TABLE stg.products;
  INSERT INTO stg.products (product_id, product_name, unit_cost, unit_price)
  SELECT
    TRY_CONVERT(INT, product_id),
    product_name,
    TRY_CONVERT(DECIMAL(10,2), unit_cost),
    TRY_CONVERT(DECIMAL(10,2), unit_price)
  FROM raw.products
  WHERE TRY_CONVERT(INT, product_id) IS NOT NULL;

  /* Sales Orders (dedupe on order_id+product_id) */
  TRUNCATE TABLE stg.sales_orders;
  ;WITH x AS (
    SELECT
      TRY_CONVERT(INT, order_id) AS order_id_i,
      TRY_CONVERT(DATE, order_date) AS order_date_d,
      TRY_CONVERT(INT, customer_id) AS customer_id_i,
      TRY_CONVERT(INT, product_id) AS product_id_i,
      TRY_CONVERT(INT, quantity) AS qty_i,
      TRY_CONVERT(DECIMAL(10,2), unit_price) AS unit_price_d,
      TRY_CONVERT(DECIMAL(10,2), order_value) AS order_value_d,
      ROW_NUMBER() OVER (
        PARTITION BY TRY_CONVERT(INT, order_id), TRY_CONVERT(INT, product_id)
        ORDER BY TRY_CONVERT(DATE, order_date) DESC
      ) AS rn
    FROM raw.sales_orders
  )
  INSERT INTO stg.sales_orders (order_id, order_date, customer_id, product_id, quantity, unit_price, order_value)
  SELECT
    order_id_i, order_date_d, customer_id_i, product_id_i, qty_i, unit_price_d, order_value_d
  FROM x
  WHERE rn = 1 AND order_id_i IS NOT NULL AND product_id_i IS NOT NULL;

  /* Invoices (dedupe on invoice_id+product_id) */
  TRUNCATE TABLE stg.invoices;
  ;WITH x AS (
    SELECT
      TRY_CONVERT(INT, invoice_id) AS invoice_id_i,
      TRY_CONVERT(DATE, invoice_date) AS invoice_date_d,
      TRY_CONVERT(INT, order_id) AS order_id_i,
      TRY_CONVERT(DATE, order_date) AS order_date_d,
      TRY_CONVERT(INT, customer_id) AS customer_id_i,
      TRY_CONVERT(INT, product_id) AS product_id_i,
      TRY_CONVERT(INT, quantity) AS qty_i,
      TRY_CONVERT(DECIMAL(10,2), unit_price) AS unit_price_d,
      TRY_CONVERT(DECIMAL(10,2), order_value) AS order_value_d,
      ROW_NUMBER() OVER (
        PARTITION BY TRY_CONVERT(INT, invoice_id), TRY_CONVERT(INT, product_id)
        ORDER BY TRY_CONVERT(DATE, invoice_date) DESC
      ) AS rn
    FROM raw.invoices
  )
  INSERT INTO stg.invoices (invoice_id, invoice_date, order_id, order_date, customer_id, product_id, quantity, unit_price, order_value)
  SELECT
    invoice_id_i, invoice_date_d, order_id_i, order_date_d, customer_id_i, product_id_i, qty_i, unit_price_d, order_value_d
  FROM x
  WHERE rn = 1 AND invoice_id_i IS NOT NULL AND product_id_i IS NOT NULL;

  /* Payments (dedupe on invoice_id+payment_date+amount) */
  TRUNCATE TABLE stg.payments;
  ;WITH x AS (
    SELECT
      TRY_CONVERT(INT, invoice_id) AS invoice_id_i,
      TRY_CONVERT(DATE, invoice_date) AS invoice_date_d,
      TRY_CONVERT(DECIMAL(10,2), amount) AS amount_d,
      TRY_CONVERT(DATE, payment_date) AS payment_date_d,
      ROW_NUMBER() OVER (
        PARTITION BY TRY_CONVERT(INT, invoice_id), TRY_CONVERT(DATE, payment_date), TRY_CONVERT(DECIMAL(10,2), amount)
        ORDER BY TRY_CONVERT(DATE, payment_date) DESC
      ) AS rn
    FROM raw.payments
  )
  INSERT INTO stg.payments (invoice_id, invoice_date, amount, payment_date)
  SELECT
    invoice_id_i, invoice_date_d, amount_d, payment_date_d
  FROM x
  WHERE rn = 1 AND invoice_id_i IS NOT NULL;

END;
GO
