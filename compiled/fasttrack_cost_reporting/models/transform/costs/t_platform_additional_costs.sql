

select
  unique_key,
  platform,
  billing_date,
  account,
  service_category,
  service_subcategory,
  resource,
  spend
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_platform_references_additional_costs