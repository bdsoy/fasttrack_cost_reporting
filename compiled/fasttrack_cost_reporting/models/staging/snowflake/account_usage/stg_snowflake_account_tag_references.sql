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