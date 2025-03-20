
    
    

select
    query_id as unique_field,
    count(*) as n_records

from fasttrack_cost_reporting_dev.landing_snowflake_monitoring.cost_per_query
where query_id is not null
group by query_id
having count(*) > 1


