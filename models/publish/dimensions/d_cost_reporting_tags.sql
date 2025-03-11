select
  resource,
  object_id,
  tag_values,
  managed_by
from {{ ref('t_cost_reporting_tags') }}
