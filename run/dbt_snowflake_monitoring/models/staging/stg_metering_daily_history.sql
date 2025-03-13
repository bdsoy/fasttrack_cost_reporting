
  create or replace   view fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_metering_daily_history
  
    
    
(
  
    "DATE" COMMENT $$The date (in the UTC time zone) in which the usage took place.$$, 
  
    "SERVICE_TYPE" COMMENT $$$$, 
  
    "CREDITS_USED_CLOUD_SERVICES" COMMENT $$$$, 
  
    "CREDITS_ADJUSTMENT_CLOUD_SERVICES" COMMENT $$Number of credits adjusted for included cloud services. This is a negative value (e.g. -9).$$
  
)

   as (
    

select
    usage_date as date,
    service_type,
    credits_used_cloud_services,
    credits_adjustment_cloud_services
from snowflake.account_usage.metering_daily_history
  );

