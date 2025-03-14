# fasttrack_cost_reporting
standalone dbt package aggregating cost data sources for twoday's Fast Track solution
- [documentation](#documentation)
- [required sources](#package-sources)
- [usage instructions](#usage-instructions)
- [recommended daily jobs](#recommended-daily-jobs)
- [development setup](#development-setup)
- [future improvements](#future-improvements)

## documentation
- [dbt Docs page for all package resources](https://get-select.github.io/dbt-snowflake-monitoring/#!/overview)
- [main lineage](https://bdsoy.github.io/fasttrack_cost_reporting/#!/overview?g_v=1&g_i=%2Bd_cost_reporting_tags%20%2Bf_cost_reporting)
- [final published fact: `f_cost_reporting`](https://bdsoy.github.io/fasttrack_cost_reporting/#!/model/model.fasttrack_cost_reporting.f_cost_reporting#details)

## required sources
guidelines for setting up the infra for the required sources in the package:
- [azure_exports](https://github.com/bdsoy/fasttrack_cost_reporting/tree/main/models/sources#azure_exports)
- [platform_references](https://github.com/bdsoy/fasttrack_cost_reporting/tree/main/models/sources#platform_references)
- [snowflake_account_usage](https://github.com/bdsoy/fasttrack_cost_reporting/tree/main/models/sources#snowflake_usage)
- [snowflake_organization_usage](https://github.com/bdsoy/fasttrack_cost_reporting/tree/main/models/sources#snowflake_usage)

## usage instructions
dbt version required: `>=1.8.0", <2.0.0`

include the following in your [packages.yml](https://docs.getdbt.com/docs/build/packages#how-do-i-add-a-package-to-my-project) file:
```yaml
packages:
  - git: "https://github.com/bdsoy/fasttrack_cost_reporting.git"
    revision: 1.1.0
```

run [`dbt deps`](https://docs.getdbt.com/reference/commands/deps) to install the package

include the following in your [dbt_project.yaml](https://docs.getdbt.com/reference/dbt_project.yml) file:
```yaml
dispatch:
  - macro_namespace: "dbt"
    search_order: 
      - "<YOUR_PROJECT_NAME>"
      - "fasttrack_cost_reporting"
      - "dbt_snowflake_monitoring"
      - "dbt"

query-comment:
  comment: "{{ dbt_snowflake_monitoring.get_query_comment(node) }}"
  append: true

models:
  dbt_snowflake_monitoring:
    +schema: "landing_snowflake_monitoring"

  fasttrack_cost_reporting:
    staging:
      +schema: "transform_cost_reporting" # schema for stg_% models

    transform:
      +schema: "transform_cost_reporting" # schema for t_% models

    publish:
      +schema: "publish_cost_reporting" # schema for d_%, f_% models

sources:
  fasttrack_cost_reporting:
    azure_exports:
      +schema: "landing_azure_cost_data_export" # default schema for azure exports

      daily_mtd:
        +identifier: "dailyexportmtd" # default table/view for azure daily exports (month-to-date)

    platform_references:
      +schema: reference_cost_reporting # default schema for fasttrack mapping tables/seeds

      additional_costs:
        +identifier: fasttrack_additional_platform_costs # default mapping table/view for additional recurring costs

vars:
  dbt_constraints:
    # enable/disable pushing model constraints to the target db
    dbt_constraints_enabled: false

  dbt_snowflake_monitoring:
    # optional dbt cloud metadata, used to enrich dbt-tagged snowflake monitoring data
    dbt_cloud_account_id: 5235
    dbt_cloud_run_url: "https://cloud.getdbt.com/deploy/"

  fasttrack_cost_reporting:
    # azure tags key/value for fasttrack (costs in other tags will not be taken into account)
    fasttrack_cost_reporting:azure_tags_key: "ProjectName"
    fasttrack_cost_reporting:azure_tags_value: "Fast Track Development"

    # comma-separated role prefixes to be granted publish read privileges data, '' or ',' to bypass
    fasttrack_cost_reporting:read_roles: ","
```

see instructions below for more detailed info on package configs:
- [source configuration (overrides)](https://github.com/bdsoy/fasttrack_cost_reporting/tree/main/models/sources#source-configuration-overrides)

p.s. for an example package implementation please check the included
[integration_test_project](https://github.com/bdsoy/fasttrack_cost_reporting/tree/main/integration_test_project)

## recommended daily jobs
load additional costs:
```sh
dbt seed --select additional_costs
```

load azure cost data:
```sh
dbt run-operation copy_into_azure_cost_data
```

refresh package models (including run-time tests) 
```sh
dbt build
```
_**TODO**: incomplete section_

## development setup
`$HOME/.dbt/profiles.yml`:

```yaml
# \/ default connection profile for package debugging
fasttrack_cost_reporting:
  outputs:
    dev:
    account: account.region.cloud
    authenticator: externalbrowser # comment out if not using browser SSO
    client_session_keep_alive: false
    database: fasttrack_cost_reporting_dev
    private_key_path: $HOME/.ssh/sf_key.p8 # comment out if not using key-pair auth
    role: transformer_ft_dev
    schema: public
    threads: 4
    type: snowflake
    user: some.one@email.com
    warehouse: transformer_ft_dev_wh
  target: dev

# \/ default connection profile for `integration_test_project`:
fasttrack_cost_reporting_test: 
  outputs:
    test:
    account: account.region.cloud
    authenticator: externalbrowser # comment out if not using browser SSO
    client_session_keep_alive: false
    database: fasttrack_cost_reporting_test
    private_key_path: $HOME/.ssh/sf_key.p8 # comment out if not using key-pair auth
    role: transformer_ft_test
    schema: public
    threads: 4
    type: snowflake
    user: some.one@email.com
    warehouse: transformer_ft_test_wh
  target: test
```

install uv (macOS):
```sh
brew install uv
```

init venv and install python dependencies:
```sh
uv venv --python 3.12.9 && uv pip install dbt-core==1.9.3 dbt-snowflake==1.9.2
```

activate virtual env and install dev/test dependencies:
```sh
source .venv/bin/activate && dbt deps && dbt deps --project-dir ./integration_test_project
```

refresh dev data (including build-time tests):
```sh
dbt build [--full-refresh]
```

refresh test data (including integration tests):
```sh
dbt build --project-dir ./integration_test_project
```

generate and serve docs:
```sh
dbt docs generate && dbt docs serve
```

## future improvements
- [v2]: move unit tests to `integration_test_project` to improve package usability
- [v2]: add additional costs seed to `integration_test_project`
- [v2]: update azure devops reference fasttrack project to use pkg v2
- [v2]: review readme incomplete instructions / TODOs
- ~~[v2]: review var nomenclature~~
- support multiple billing currencies (only USD allowed as Snowflake billing currency for now)
- extend test coverage of `f_cost_reporting` with mock data (fixtures) for all staging models
- add sinular test over `f_cost_reporting` to ensure sums match across all granularities/platforms
- add `d_cost_reporting` tests and column documentation
- customize/enhance dbt Docs package documentation
- add github action to compile the package and integration project, generate docs and verify that
all tests are passing before merging PRs to main
