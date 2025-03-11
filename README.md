## FT-SF-TRANSFORMATION-DBT-PLATFORM-COST-PKG
home repo for the `fasttrack_cost_reporting` standalone dbt package aggregating
azure+dbt+snowflake cost data as part of twoday's Fast Track solution

### Local development setup:
dbt connection profile:
```sh
export DBT_PATH="$HOME/.dbt"
mkdir -p $DBT_PATH
cat <<EOT >> $DBT_PATH/profiles.yml

fasttrack_cost_reporting:
  outputs:
    dev:
      account: wt01712.west-europe.azure
      authenticator: externalbrowser
      database: fasttrack_cost_reporting_dev
      role: transformer_ft_dev
      schema: public
      threads: 1
      type: snowflake
      user: some.one@twoday.com
      warehouse: transformer_ft_dev_wh
  target: dev

EOT
```

uv:
```sh
brew install uv
```

venv:
```sh
uv venv --python 3.13.1 && uv pip install dbt-core==1.9.1 dbt-snowflake==1.9.0 keyring==25.6.0
```

build:
```sh
source .venv/bin/activate && dbt deps && dbt build
```

### Future improvements
- usage instructions
- multi-currency support
- improved test coverage of `f_cost_reporting` with mock data (fixtures) for all staging models
- singular test over `f_cost_reporting` to ensure sums match across all granularities for every platform
- `d_cost_reporting` test coverage
- monorepo integration test project
- CI/CD: add github action to dbt compile package and run unit tests before merging PRs to main
