select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with all_values as (

    select
        granularity as value_field,
        count(*) as n_records

    from fasttrack_cost_reporting_dev.publish_cost_reporting.f_cost_reporting
    group by granularity

)

select *
from all_values
where value_field not in (
    'daily','weekly','monthly'
)



      
    ) dbt_internal_test