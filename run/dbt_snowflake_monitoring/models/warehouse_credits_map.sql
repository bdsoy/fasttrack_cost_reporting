
  create or replace   view fasttrack_cost_reporting_dev.landing_snowflake_monitoring.warehouse_credits_map
  
    
    
(
  
    "WAREHOUSE_SIZE" COMMENT $$The size of the warehouse. These values will join directly to the warehouse_size column in the query_history models.$$, 
  
    "WAREHOUSE_TYPE" COMMENT $$The type of the warehouse. Will be STANDARD or SNOWPARK-OPTIMIZED.$$, 
  
    "CREDITS_PER_HOUR" COMMENT $$The hourly rate at which credits are charged for this warehouse configuration$$, 
  
    "CREDITS_PER_MINUTE" COMMENT $$The minutely rate at which credits are charged for this warehouse configuration$$, 
  
    "CREDITS_PER_SECOND" COMMENT $$The secondly rate at which credits are charged for this warehouse configuration$$
  
)

   as (
    

with
warehouse_credits_map as (
    select * from (
        values
        ('X-Small', 'STANDARD', 1),
        ('Small', 'STANDARD', 2),
        ('Medium', 'STANDARD', 4),
        ('Large', 'STANDARD', 8),
        ('X-Large', 'STANDARD', 16),
        ('2X-Large', 'STANDARD', 32),
        ('3X-Large', 'STANDARD', 64),
        ('4X-Large', 'STANDARD', 128),
        ('5X-Large', 'STANDARD', 256),
        ('6X-Large', 'STANDARD', 512),
        ('Medium', 'SNOWPARK-OPTIMIZED', 6),
        ('Large', 'SNOWPARK-OPTIMIZED', 12),
        ('X-Large', 'SNOWPARK-OPTIMIZED', 24),
        ('2X-Large', 'SNOWPARK-OPTIMIZED', 48),
        ('3X-Large', 'SNOWPARK-OPTIMIZED', 96),
        ('4X-Large', 'SNOWPARK-OPTIMIZED', 192),
        ('5X-Large', 'SNOWPARK-OPTIMIZED', 384),
        ('6X-Large', 'SNOWPARK-OPTIMIZED', 768)
    ) as t (warehouse_size, warehouse_type, credits_per_hour)
)

select
    warehouse_size,
    warehouse_type,
    credits_per_hour,
    credits_per_hour / 60 as credits_per_minute,
    credits_per_hour / 3600 as credits_per_second
from warehouse_credits_map
  );

