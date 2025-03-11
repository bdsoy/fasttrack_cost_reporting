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
from {{ ref('t_cost_reporting') }}
