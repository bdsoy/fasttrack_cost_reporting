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