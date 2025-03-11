{% set consolidated_cols -%}
    unique_key,
    platform,
    billing_date,
    account,
    service_category,
    service_subcategory,
    resource,
    spend
{%- endset %}

with

_consolidated_costs as (
  select
    {{ consolidated_cols}}
  from {{ ref('t_azure_costs') }}

    union all

  select
    {{ consolidated_cols}}
  from {{ ref('t_platform_additional_costs') }}

    union all

  select
    {{ consolidated_cols}}
  from {{ ref('t_snowflake_costs') }}
)

select
  {{ consolidated_cols}},
  sysdate() as dbt_loaded_at
from _consolidated_costs
qualify row_number() over (
  partition by unique_key
  order by 0
) = 1
