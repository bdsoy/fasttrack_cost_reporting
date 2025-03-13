
  create or replace   view fasttrack_cost_reporting_dev.publish_cost_reporting.f_cost_reporting
  
    
    
(
  
    "UNIQUE_KEY" COMMENT $$Unique key to identifying the cost record for the specified granularity$$, 
  
    "PLATFORM" COMMENT $$Platform name (service provider) associated to the additional cost, e.g. Azure, Snowflake$$, 
  
    "BILLINGDATE" COMMENT $$Date of the billing period for the cost record, according to the specified granularity$$, 
  
    "ACCOUNT" COMMENT $$Account identifier associated to the additional cost$$, 
  
    "SERVICE_CATEGORY" COMMENT $$Classification of the service charge coming from the platform service provider$$, 
  
    "SERVICE_SUBCATEGORY" COMMENT $$Sub-classification of the service subcharge coming from the platform service provider$$, 
  
    "RESOURCE" COMMENT $$Describes the source-aligned cost source identifier, varies according to platform$$, 
  
    "ENVIRONMENT" COMMENT $$Environment in which the cost was incurred, e.g. dev/test/prod/other$$, 
  
    "TAG_VALUES" COMMENT $$Tag values associated to the cost record, according to the source syntax$$, 
  
    "MANAGED_BY" COMMENT $$Entity maintaining the cost record, for most cases it should be only FAST_TRACK$$, 
  
    "GRANULARITY" COMMENT $$Granularity of the cost record, e.g. daily, monthly, yearly$$, 
  
    "SPEND" COMMENT $$Amount spent from the cost record, in USD$$
  
)

   as (
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
  );

