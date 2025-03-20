
    
    



select ingested_at
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_azure_daily_exports
where ingested_at is null


