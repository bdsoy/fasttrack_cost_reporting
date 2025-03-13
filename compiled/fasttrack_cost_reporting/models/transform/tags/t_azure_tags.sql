

with __dbt__cte__t_valid_azure_daily_exports as (


select * exclude(dbt_loaded_at)
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_azure_daily_exports
where abs(coalesce(cost_in_usd, 0)) > 0
  and len(resource_id) > 0
  and len(meter_id) > 0
  and tags:"ProjectName" ilike 'Fast Track Development'
) select 
  resource_id as resource, 
  resource_id as object_id,
  to_json(max(tags)) as tag_values
from __dbt__cte__t_valid_azure_daily_exports
group by resource_id