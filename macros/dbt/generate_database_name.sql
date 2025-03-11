{% macro generate_database_name(custom_database_name, node) -%}

{{
  (
    custom_database_name or '{}_{}'.format(
      var('fasttrack_cost_reporting_db')|trim,
      get_cost_reporting_target_env()
    )
  )|trim
}}

{%- endmacro %}
