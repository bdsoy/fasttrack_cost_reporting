select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select billingdate
from fasttrack_cost_reporting_dev.publish_cost_reporting.f_cost_reporting
where billingdate is null



      
    ) dbt_internal_test