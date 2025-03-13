

with

 __dbt__cte__t_valid_azure_daily_exports as (


select * exclude(dbt_loaded_at)
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_azure_daily_exports
where abs(coalesce(cost_in_usd, 0)) > 0
  and len(resource_id) > 0
  and len(meter_id) > 0
  and tags:"ProjectName" ilike 'Fast Track Development'
),  __dbt__cte__t_azure_tags as (


select 
  resource_id as resource, 
  resource_id as object_id,
  to_json(max(tags)) as tag_values
from __dbt__cte__t_valid_azure_daily_exports
group by resource_id
),  __dbt__cte__t_platform_additional_tags as (


select
  resource,
  resource as object_id, 
  platform as tag_values
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_platform_references_additional_costs
group by all
),  __dbt__cte__t_snowflake_tags as (


select
  object_name as resource,
  iff(
    domain ilike any ('%database%', '%warehouse%'),
    object_name,
    object_id::text
  ) as object_id,
  max(replace(allowed_values[0], '"', '')) as tag_values
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_account_tag_references
where deleted is null
group by all
), _fast_track_tags as (
  select
    resource,
    object_id,
    tag_values
  from __dbt__cte__t_azure_tags
    union all
  select
    resource,
    object_id,
    tag_values
  from __dbt__cte__t_platform_additional_tags
    union all
  select
    resource,
    object_id,
    tag_values
  from __dbt__cte__t_snowflake_tags
)

select 
  'FAST_TRACK' as managed_by, 
  resource,
    object_id,
    tag_values,
  sysdate() as dbt_loaded_at
from _fast_track_tags
order by tag_values