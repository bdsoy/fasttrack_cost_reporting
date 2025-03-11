{#-/*
  simple historization model over the snowflake.account_usage.pipe_usage_history view in
  order to retain data for longer than 1 year
*/-#}

{{ 
  config(
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key='unique_key',
    on_schema_change='fail'
  )
}}

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
from {{ source('snowflake_account_usage', 'pipe_usage_history') }}
where pipe_id is not null
  and start_time > (
    select coalesce(max(start_time), '2001-01-01')
    from {{
      this if is_incremental() else '(select null::timestamp_ltz as start_time)'
    }}
  )
qualify row_number() over (
  partition by unique_key
  order by start_time, end_time
) = 1
