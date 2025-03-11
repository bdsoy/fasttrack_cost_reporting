with

_snowflake_costs as (
  select
    unique_key,
    billing_date,
    service_category,
    service_subcategory,
    resource,
    spend
  from {{ ref('t_snowflake_serverless_costs') }} as src

    union all

  select
    unique_key as unique_key,
    ref_date as billing_date,
    service as service_category,
    iff(service ilike 'storage', storage_type, null) as service_subcategory,
    iff(service ilike 'storage', database_name, warehouse_name) as resource,
    sum(spend) as spend
  from {{ ref('stg_snowflake_monitoring_daily_spend') }} as src
  where service ilike any ('%cloud service%', '%compute%', '%storage%')
    and abs(spend) > 0
  group by all
)

select
  unique_key,
  'Snowflake' as platform,
  billing_date,
  current_account() as account,
  service_category,
  service_subcategory,
  resource,
  spend,
  sysdate() as dbt_loaded_at
from _snowflake_costs
