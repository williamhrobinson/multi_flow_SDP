CREATE OR REPLACE MATERIALIZED VIEW whriv.multi_flow_3_gold.dim_companies_gd
AS
SELECT
  company_name
FROM multi_flow_2_silver.orders_silver_flows_demo
GROUP BY company_name;

CREATE OR REPLACE MATERIALIZED VIEW whriv.multi_flow_3_gold.dim_region_gd
AS
SELECT
  region
FROM multi_flow_2_silver.orders_silver_flows_demo
GROUP BY region;

CREATE OR REPLACE MATERIALIZED VIEW whriv.multi_flow_3_gold.dim_products_gd
AS
SELECT
  *
FROM multi_flow_2_silver.dim_products_sr;