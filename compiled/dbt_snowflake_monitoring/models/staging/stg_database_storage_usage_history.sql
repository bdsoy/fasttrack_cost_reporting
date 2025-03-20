

select
    usage_date as date,
    database_name,
    average_database_bytes,
    average_failsafe_bytes,
    average_hybrid_table_storage_bytes
from snowflake.account_usage.database_storage_usage_history