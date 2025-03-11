{{ config(materialized='ephemeral') }}

select
  object_name as resource,
  iff(
    domain ilike any ('%database%', '%warehouse%'),
    object_name,
    object_id::text
  ) as object_id,
  max(replace(allowed_values[0], '"', '')) as tag_values
from {{ ref('stg_snowflake_account_tag_references') }}
where deleted is null
group by all
