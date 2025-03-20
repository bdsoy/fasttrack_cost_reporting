
  create or replace   view fasttrack_cost_reporting_dev.publish_cost_reporting.d_cost_reporting_tags
  
    
    
(
  
    "RESOURCE" COMMENT $$$$, 
  
    "OBJECT_ID" COMMENT $$$$, 
  
    "TAG_VALUES" COMMENT $$$$, 
  
    "MANAGED_BY" COMMENT $$$$
  
)

   as (
    select
  resource,
  object_id,
  tag_values,
  managed_by
from fasttrack_cost_reporting_dev.transform_cost_reporting.t_cost_reporting_tags
  );

