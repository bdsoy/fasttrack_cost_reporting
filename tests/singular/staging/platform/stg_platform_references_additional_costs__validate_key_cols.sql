with

_src as (
  select * from {{ ref('stg_platform_references_additional_costs') }}
)

select distinct
  'unique_key should be a positive number' as error_reason,
  unique_key::text as error_value
from _src
where coalesce(unique_key, -1) < 0

union all

select distinct
  'billing_date must not be older than 2021-01-01' as error_reason,
  billing_date::text as error_value
from _src
where not coalesce(billing_date, '1990-01-01') >= '2001-01-01'

union all

select distinct
  'platform should not be empty' as error_reason,
  platform::text as error_value
from _src
where len(coalesce(platform, '')) < 1

union all

select distinct
  'account should match platform' as error_reason,
  concat(
    'account: ',
    coalesce(account, 'nil'),
    ' platform: ',
    coalesce(platform, 'nil')
  ) as error_value
from _src
where account != platform

union all

select distinct
  'resource should not be empty' as error_reason,
  resource::text as error_value
from _src
where len(coalesce(resource, '')) < 1

union all

select distinct
  'spend should not be zero' as error_reason,
  spend::text as error_value
from _src
where abs(coalesce(spend, 0)) < 0.000000000001

