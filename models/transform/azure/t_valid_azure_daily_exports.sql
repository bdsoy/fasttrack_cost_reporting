{{ config(materialized='ephemeral') }}

select * exclude(dbt_loaded_at)
from {{ ref('stg_azure_daily_exports') }}
where abs(coalesce(cost_in_usd, 0)) > 0
  and len(resource_id) > 0
  and len(meter_id) > 0
  and {{
    'tags:"{}" ilike \'{}\''.format(
      var('fasttrack_cost_reporting_azure_tags_key', 'ProjectName'),
      var('fasttrack_cost_reporting_azure_tags_value', 'Fast Track Development')
    )
  }}
