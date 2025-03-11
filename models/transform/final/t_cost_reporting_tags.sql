select 
  coalesce(split_part(f.resource, ',',  1), 'n/a') as resource,
  t.object_id,
  t.tag_values,
  coalesce(max(t.managed_by), 'OTHER') as managed_by,
  sysdate() as dbt_loaded_at
from {{ ref('t_consolidated_tags') }} as t
join {{ ref('t_consolidated_costs') }} as f on ( {# /* TODO: review if left join */ #}
  t.object_id = split_part(
    f.resource,
    ',', 
    iff(len(split_part(f.resource, ',',  2)) < 1, 1, 2)
  )
)
group by all
