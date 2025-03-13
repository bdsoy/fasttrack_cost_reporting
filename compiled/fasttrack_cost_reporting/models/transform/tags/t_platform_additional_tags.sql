

select
  resource,
  resource as object_id, 
  platform as tag_values
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_platform_references_additional_costs
group by all