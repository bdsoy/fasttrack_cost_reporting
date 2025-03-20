select
  unique_key,
  platform,
  billing_date as billingdate,
  account,
  service_category,
  service_subcategory,
  resource,
  environment,
  tag_values,
  managed_by,
  granularity,
  spend
from fasttrack_cost_reporting_dev.transform_cost_reporting.t_cost_reporting