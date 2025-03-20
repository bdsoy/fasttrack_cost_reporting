select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select billing_date
from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_platform_references_additional_costs
where billing_date is null



      
    ) dbt_internal_test