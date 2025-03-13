

select left(system$typeof(col), 7) as data_type from (
  select max(qty) as col from fasttrack_cost_reporting_dev.reference_cost_reporting.fasttrack_additional_platform_costs
)
where data_type not ilike 'varchar%'

