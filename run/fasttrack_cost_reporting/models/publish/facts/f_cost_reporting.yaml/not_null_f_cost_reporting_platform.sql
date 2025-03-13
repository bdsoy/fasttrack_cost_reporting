select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select platform
from fasttrack_cost_reporting_dev.publish_cost_reporting.f_cost_reporting
where platform is null



      
    ) dbt_internal_test