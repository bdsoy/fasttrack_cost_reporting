

with

 __dbt__cte__t_valid_azure_daily_exports as (


select * exclude(dbt_loaded_at)
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_azure_daily_exports
where abs(coalesce(cost_in_usd, 0)) > 0
  and len(resource_id) > 0
  and len(meter_id) > 0
  and tags:"ProjectName" ilike 'Fast Track Development'
),  __dbt__cte__t_azure_costs as (


select
  unique_key,
  'Azure' as platform,
  billing_date,
  subscription as account,
  service_family as service_category,
  meter_subcategory as service_subcategory,
  resource_id as resource,
  cost_in_usd as spend 
from __dbt__cte__t_valid_azure_daily_exports
),  __dbt__cte__t_platform_additional_costs as (


select
  unique_key,
  platform,
  billing_date,
  account,
  service_category,
  service_subcategory,
  resource,
  spend
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_platform_references_additional_costs
), _consolidated_costs as (
  select
    unique_key,
    platform,
    billing_date,
    account,
    service_category,
    service_subcategory,
    resource,
    spend
  from __dbt__cte__t_azure_costs

    union all

  select
    unique_key,
    platform,
    billing_date,
    account,
    service_category,
    service_subcategory,
    resource,
    spend
  from __dbt__cte__t_platform_additional_costs

    union all

  select
    unique_key,
    platform,
    billing_date,
    account,
    service_category,
    service_subcategory,
    resource,
    spend
  from fasttrack_cost_reporting_dev.transform_cost_reporting.t_snowflake_costs
)

select
  unique_key,
    platform,
    billing_date,
    account,
    service_category,
    service_subcategory,
    resource,
    spend,
  sysdate() as dbt_loaded_at
from _consolidated_costs
qualify row_number() over (
  partition by unique_key
  order by 0
) = 1