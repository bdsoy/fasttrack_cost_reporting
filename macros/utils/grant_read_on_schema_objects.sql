{#-/*
  helper macro for giving read-only grants on dbt-managed schema objects to a role
*/-#}

{% macro grant_read_on_schema_objects() -%}

{%- set read_roles_var = var('fasttrack_cost_reporting:read_roles', 'reporter_ft') -%}
{%- set role_suffix = '_' + target.name -%}

{%- for role_prefix in read_roles_var.split(',') if role_prefix|length %}
{%- set role_name = role_prefix + role_suffix -%}

{%- set grant_query -%}
grant usage on schema {{ this.database }}.{{ this.schema }} to role {{ role_name }};
grant select on {{ this }} to role {{ role_name }};
{%- endset -%}

{% do run_query(grant_query) %}
{%- endfor %}

{%- endmacro %}
