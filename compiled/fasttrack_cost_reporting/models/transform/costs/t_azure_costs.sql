

with __dbt__cte__t_valid_azure_daily_exports as (


select * exclude(dbt_loaded_at)
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_azure_daily_exports
where abs(coalesce(cost_in_usd, 0)) > 0
  and len(resource_id) > 0
  and len(meter_id) > 0
  and tags:"ProjectName" ilike 'Fast Track Development'
) select
  unique_key,
  'Azure' as platform,
  billing_date,
  subscription as account,
  service_family as service_category,
  meter_subcategory as service_subcategory,
  resource_id as resource,
  cost_in_usd as spend 
from __dbt__cte__t_valid_azure_daily_exports