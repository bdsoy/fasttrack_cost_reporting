select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select query_id
from fasttrack_cost_reporting_dev.landing_snowflake_monitoring.cost_per_query
where query_id is null



      
    ) dbt_internal_test