
  create or replace   view fasttrack_cost_reporting_dev.landing_snowflake_monitoring.daily_spend
  
    
    
(
  
    "DATE" COMMENT $$Date of spend in UTC timezone to match with Snowflake's billing timezone.$$, 
  
    "SERVICE" COMMENT $$Top level spend category per Snowflake invoice. One of Storage, Compute, Cloud Services, Adj For Incl Cloud Services, Automatic Clustering, Materialized Views, Snowpipe, Query Acceleration, Replication, or Search Optimization.$$, 
  
    "STORAGE_TYPE" COMMENT $$Subcategories where service = "Storage".$$, 
  
    "WAREHOUSE_NAME" COMMENT $$Subcategories where service = "Compute" or "Cloud Services".$$, 
  
    "DATABASE_NAME" COMMENT $$Subcategories where service = "Serverless Tasks" or service = "Storage" and storage_type = "Table and Time Travel" or "Failsafe".$$, 
  
    "SPEND" COMMENT $$Spend in the currency described by the 'currency' column$$, 
  
    "SPEND_NET_CLOUD_SERVICES" COMMENT $$Spend with cloud service adjustments taken into account. The service 'Adj For Incl Cloud Services' has a value of 0 for this column.$$, 
  
    "CURRENCY" COMMENT $$Spend currency, retrieved from Snowflake's daily rate sheet$$
  
)

   as (
    select
    convert_timezone('UTC', hour)::date as date, -- get UTC date to align with Snowflake billing
    service,
    storage_type,
    warehouse_name,
    database_name,
    sum(spend) as spend,
    sum(spend_net_cloud_services) as spend_net_cloud_services,
    any_value(currency) as currency
from fasttrack_cost_reporting_dev.landing_snowflake_monitoring.hourly_spend
group by 1, 2, 3, 4, 5
  );

