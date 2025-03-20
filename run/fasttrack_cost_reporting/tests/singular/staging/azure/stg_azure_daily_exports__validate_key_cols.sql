select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      with

_src as (
  select * from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_azure_daily_exports
)

select distinct
  'unique_key should be a positive number' as error_reason,
  unique_key::text as error_value
from _src
where coalesce(unique_key, -1) < 0

union all

select distinct
  'billing_date must occur between 2001-01-01 and current date' as error_reason,
  billing_date::text as error_value
from _src
where coalesce(billing_date, '1990-01-01') not between '2001-01-01' and sysdate()::date

union all

select distinct
  'ingested_at must occur between 2001-01-01 and current date' as error_reason,
  ingested_at::text as error_value
from _src
where coalesce(ingested_at::date, '1990-01-01') not between '2001-01-01' and sysdate()::date

union all

select distinct
  'billing_date must not be more recent than ingestion_date' as error_reason,
  concat(
    'billing: ',
    coalesce(billing_date::text, 'nil'),
    ' ingestion: ',
    coalesce(date(ingested_at)::text, 'nil')
  ) as error_value
from _src
where coalesce(billing_date, '1990-01-01') > coalesce(date(ingested_at), '2001-01-01')
      
    ) dbt_internal_test