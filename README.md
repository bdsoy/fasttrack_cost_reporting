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
      account: account.region.cloud.snowflakecomputing.com
      authenticator: externalbrowser # comment out if not using browser SSO
      client_session_keep_alive: false
      database: fasttrack_cost_reporting_dev
      private_key_path: $HOME/.ssh/snowflake_private_key.p8 # comment out if not using key-pair auth
      role: transformer_ft_dev
      schema: public
      threads: 1
      type: snowflake
      user: some.one@email.com
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
uv venv --python 3.12.9 && uv pip install dbt-core==1.9.3 dbt-snowflake==1.9.2 keyring==25.6.0
```

compile:
```sh
source .venv/bin/activate && dbt deps && dbt compile
```

### Future improvements
- document usage instructions
- support multiple currencies (only USD supported as Snowflake billing currency)
- extend test coverage of `f_cost_reporting` with mock data (fixtures) for all staging models
- singular test over `f_cost_reporting` to ensure sums match across all granularities and platforms
- `d_cost_reporting` test coverage and column documentation
- implement monorepo integration test project
- CI/CD: add github action to compile the package and integration project locally and verify that
all tests are passing before merging PRs to main
