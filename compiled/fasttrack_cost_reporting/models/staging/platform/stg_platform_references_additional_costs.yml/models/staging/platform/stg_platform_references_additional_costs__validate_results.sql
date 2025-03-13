

with

 __dbt__cte__fasttrack_additional_platform_costs as (

-- Fixture for additional_costs
select 
    
        try_cast('x1' as character varying(16777216))
     as platform, 
    
        try_cast('x1.daily' as character varying(16777216))
     as servicecharge, 
    
        try_cast('a cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-01' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-01-03' as character varying(16777216))
     as billingdateto, 
    
        try_cast('5.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('0.250000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('daily' as character varying(16777216))
     as granularity
union all
select 
    
        try_cast('x1' as character varying(16777216))
     as platform, 
    
        try_cast('x1.daily' as character varying(16777216))
     as servicecharge, 
    
        try_cast('a cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-02' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-01-04' as character varying(16777216))
     as billingdateto, 
    
        try_cast('5.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('0.500000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('daily' as character varying(16777216))
     as granularity
union all
select 
    
        try_cast('x1' as character varying(16777216))
     as platform, 
    
        try_cast('x1.daily' as character varying(16777216))
     as servicecharge, 
    
        try_cast('some cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-03' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-01-05' as character varying(16777216))
     as billingdateto, 
    
        try_cast('2.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('2.500000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('daily' as character varying(16777216))
     as granularity
union all
select 
    
        try_cast('x1' as character varying(16777216))
     as platform, 
    
        try_cast('x1.daily' as character varying(16777216))
     as servicecharge, 
    
        try_cast('a cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-07' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-01-07' as character varying(16777216))
     as billingdateto, 
    
        try_cast('5.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('0.500000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('daily' as character varying(16777216))
     as granularity
union all
select 
    
        try_cast('x2' as character varying(16777216))
     as platform, 
    
        try_cast('x2.weekly' as character varying(16777216))
     as servicecharge, 
    
        try_cast('some cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-01' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-03-31' as character varying(16777216))
     as billingdateto, 
    
        try_cast('15.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('1.250000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('weekly' as character varying(16777216))
     as granularity
union all
select 
    
        try_cast('x3' as character varying(16777216))
     as platform, 
    
        try_cast('x3.monthly' as character varying(16777216))
     as servicecharge, 
    
        try_cast('a cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-01' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-03-15' as character varying(16777216))
     as billingdateto, 
    
        try_cast('2.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('3.750000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('monthly' as character varying(16777216))
     as granularity
union all
select 
    
        try_cast('x4' as character varying(16777216))
     as platform, 
    
        try_cast('x4.yearly' as character varying(16777216))
     as servicecharge, 
    
        try_cast('yrly cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-01' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-02-10' as character varying(16777216))
     as billingdateto, 
    
        try_cast('1.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('100.000000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('yearly' as character varying(16777216))
     as granularity
), _src_costs as (
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
  from __dbt__cte__fasttrack_additional_platform_costs
  where currency ilike '%USD%' 
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