
  create or replace   view fasttrack_cost_reporting_dev.transform_cost_reporting.stg_snowflake_account_tag_references
  
    
    
(
  
    "TAG_DATABASE" COMMENT $$The database in which the tag is set$$, 
  
    "TAG_SCHEMA" COMMENT $$The schema in which the tag is set$$, 
  
    "TAG_ID" COMMENT $$Internal/system-generated identifier for the tag, NULL for system tags$$, 
  
    "TAG_NAME" COMMENT $$The name of the tag, this is the key in the key = 'value' pair of the tag$$, 
  
    "TAG_VALUE" COMMENT $$The value of tag, this is the 'value' in the key = 'value' pair of the tag$$, 
  
    "OBJECT_DATABASE" COMMENT $$Database name of the referenced object for database and schema objects. If the object is not a database or schema object, the value is empty.$$, 
  
    "OBJECT_SCHEMA" COMMENT $$Schema name of the referenced object (for schema objects). If the referenced object is not a schema object (e.g. warehouse), this value is empty.$$, 
  
    "OBJECT_ID" COMMENT $$Internal identifier of the referenced object.$$, 
  
    "OBJECT_NAME" COMMENT $$Name of the referenced object if the tag association is on the object. If the tag association is on a column, Snowflake returns the parent table name.$$, 
  
    "OBJECT_DELETED" COMMENT $$Date and time when the associated object was dropped, or if the parentobject is dropped.$$, 
  
    "DOMAIN" COMMENT $$Domain of the reference object (e.g. table, view) if the tag association is on the object. For columns, the domain is COLUMN if the tag association is on a column.$$, 
  
    "COLUMN_ID" COMMENT $$The local identifier of the reference column; not applicable if the tag association is not a column.$$, 
  
    "COLUMN_NAME" COMMENT $$Name of the referenced column; not applicable if the tag association is not a column.$$, 
  
    "TAG_SCHEMA_ID" COMMENT $$The local identifier of the tag schema$$, 
  
    "TAG_DATABASE_ID" COMMENT $$The local identifier of the database in which the tag exists$$, 
  
    "TAG_OWNER" COMMENT $$The name of the role that owns the tag$$, 
  
    "TAG_COMMENT" COMMENT $$Comments for the tag, if any$$, 
  
    "CREATED" COMMENT $$Date and time when the tag was created$$, 
  
    "LAST_ALTERED" COMMENT $$Date and time the object was last altered by a DML, DDL, or background metadata operation$$, 
  
    "DELETED" COMMENT $$Date and time when the tag was dropped, or the date and time when its parents were dropped$$, 
  
    "ALLOWED_VALUES" COMMENT $$Specifies the possible string values that can be assigned to the tag when the tag is set on an object or NULL if the tag does not have any specified allowed values.$$, 
  
    "OWNER_ROLE_TYPE" COMMENT $$The type of role that owns the object, for example ROLE. If a Snowflake Native App owns the object, the value is APPLICATION. Snowflake returns NULL if you delete the object because a deleted object does not have an owner role.$$, 
  
    "DBT_LOADED_AT" COMMENT $$control timestamp indicating when a row was refreshed via dbt, in UTC$$
  
)

   as (
    select
  tr.tag_database,
  tr.tag_schema,
  tr.tag_id,
  tr.tag_name,
  tr.tag_value,
  tr.object_database,
  tr.object_schema,
  tr.object_id,
  tr.object_name,
  tr.object_deleted,
  tr.domain,
  tr.column_id,
  tr.column_name,
  ta.tag_schema_id,
  ta.tag_database_id,
  ta.tag_owner,
  ta.tag_comment,
  ta.created,
  ta.last_altered,
  ta.deleted,
  ta.allowed_values,
  ta.owner_role_type,
  sysdate() as dbt_loaded_at
from snowflake.account_usage.tags as ta
join snowflake.account_usage.tag_references as tr on (
  ta.tag_id = tr.tag_id
)
  );

