
  create or replace   view fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_usage_in_currency_daily
  
    
    
(
  
    "ORGANIZATION_NAME" COMMENT $$$$, 
  
    "CONTRACT_NUMBER" COMMENT $$$$, 
  
    "ACCOUNT_NAME" COMMENT $$$$, 
  
    "ACCOUNT_LOCATOR" COMMENT $$$$, 
  
    "REGION" COMMENT $$$$, 
  
    "SERVICE_LEVEL" COMMENT $$$$, 
  
    "USAGE_DATE" COMMENT $$$$, 
  
    "USAGE_TYPE" COMMENT $$$$, 
  
    "CURRENCY" COMMENT $$$$, 
  
    "USAGE" COMMENT $$$$, 
  
    "USAGE_IN_CURRENCY" COMMENT $$$$, 
  
    "BALANCE_SOURCE" COMMENT $$$$
  
)

   as (
    select
    organization_name,
    contract_number,
    account_name,
    account_locator,
    region,
    service_level,
    usage_date,
    usage_type,
    currency,
    usage,
    usage_in_currency,
    balance_source
from snowflake.organization_usage.usage_in_currency_daily
  );

