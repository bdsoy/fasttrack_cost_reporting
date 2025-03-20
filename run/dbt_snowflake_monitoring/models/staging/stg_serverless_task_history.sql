-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
        
    

    

    merge into fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_serverless_task_history as DBT_INTERNAL_DEST
        using fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_serverless_task_history__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.start_time = DBT_INTERNAL_DEST.start_time
                ) and (
                    DBT_INTERNAL_SOURCE.task_id = DBT_INTERNAL_DEST.task_id
                )

    
    when matched then update set
        "START_TIME" = DBT_INTERNAL_SOURCE."START_TIME","END_TIME" = DBT_INTERNAL_SOURCE."END_TIME","TASK_ID" = DBT_INTERNAL_SOURCE."TASK_ID","TASK_NAME" = DBT_INTERNAL_SOURCE."TASK_NAME","SCHEMA_ID" = DBT_INTERNAL_SOURCE."SCHEMA_ID","SCHEMA_NAME" = DBT_INTERNAL_SOURCE."SCHEMA_NAME","DATABASE_ID" = DBT_INTERNAL_SOURCE."DATABASE_ID","DATABASE_NAME" = DBT_INTERNAL_SOURCE."DATABASE_NAME","CREDITS_USED" = DBT_INTERNAL_SOURCE."CREDITS_USED"
    

    when not matched then insert
        ("START_TIME", "END_TIME", "TASK_ID", "TASK_NAME", "SCHEMA_ID", "SCHEMA_NAME", "DATABASE_ID", "DATABASE_NAME", "CREDITS_USED")
    values
        ("START_TIME", "END_TIME", "TASK_ID", "TASK_NAME", "SCHEMA_ID", "SCHEMA_NAME", "DATABASE_ID", "DATABASE_NAME", "CREDITS_USED")

;
    commit;