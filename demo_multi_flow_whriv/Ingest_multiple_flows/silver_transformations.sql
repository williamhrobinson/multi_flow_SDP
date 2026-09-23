CREATE OR REFRESH STREAMING TABLE multi_flow_2_silver.orders_silver_flows_demo
(
-- A. Define a fixed schema to prevent schema evolution.
  order_id         STRING,
  order_date       DATE,
  company_name     STRING,
  customer_name    STRING,
  customer_email   STRING,
  region           STRING,
  sales_channel    STRING,
  product_name     STRING,
  quantity         INT,
  unit_price       DECIMAL(10,2),
  discount_pct     DECIMAL(5,2),
  shipping_cost    DECIMAL(10,2),
  order_total      DECIMAL(10,2),
  payment_method   STRING,
  order_status     STRING,

-- B. Data quality constraints to drop or flag or drop invalid rows.
CONSTRAINT order_id EXPECT (order_id IS NOT NULL) ON VIOLATION FAIL UPDATE,
CONSTRAINT quantity EXPECT (quantity > 0) ON VIOLATION DROP ROW
)

-- C. Adds a table comment
COMMENT 'Clean and standardized data from multiple-flow bronze table'

-- D. Enable liquid clustering to improve performance on common filters.
CLUSTER BY AUTO

AS
-- E. Select and clean data from the bronze table
SELECT
    order_id,
    TRY_CAST(order_date AS DATE) AS order_date,
    company_name,
    customer_name,
    customer_email,
    region,
    sales_channel,
    product_name,
    TRY_CAST(quantity AS INT) AS quantity,
    TRY_CAST(unit_price AS DECIMAL(10,2)) AS unit_price,
    TRY_CAST(discount_pct AS DECIMAL(5,2)) AS discount_pct,
    TRY_CAST(shipping_cost AS DECIMAL(10,2)) AS shipping_cost,
    TRY_CAST(order_total AS DECIMAL(10,2)) AS order_total,
    payment_method,
    order_status
-- F. Incrementally reads data from the bronze table that contains data from three volumes.
FROM STREAM multi_flow_1_bronze.orders_bronze_flows_demo;