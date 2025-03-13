with

_src as (
  select 
    date(src.date) as ref_date,
    coalesce(src.service, '') as service,
    coalesce(src.storage_type, '') as storage_type,
    coalesce(src.warehouse_name, '') as warehouse_name,
    coalesce(src.database_name, '') as database_name,
    src.spend::number(38,12) as spend,
    src.spend_net_cloud_services::number(38,12) as spend_net_cloud_services,
    upper(left(trim(src.currency), 3)) as currency
  from fasttrack_cost_reporting_dev.landing_snowflake_monitoring.daily_spend as src
)

select 
  *,

  abs(
    hash(
      concat(ref_date, service, storage_type, warehouse_name, database_name)
    )
  ) as unique_key,

  sysdate() as dbt_loaded_at
from _src
where currency = 'USD' 
qualify row_number() over (
  partition by unique_key
  order by 0
) = 1