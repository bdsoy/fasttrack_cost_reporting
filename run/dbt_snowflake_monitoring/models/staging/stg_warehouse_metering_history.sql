-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
        
    

    

    merge into fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_warehouse_metering_history as DBT_INTERNAL_DEST
        using fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_warehouse_metering_history__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.start_time = DBT_INTERNAL_DEST.start_time
                ) and (
                    DBT_INTERNAL_SOURCE.warehouse_id = DBT_INTERNAL_DEST.warehouse_id
                )

    
    when matched then update set
        "START_TIME" = DBT_INTERNAL_SOURCE."START_TIME","END_TIME" = DBT_INTERNAL_SOURCE."END_TIME","WAREHOUSE_ID" = DBT_INTERNAL_SOURCE."WAREHOUSE_ID","WAREHOUSE_NAME" = DBT_INTERNAL_SOURCE."WAREHOUSE_NAME","CREDITS_USED" = DBT_INTERNAL_SOURCE."CREDITS_USED","CREDITS_USED_COMPUTE" = DBT_INTERNAL_SOURCE."CREDITS_USED_COMPUTE","CREDITS_USED_CLOUD_SERVICES" = DBT_INTERNAL_SOURCE."CREDITS_USED_CLOUD_SERVICES"
    

    when not matched then insert
        ("START_TIME", "END_TIME", "WAREHOUSE_ID", "WAREHOUSE_NAME", "CREDITS_USED", "CREDITS_USED_COMPUTE", "CREDITS_USED_CLOUD_SERVICES")
    values
        ("START_TIME", "END_TIME", "WAREHOUSE_ID", "WAREHOUSE_NAME", "CREDITS_USED", "CREDITS_USED_COMPUTE", "CREDITS_USED_CLOUD_SERVICES")

;
    commit;