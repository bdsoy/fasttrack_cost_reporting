{% test expect_column_to_be_of_type(model, column_name, data_type) %}

select left(system$typeof(col), {{ data_type|trim|length }}) as data_type from (
  select max({{ column_name }}) as col from {{ model }}
)
where data_type not ilike '{{ data_type|trim }}%'

{% endtest %}
