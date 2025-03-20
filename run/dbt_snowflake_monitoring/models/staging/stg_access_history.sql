-- back compat for old kwarg name
  
  begin;
    

        insert into fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_access_history ("QUERY_ID", "PARENT_QUERY_ID", "ROOT_QUERY_ID", "QUERY_START_TIME", "USER_NAME", "DIRECT_OBJECTS_ACCESSED", "BASE_OBJECTS_ACCESSED", "OBJECTS_MODIFIED")
        (
            select "QUERY_ID", "PARENT_QUERY_ID", "ROOT_QUERY_ID", "QUERY_START_TIME", "USER_NAME", "DIRECT_OBJECTS_ACCESSED", "BASE_OBJECTS_ACCESSED", "OBJECTS_MODIFIED"
            from fasttrack_cost_reporting_dev.landing_snowflake_monitoring.stg_access_history__dbt_tmp
        );
    commit;