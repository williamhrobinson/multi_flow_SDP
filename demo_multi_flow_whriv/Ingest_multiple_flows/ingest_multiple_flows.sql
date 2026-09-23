-- ════════════════════════════════════════════════════════════
-- a. GOLD MATERIALIZED VIEW: DAILY REGION SCORECARD
-- Simple daily summary by region
-- ════════════════════════════════════════════════════════════
CREATE OR REPLACE MATERIALIZED VIEW whriv.multi_flow_3_gold.monthly_region_scorecard_gd
AS
SELECT
  order_month,
  region,
  COUNT(distinct order_id) AS order_count,
  SUM(quantity) AS total_units,
  ROUND(SUM(order_total)) AS total_revenue
FROM multi_flow_2_silver.orders_silver_flows_demo
GROUP BY order_month, region
ORDER BY order_month DESC;

-- ════════════════════════════════════════════════════════════
-- a. GOLD MATERIALIZED VIEW: DAILY COMPANY SCORECARD
-- Simple daily summary by region
-- ════════════════════════════════════════════════════════════
CREATE OR REPLACE MATERIALIZED VIEW whriv.multi_flow_3_gold.monthly_company_scorecard_gd
AS
SELECT
  order_month,
  company_name,
  COUNT(distinct order_id) AS order_count,
  SUM(quantity) AS total_units,
  ROUND(SUM(order_total)) AS total_revenue
FROM multi_flow_2_silver.orders_silver_flows_demo
GROUP BY order_month, company_name
ORDER BY order_month DESC;

-- ════════════════════════════════════════════════════════════
-- a. GOLD MATERIALIZED VIEW: PRODUCT PERFORMANCE 
-- Simple daily summary by region
-- ════════════════════════════════════════════════════════════
CREATE OR REPLACE MATERIALIZED VIEW whriv.multi_flow_3_gold.product_performance_gd
AS
SELECT
  order_month,
  product_name,
  SUM(quantity) AS total_units,
  ROUND(SUM(order_total)) AS total_revenue
FROM multi_flow_2_silver.orders_silver_flows_demo
GROUP BY product_name, order_month
ORDER BY order_month DESC;