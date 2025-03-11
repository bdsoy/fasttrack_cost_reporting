{{ config(materialized='ephemeral') }}

select 
  resource_id as resource, 
  resource_id as object_id,
  to_json(max(tags)) as tag_values
from {{ ref('t_valid_azure_daily_exports') }}
group by resource_id
