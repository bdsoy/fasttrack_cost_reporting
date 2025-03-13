

select
  pipe_id,
  pipe_name,
  start_time,
  end_time,
  coalesce(credits_used, 0) as credits_used,
  bytes_inserted,
  files_inserted,

  abs(hash(extract('epoch_second', start_time) || pipe_id)) as unique_key,
  sysdate() as dbt_loaded_at
from snowflake.account_usage.pipe_usage_history
where pipe_id is not null
  and start_time > (
    select coalesce(max(start_time), '2001-01-01')
    from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_account_pipe_usage_history
  )
qualify row_number() over (
  partition by unique_key
  order by start_time, end_time
) = 1