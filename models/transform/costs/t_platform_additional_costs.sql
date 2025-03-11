{{ config(materialized='ephemeral') }}

select
  unique_key,
  platform,
  billing_date,
  account,
  service_category,
  service_subcategory,
  resource,
  spend
from {{ ref('stg_platform_references_additional_costs') }}
