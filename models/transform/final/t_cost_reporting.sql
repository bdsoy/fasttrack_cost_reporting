{% set consolidated_cols -%}
    platform,
    account,
    service_category,
    service_subcategory,
    resource,
    environment,
    tag_values,
    managed_by
{%- endset %}

with

_expanded_costs_daily as (
  select
    f.unique_key,
    f.platform,
    f.billing_date,
    f.account,
    f.service_category,
    f.service_subcategory,
    f.spend,
    split_part(f.resource, ',',  1) as resource,
    coalesce(t.tag_values, 'n/a') as tag_values,
    coalesce(t.managed_by, 'OTHER') as managed_by,
    case
      when f.resource ilike '%dev%' or t.tag_values ilike '%dev%' then 'DEV'
      when f.resource ilike '%test%' or t.tag_values ilike '%test%' then 'TEST'
      when f.resource ilike '%prod%' or t.tag_values ilike '%prod%' then 'PROD'
      else 'OTHER'
    end as environment
  from {{ ref('t_consolidated_costs') }} as f
  join {{ ref('t_consolidated_tags') }} as t on ( {# /* TODO: review if left join */ #}
    split_part(
      f.resource,
      ',', 
      iff(len(split_part(f.resource, ',',  2)) < 1, 1, 2)
    ) = t.object_id
  )
  where f.billing_date <= sysdate()::date
),

_aggregated_costs as (
  select
    unique_key,
    {{ consolidated_cols }},
    'daily' as granularity,
    billing_date,
    spend
  from _expanded_costs_daily
    
    union all

  select
    unique_key,
    {{ consolidated_cols }},
    'weekly' as granularity,
    date_trunc('week', billing_date) as billing_date,
    spend
  from _expanded_costs_daily

    union all

  select
    unique_key,
    {{ consolidated_cols }},
    'monthly' as granularity,
    date_trunc('month', billing_date) as billing_date,
    spend
  from _expanded_costs_daily
)

select
  unique_key || left(granularity, 1) as unique_key,
  {{ consolidated_cols }},
  granularity,
  billing_date,
  spend,
  sysdate() as dbt_loaded_at
from _aggregated_costs
