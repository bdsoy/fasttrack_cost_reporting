
  
    

        create or replace transient table fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_rate_sheet_daily
         as
        (-- <1000 rows, will be more expensive to materialize incrementally with multiple SQL statements


select
    date,
    organization_name,
    contract_number,
    account_name,
    account_locator,
    region,
    service_level,
    usage_type,
    currency,
    effective_rate,
    service_type
from snowflake.organization_usage.rate_sheet_daily
order by date
        );
      
  