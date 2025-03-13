
  create or replace   view fasttrack_cost_reporting_dev.landing_snowflake_monitoring.query_base_table_access
  
    
    
(
  
    "_UNIQUE_ID" COMMENT $$Unique identifier for each row in the table$$, 
  
    "QUERY_ID" COMMENT $$An internal, system-generated identifier for the SQL statement.$$, 
  
    "QUERY_START_TIME" COMMENT $$The statement start time (UTC time zone).$$, 
  
    "USER_NAME" COMMENT $$The user who issued the query.$$, 
  
    "FULL_TABLE_NAME" COMMENT $$$$, 
  
    "TABLE_ID" COMMENT $$Unique identifier for the table$$, 
  
    "COLUMNS_ACCESSED" COMMENT $$Array of column_names accessed in the table$$
  
)

   as (
    select
    _unique_id,
    query_id,
    query_start_time,
    user_name,
    object_name as full_table_name,
    table_id,
    columns_accessed
from fasttrack_cost_reporting_dev.landing_snowflake_monitoring.query_base_object_access
where
    object_domain = 'Table' -- removes secured views
    and table_id is not null -- removes tables from a data share
  );

