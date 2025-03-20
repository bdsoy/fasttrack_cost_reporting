select
  date(src.date) as ref_date,
  src.usage_type,
  src.service_type,
  src.effective_rate::number(38,12) as effective_rate,
  src.currency,
  src.is_overage_rate,
  src.is_latest_rate,
  sysdate() as dbt_loaded_at
from fasttrack_cost_reporting_dev.landing_snowflake_monitoring.daily_rates as src
where src.currency ilike '%USD%' 