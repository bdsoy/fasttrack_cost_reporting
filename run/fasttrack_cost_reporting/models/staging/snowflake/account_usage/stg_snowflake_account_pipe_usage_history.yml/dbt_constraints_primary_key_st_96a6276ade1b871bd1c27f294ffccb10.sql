select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      with validation_errors as (
    select
        unique_key, count(*) as row_count
    from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_account_pipe_usage_history
    group by unique_key
    having count(*) > 1
        or unique_key is null
        
)

select *
from validation_errors
      
    ) dbt_internal_test