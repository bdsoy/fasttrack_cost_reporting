
  create or replace   view fasttrack_cost_reporting_dev.transform_cost_reporting.t_snowflake_serverless_costs
  
    
    
(
  
    "UNIQUE_KEY" COMMENT $$$$, 
  
    "BILLING_DATE" COMMENT $$$$, 
  
    "SERVICE_CATEGORY" COMMENT $$$$, 
  
    "SERVICE_SUBCATEGORY" COMMENT $$$$, 
  
    "RESOURCE" COMMENT $$$$, 
  
    "SPEND" COMMENT $$$$, 
  
    "DBT_LOADED_AT" COMMENT $$$$
  
)

   as (
    with

_pipe_usage as (
  select 
    pu.unique_key as unique_key,
    convert_timezone('UTC', pu.start_time)::date as billing_date,
    pu.pipe_name || ',' || pu.pipe_id as resource,
    'Snowpipe' as usage_type,
    sum(pu.credits_used) as credits_used
  from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_account_pipe_usage_history as pu
  group by all
),

_pipe_spend as (
  select 
    p.unique_key,
    p.billing_date,
    p.resource,
    p.usage_type,
    max(p.credits_used * dr.effective_rate) as spend
  from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_monitoring_daily_rates as dr
  join _pipe_usage as p on p.billing_date = dr.ref_date
  where dr.usage_type ilike 'snowpipe' --> attention: snowpipe streaming rates may be different
  group by all
),

_fix_spend as (
  select
    * replace (
      abs(
        hash(
          unique_key || billing_date
        )
      ) as unique_key
    )
  from _pipe_spend
  where abs(spend) > 0
)

select
  unique_key,
  billing_date,
  usage_type as service_category,
  usage_type as service_subcategory,
  resource,
  spend,
  sysdate() as dbt_loaded_at
from _fix_spend
qualify row_number() over (
  partition by unique_key
  order by 0 desc
) = 1
  );

