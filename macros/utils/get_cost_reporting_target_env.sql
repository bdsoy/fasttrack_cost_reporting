{% macro get_cost_reporting_target_env() -%}

{%- set target_name = target.name|trim|lower -%}

{{
  return(
    target_name if target_name in ('test', 'prod') else 'dev'
  )
}}

{%- endmacro %}
