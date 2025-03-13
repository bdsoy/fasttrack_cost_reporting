# fasttrack_cost_reporting
standalone dbt package aggregating cost data from multiple sources for twoday's Fast Track solution

## Local development setup:
dbt connection profile (macOS):
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
      private_key_path: $HOME/.ssh/sf_private_key.p8 # comment out if not using key-pair auth
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

refresh data (inc. tests):
```sh
source .venv/bin/activate && dbt build
```

preview docs:
```sh
source .venv/bin/activate && dbt docs generate && dbt docs serve
```

## Future improvements
- document usage instructions
- support multiple currencies (only USD allowed as Snowflake billing currency for now)
- extend test coverage of `f_cost_reporting` with mock data (fixtures) for all staging models
- add singular test over `f_cost_reporting` to ensure sums match across all granularities/platforms
- add `d_cost_reporting` tests and column documentation
- add github action to compile the package and integration project, generate docs and verify that
all tests are passing before merging PRs to main
