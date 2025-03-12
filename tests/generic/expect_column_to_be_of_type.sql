{% test expect_column_to_be_of_type(model, column_name, data_type) %}

select data_type from (
  select left(system$typeof(max({{ column_name }})), len('{{ data_type|trim }}')) as data_type
  from {{ model }}
)
where data_type not ilike '{{ data_type|trim }}%'

{% endtest %}
