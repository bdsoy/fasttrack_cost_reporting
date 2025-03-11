{#-/*
  interpolates weekly/monthly/yearly additional costs for the Fast Track platform down to a daily
  basis according to externally managed reference source data
*/-#}

{{ config(materialized='table') }}

with

_src_costs as (
  select distinct
    granularity,
    lower(trim(platform)) as platform,
    date(billingdatefrom) as date_from,
    date(billingdateto) as date_to,
    coalesce(servicecharge, '') as category,
    coalesce(servicesubcharge, '') as sub_category,
    qty::decimal(38,12) as qty,
    price::decimal(38,12) as price,
    upper(left(trim(currency), 3)) as currency
  from {{ source('platform_references', 'additional_costs') }}
  where currency ilike '%USD%' {# /* TODO: only USD supported for now */ #}
),

_enhance_costs as (
  select
    * exclude (granularity),

    case
      when granularity ilike '%da%' then 'daily'
      when granularity ilike '%we%' then 'weekly'
      when granularity ilike '%mo%' then 'monthly'
      when granularity ilike '%ye%' then 'yearly'
    end as granularity
  from _src_costs
  where len(platform) > 0
    and date_from <= date_to
),

_dedup_costs as (
  select
    *,

    hash(s.*) as hash_key,
    (qty * price)::decimal(38,12) as spend_sum
  from _enhance_costs as s
  where granularity is not null
    and abs(spend_sum) > 0
  qualify row_number() over (
    partition by hash_key
    order by 0
  ) = 1
),

_expand_costs as (
  select 
    d.*,
    -1 + row_number() over(partition by hash_key order by 0) as i,
    date_from + i as gen_date,
    case granularity
      when 'weekly' then date_trunc('week', date_from + i)
      when 'monthly' then date_trunc('month', date_from + i)
      when 'yearly' then date_trunc('year', date_from + i)
      else date_from + i
    end as trunc_date
  from _dedup_costs as d, table(generator(rowcount => 10000))
  qualify i < 1 + date_to - date_from
),

_window_costs as (
  select  
    count(1) over (partition by hash_key, trunc_date) as cnt,
    (floor(spend_sum * 100 / cnt)::int / 100)::decimal(38,2) as frac_spend,

    case
      when cnt > 1 and gen_date = trunc_date then spend_sum - frac_spend*(cnt-1)
      when cnt > 1 and gen_date > trunc_date then frac_spend
      else spend_sum
    end::decimal(38, 12) as spend,
    
    *
  from _expand_costs
)

select
  platform,
  gen_date as billing_date,
  platform as account,
  category as service_category,
  sub_category as service_subcategory,

  concat(
    'Daily derived cost based on QTY: ',
    round(qty, 2),
     ' * PRICE: ',
    round(price, 2),
    ' / by ',
    'N', --cnt,
    ' days in each ',
    granularity,
    ' period'
  ) as resource, 
  
  spend,

  abs(
    hash(
      concat(billing_date, platform, service_category, service_subcategory, granularity)
    )
  ) as unique_key,

  sysdate() as dbt_loaded_at
from _window_costs
qualify row_number() over (
  partition by unique_key
  order by spend desc --> pick highest spend in case of overlapping dates for the same cost base
) = 1
order by billing_date, platform, service_category, service_subcategory, granularity
