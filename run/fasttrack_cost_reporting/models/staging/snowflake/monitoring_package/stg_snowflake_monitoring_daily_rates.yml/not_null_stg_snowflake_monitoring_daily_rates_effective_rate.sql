select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select effective_rate
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_monitoring_daily_rates
where effective_rate is null



      
    ) dbt_internal_test