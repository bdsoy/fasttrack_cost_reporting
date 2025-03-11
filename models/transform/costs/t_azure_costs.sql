{{ config(materialized='ephemeral') }}

select
  unique_key,
  'Azure' as platform,
  billing_date,
  subscription as account,
  service_family as service_category,
  meter_subcategory as service_subcategory,
  resource_id as resource,
  cost_in_usd as spend {# /* TODO: only USD supported for now */ #}
from {{ ref('t_valid_azure_daily_exports') }}
