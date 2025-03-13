with

_src as (
  select * from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_account_pipe_usage_history
)

select distinct
  'unique_key should be a positive number' as error_reason,
  unique_key::text as error_value
from _src
where coalesce(unique_key, -1) < 0

union all

select distinct
  'start_time must occur between 2001-01-01 and current date' as error_reason,
  start_time::text as error_value
from _src
where coalesce(start_time::date, '1990-01-01') not between '2001-01-01' and sysdate()::date

union all

select distinct
  'end_time must occur between 2001-01-01 and current date' as error_reason,
  end_time::text as error_value
from _src
where coalesce(end_time::date, '1990-01-01') not between '2001-01-01' and sysdate()::date

union all

select distinct
  'start_time must not be more recent than end_time' as error_reason,
  concat(
    'billing: ',
    coalesce(start_time::text, 'nil'),
    ' ingestion: ',
    coalesce(end_time::text, 'nil')
  ) as error_value
from _src
where coalesce(start_time, '1990-01-01') > coalesce(end_time, '2001-01-01')

union all

select distinct
  'pipe_id should not be empty' as error_reason,
  pipe_id::text as error_value
from _src
where len(coalesce(pipe_id, '')) < 1

union all

select distinct
  'pipe_name should not be empty' as error_reason,
  pipe_name::text as error_value
from _src
where len(coalesce(pipe_name, '')) < 1