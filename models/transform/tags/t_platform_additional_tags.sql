{{ config(materialized='ephemeral') }}

select
  resource,
  resource as object_id, 
  platform as tag_values
from {{ ref('stg_platform_references_additional_costs') }}
group by all
