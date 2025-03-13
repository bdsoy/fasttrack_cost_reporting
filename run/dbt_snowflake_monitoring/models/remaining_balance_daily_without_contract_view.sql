
  create or replace   view fasttrack_cost_reporting_dev.landing_snowflake_monitoring.remaining_balance_daily_without_contract_view
  
    
    
(
  
    "DATE" COMMENT $$$$, 
  
    "ORGANIZATION_NAME" COMMENT $$$$, 
  
    "CURRENCY" COMMENT $$$$, 
  
    "FREE_USAGE_BALANCE" COMMENT $$$$, 
  
    "CAPACITY_BALANCE" COMMENT $$$$, 
  
    "ON_DEMAND_CONSUMPTION_BALANCE" COMMENT $$$$, 
  
    "ROLLOVER_BALANCE" COMMENT $$$$
  
)

   as (
    select
    date,
    organization_name,
    currency,
    free_usage_balance,
    capacity_balance,
    on_demand_consumption_balance,
    rollover_balance
from fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_remaining_balance_daily

qualify row_number() over (partition by date
order by contract_number desc nulls last) = 1
  );

