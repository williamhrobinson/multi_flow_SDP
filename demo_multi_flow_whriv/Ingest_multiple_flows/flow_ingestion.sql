-- ════════════════════════════════════════════════════════════
-- -- CREATE THE BRONZE TABLE STRUCTURE
-- ════════════════════════════════════════════════════════════
CREATE OR REPLACE STREAMING TABLE multi_flow_1_bronze.orders_bronze_flows_demo
(
  order_id         STRING,
  order_date       STRING,
  company_name     STRING,
  customer_name    STRING,
  customer_email   STRING,
  region           STRING,
  sales_channel    STRING,
  product_name     STRING,
  quantity         STRING,
  unit_price       STRING,
  discount_pct     STRING,
  shipping_cost    STRING,
  order_total      STRING,
  payment_method   STRING,
  order_status     STRING,
  _rescued_data    STRING,
  source_file      STRING,    -- Added by the _metadata column to return the source file name
  file_mod_time    TIMESTAMP  -- Added by the _metadata column to return file modification time of the file. Returns a consistent value
)
COMMENT "Creates a single bronze streaming table with orders from all subsidiaries using multiple flows."
TBLPROPERTIES (
  'pipelines.reset.allowed' = false    -- prevent full table refreshes on the bronze table
);


-- ═══════════════════════════════════════════════════════════════
-- -- BRONZE FLOW - BRIGHT HOME
-- ═══════════════════════════════════════════════════════════════
-- Read CSV files from the bright_home_orders volume
CREATE FLOW bright_home_orders_flow
AS INSERT INTO multi_flow_1_bronze.orders_bronze_flows_demo BY NAME
SELECT
  CAST(order_id AS STRING) AS order_id,
  CAST(order_date AS STRING) AS order_date,
  CAST(company_name AS STRING) AS company_name,
  CAST(customer_name AS STRING) AS customer_name,
  CAST(customer_email AS STRING) AS customer_email,
  CAST(region AS STRING) AS region,
  CAST(sales_channel AS STRING) AS sales_channel,
  CAST(product_name AS STRING) AS product_name,
  CAST(quantity AS STRING) AS quantity,
  CAST(unit_price AS STRING) AS unit_price,
  CAST(discount_pct AS STRING) AS discount_pct,
  CAST(shipping_cost AS STRING) AS shipping_cost,
  CAST(order_total AS STRING) AS order_total,
  CAST(payment_method AS STRING) AS payment_method,
  CAST(order_status AS STRING) AS order_status,
  CAST(_rescued_data AS STRING) AS _rescued_data,
  _metadata.file_name AS source_file,
  _metadata.file_modification_time AS file_mod_time
FROM STREAM read_files(
  '/Volumes/whriv/multi_flow_1_bronze/bright_home_orders/',    -- Uses the configuration parameter to point to the bright_home_orders volume
  format => 'csv',
  header => true
);


-- ═══════════════════════════════════════════════════════════════
-- -- BRONZE FLOW - LUMINA SPORTS
-- ═══════════════════════════════════════════════════════════════
-- Read CSV files from the lumina_sports_orders volume
CREATE FLOW lumina_sports_orders_flow
AS INSERT INTO multi_flow_1_bronze.orders_bronze_flows_demo BY NAME
SELECT
  CAST(order_id AS STRING) AS order_id,
  CAST(order_date AS STRING) AS order_date,
  CAST(company_name AS STRING) AS company_name,
  CAST(customer_name AS STRING) AS customer_name,
  CAST(customer_email AS STRING) AS customer_email,
  CAST(region AS STRING) AS region,
  CAST(sales_channel AS STRING) AS sales_channel,
  CAST(product_name AS STRING) AS product_name,
  CAST(quantity AS STRING) AS quantity,
  CAST(unit_price AS STRING) AS unit_price,
  CAST(discount_pct AS STRING) AS discount_pct,
  CAST(shipping_cost AS STRING) AS shipping_cost,
  CAST(order_total AS STRING) AS order_total,
  CAST(payment_method AS STRING) AS payment_method,
  CAST(order_status AS STRING) AS order_status,
  CAST(_rescued_data AS STRING) AS _rescued_data,
  _metadata.file_name AS source_file,
  _metadata.file_modification_time AS file_mod_time
FROM STREAM read_files(
  '/Volumes/whriv/multi_flow_1_bronze/lumina_sports_orders',    -- Uses the configuration parameter to point to the lumina_sports_orders volume
  format => 'csv',
  header => true
);


-- ═══════════════════════════════════════════════════════════════
-- -- BRONZE FLOW - NORTHSTAR OUTFITTERS
-- ═══════════════════════════════════════════════════════════════
-- Read JSON files from the northstar_outfitters_orders volume
CREATE FLOW northstar_outfitters_orders_flow
AS INSERT INTO multi_flow_1_bronze.orders_bronze_flows_demo BY NAME
SELECT
  CAST(order_id AS STRING) AS order_id,
  CAST(order_date AS STRING) AS order_date,
  CAST(company_name AS STRING) AS company_name,
  CAST(customer_name AS STRING) AS customer_name,
  CAST(customer_email AS STRING) AS customer_email,
  CAST(region AS STRING) AS region,
  CAST(sales_channel AS STRING) AS sales_channel,
  CAST(product_name AS STRING) AS product_name,
  CAST(quantity AS STRING) AS quantity,
  CAST(unit_price AS STRING) AS unit_price,
  CAST(discount_pct AS STRING) AS discount_pct,
  CAST(shipping_cost AS STRING) AS shipping_cost,
  CAST(order_total AS STRING) AS order_total,
  CAST(payment_method AS STRING) AS payment_method,
  CAST(order_status AS STRING) AS order_status,
  CAST(_rescued_data AS STRING) AS _rescued_data,
  _metadata.file_name AS source_file,
  _metadata.file_modification_time AS file_mod_time
FROM STREAM read_files(
  '/Volumes/whriv/multi_flow_1_bronze/northstar_outfitters_orders',    -- Uses the configuration parameter to point to the northstar_outfitters_orders volume
  format => 'json'
);

-- ════════════════════════════════════════════════════════════
-- -- CREATE THE BRONZE TABLE STRUCTURE
-- ════════════════════════════════════════════════════════════
CREATE OR REPLACE STREAMING TABLE multi_flow_1_bronze.dim_products_bz
(
  product_id         STRING,
  product_name       STRING,
  company_name       STRING,
  category           STRING,
  subcategory        STRING,
  base_price         STRING,
  brand              STRING,
  sku                STRING,
  _rescued_data      STRING,
  source_file        STRING,    -- Added by the _metadata column to return the source file name
  file_mod_time      TIMESTAMP  -- Added by the _metadata column to return file modification time of the file. Returns a consistent value
)
COMMENT "Creates a single bronze streaming table with product data."
TBLPROPERTIES (
  'pipelines.reset.allowed' = false    -- prevent full table refreshes on the bronze table
);

-- ═══════════════════════════════════════════════════════════════
-- -- BRONZE FLOW - PRODUCTS DIMENSION
-- ═══════════════════════════════════════════════════════════════
-- Read CSV files from the dim_products volume
CREATE FLOW dim_products_bz_flow
AS INSERT INTO multi_flow_1_bronze.dim_products_bz BY NAME
SELECT
  CAST(product_id AS STRING) AS product_id,
  CAST(product_name AS STRING) AS product_name,
  CAST(company_name AS STRING) AS company_name,
  CAST(category AS STRING) AS category,
  CAST(subcategory AS STRING) AS subcategory,
  CAST(base_price AS STRING) AS base_price,
  CAST(brand AS STRING) AS brand,
  CAST(sku AS STRING) AS sku,
  CAST(_rescued_data AS STRING) AS _rescued_data,
  _metadata.file_name AS source_file,
  _metadata.file_modification_time AS file_mod_time
FROM STREAM read_files(
  '/Volumes/whriv/multi_flow_1_bronze/dim_products',    -- Uses the configuration parameter to point to the products volume
  format => 'csv',
  header => true
);


