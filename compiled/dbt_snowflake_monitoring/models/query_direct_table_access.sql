select
    _unique_id,
    query_id,
    query_start_time,
    user_name,
    object_name as full_table_name,
    table_id,
    columns_accessed
from fasttrack_cost_reporting_dev.landing_snowflake_monitoring.query_direct_object_access
where
    object_domain = 'Table' -- removes secured views
    and table_id is not null -- removes tables from a data share