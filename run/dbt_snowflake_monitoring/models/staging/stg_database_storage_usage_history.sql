
  create or replace   view fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_database_storage_usage_history
  
    
    
(
  
    "DATE" COMMENT $$Date (in the UTC time zone) of this storage usage record.$$, 
  
    "DATABASE_NAME" COMMENT $$Name of the database.$$, 
  
    "AVERAGE_DATABASE_BYTES" COMMENT $$Number of bytes of database storage used, including data in Time Travel.$$, 
  
    "AVERAGE_FAILSAFE_BYTES" COMMENT $$Number of bytes of Fail-safe storage used.$$, 
  
    "AVERAGE_HYBRID_TABLE_STORAGE_BYTES" COMMENT $$Number of bytes of hybrid storage used.$$
  
)

   as (
    

select
    usage_date as date,
    database_name,
    average_database_bytes,
    average_failsafe_bytes,
    average_hybrid_table_storage_bytes
from snowflake.account_usage.database_storage_usage_history
  );

