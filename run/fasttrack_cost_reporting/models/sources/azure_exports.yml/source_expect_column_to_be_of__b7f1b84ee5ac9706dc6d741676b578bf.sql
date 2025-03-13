select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      

select left(system$typeof(col), 7) as data_type from (
  select max(costinusd) as col from fasttrack_cost_reporting_dev.landing_azure_cost_data_export.dailyexportmtd
)
where data_type not ilike 'varchar%'


      
    ) dbt_internal_test