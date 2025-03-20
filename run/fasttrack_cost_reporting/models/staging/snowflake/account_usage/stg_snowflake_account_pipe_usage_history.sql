begin;
    
        
        
        delete from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_account_pipe_usage_history
        where (unique_key) in (
            select distinct unique_key
            from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_account_pipe_usage_history__dbt_tmp
        );

    

    insert into fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_account_pipe_usage_history ("PIPE_ID", "PIPE_NAME", "START_TIME", "END_TIME", "CREDITS_USED", "BYTES_INSERTED", "FILES_INSERTED", "UNIQUE_KEY", "DBT_LOADED_AT")
    (
        select "PIPE_ID", "PIPE_NAME", "START_TIME", "END_TIME", "CREDITS_USED", "BYTES_INSERTED", "FILES_INSERTED", "UNIQUE_KEY", "DBT_LOADED_AT"
        from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_account_pipe_usage_history__dbt_tmp
    );
    commit;