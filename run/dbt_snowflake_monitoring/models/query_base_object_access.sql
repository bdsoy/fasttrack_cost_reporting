-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
        
    

    

    merge into fasttrack_cost_reporting_dev.landing_snowflake_monitoring.query_base_object_access as DBT_INTERNAL_DEST
        using fasttrack_cost_reporting_dev.landing_snowflake_monitoring.query_base_object_access__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE._unique_id = DBT_INTERNAL_DEST._unique_id
                ) and (
                    DBT_INTERNAL_SOURCE.query_start_time = DBT_INTERNAL_DEST.query_start_time
                )

    
    when matched then update set
        "_UNIQUE_ID" = DBT_INTERNAL_SOURCE."_UNIQUE_ID","QUERY_ID" = DBT_INTERNAL_SOURCE."QUERY_ID","QUERY_START_TIME" = DBT_INTERNAL_SOURCE."QUERY_START_TIME","USER_NAME" = DBT_INTERNAL_SOURCE."USER_NAME","TABLE_ID" = DBT_INTERNAL_SOURCE."TABLE_ID","OBJECT_NAME" = DBT_INTERNAL_SOURCE."OBJECT_NAME","OBJECT_DOMAIN" = DBT_INTERNAL_SOURCE."OBJECT_DOMAIN","COLUMNS_ACCESSED" = DBT_INTERNAL_SOURCE."COLUMNS_ACCESSED"
    

    when not matched then insert
        ("_UNIQUE_ID", "QUERY_ID", "QUERY_START_TIME", "USER_NAME", "TABLE_ID", "OBJECT_NAME", "OBJECT_DOMAIN", "COLUMNS_ACCESSED")
    values
        ("_UNIQUE_ID", "QUERY_ID", "QUERY_START_TIME", "USER_NAME", "TABLE_ID", "OBJECT_NAME", "OBJECT_DOMAIN", "COLUMNS_ACCESSED")

;
    commit;