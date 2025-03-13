
  create or replace   view fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_monitoring_daily_rates
  
    
    
(
  
    "REF_DATE" COMMENT $$Date (in the UTC time zone) for the effective price$$, 
  
    "USAGE_TYPE" COMMENT $$The type of usage, which can be one of compute, storage, etc.$$, 
  
    "SERVICE_TYPE" COMMENT $$The type of service, which can be one of compute or storage$$, 
  
    "EFFECTIVE_RATE" COMMENT $$The rate after applying any applicable discounts per the contract for the organization$$, 
  
    "CURRENCY" COMMENT $$Currency of effect rate, retrieved from Snowflake's daily rate sheet$$, 
  
    "IS_OVERAGE_RATE" COMMENT $$Indicator for whether the effective_rate is an overage rate$$, 
  
    "IS_LATEST_RATE" COMMENT $$Indicator for whether the effective_rate is the most recent$$, 
  
    "DBT_LOADED_AT" COMMENT $$control timestamp indicating when a row was refreshed via dbt, in UTC$$
  
)

   as (
    select
  date(src.date) as ref_date,
  src.usage_type,
  src.service_type,
  src.effective_rate::number(38,12) as effective_rate,
  src.currency,
  src.is_overage_rate,
  src.is_latest_rate,
  sysdate() as dbt_loaded_at
from fasttrack_cost_reporting_dev.landing_snowflake_monitoring.daily_rates as src
where src.currency ilike '%USD%' 
  );

