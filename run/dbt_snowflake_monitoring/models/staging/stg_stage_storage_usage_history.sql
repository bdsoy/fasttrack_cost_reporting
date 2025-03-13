
  create or replace   view fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_stage_storage_usage_history
  
    
    
(
  
    "DATE" COMMENT $$Date of this storage usage record.$$, 
  
    "AVERAGE_STAGE_BYTES" COMMENT $$Number of bytes of stage storage used.$$
  
)

   as (
    

select
    usage_date as date,
    average_stage_bytes
from snowflake.account_usage.stage_storage_usage_history
  );

