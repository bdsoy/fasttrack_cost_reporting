{% set consolidated_cols -%}
    resource,
    object_id,
    tag_values
{%- endset %}

with

_fast_track_tags as (
  select
    {{ consolidated_cols }}
  from {{ ref('t_azure_tags') }}
    union all
  select
    {{ consolidated_cols }}
  from {{ ref('t_platform_additional_tags') }}
    union all
  select
    {{ consolidated_cols }}
  from {{ ref('t_snowflake_tags') }}
)

select 
  'FAST_TRACK' as managed_by, 
  {{ consolidated_cols }},
  sysdate() as dbt_loaded_at
from _fast_track_tags
order by tag_values
