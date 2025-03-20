
  
    

        create or replace transient table fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_remaining_balance_daily
         as
        (-- <1000 rows, will be more expensive to materialize incrementally with multiple SQL statements


select
    date,
    organization_name,
    contract_number,
    currency,
    free_usage_balance,
    capacity_balance,
    on_demand_consumption_balance,
    rollover_balance
from snowflake.organization_usage.remaining_balance_daily
order by date
        );
      
  