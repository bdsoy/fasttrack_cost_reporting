select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select pipe_id
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_account_pipe_usage_history
where pipe_id is null



      
    ) dbt_internal_test