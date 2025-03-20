

select
    start_time,
    end_time,
    task_id,
    task_name,
    schema_id,
    schema_name,
    database_id,
    database_name,
    credits_used
from snowflake.account_usage.serverless_task_history


    where end_time > (select dateadd(day, -3, coalesce(max(end_time), '1970-01-01') ) from fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_serverless_task_history)


order by start_time