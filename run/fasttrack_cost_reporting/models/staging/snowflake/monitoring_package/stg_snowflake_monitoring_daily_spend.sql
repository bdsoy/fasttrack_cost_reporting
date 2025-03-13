
  create or replace   view fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_monitoring_daily_spend
  
    
    
(
  
    "REF_DATE" COMMENT $$Date of spend in UTC timezone to match with Snowflake's billing timezone$$, 
  
    "SERVICE" COMMENT $$Top level spend category per Snowflake invoice. One of Storage, Compute, Cloud Services, Adj For Incl Cloud Services, Automatic Clustering, Materialized Views, Snowpipe, Query Acceleration, Replication, or Search Optimization.$$, 
  
    "STORAGE_TYPE" COMMENT $$Subcategories where service = "Storage"          $$, 
  
    "WAREHOUSE_NAME" COMMENT $$Subcategories where service = "Compute" or "Cloud Services"$$, 
  
    "DATABASE_NAME" COMMENT $$Subcategories where service = "Serverless Tasks" or service = "Storage" and storage_type = "Table and Time Travel" or "Failsafe".$$, 
  
    "SPEND" COMMENT $$Spend in the currency described by the 'currency' column$$, 
  
    "SPEND_NET_CLOUD_SERVICES" COMMENT $$Spend with cloud service adjustments taken into account. The service 'Adj For Incl Cloud Services' has a value of 0 for this column.$$, 
  
    "CURRENCY" COMMENT $$Spend currency, retrieved from Snowflake's daily rate sheet$$, 
  
    "UNIQUE_KEY" COMMENT $$unique hashed value over (ref_date, service, storage_type, warehouse_name, database_name)$$, 
  
    "DBT_LOADED_AT" COMMENT $$control timestamp indicating when a row was refreshed via dbt, in UTC$$
  
)

   as (
    with

_src as (
  select 
    date(src.date) as ref_date,
    coalesce(src.service, '') as service,
    coalesce(src.storage_type, '') as storage_type,
    coalesce(src.warehouse_name, '') as warehouse_name,
    coalesce(src.database_name, '') as database_name,
    src.spend::number(38,12) as spend,
    src.spend_net_cloud_services::number(38,12) as spend_net_cloud_services,
    upper(left(trim(src.currency), 3)) as currency
  from fasttrack_cost_reporting_dev.landing_snowflake_monitoring.daily_spend as src
)

select 
  *,

  abs(
    hash(
      concat(ref_date, service, storage_type, warehouse_name, database_name)
    )
  ) as unique_key,

  sysdate() as dbt_loaded_at
from _src
where currency = 'USD' 
qualify row_number() over (
  partition by unique_key
  order by 0
) = 1
  );

