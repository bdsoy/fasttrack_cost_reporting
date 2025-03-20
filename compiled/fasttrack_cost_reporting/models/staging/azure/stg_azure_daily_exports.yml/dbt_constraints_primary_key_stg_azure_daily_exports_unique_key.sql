with validation_errors as (
    select
        unique_key, count(*) as row_count
    from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_azure_daily_exports
    group by unique_key
    having count(*) > 1
        or unique_key is null
        
)

select *
from validation_errors