# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)

## dbt-snowflake-monitoring 1.1.0 - March 11, 2025

### Features

- Add tag "extras_dbt_snowflake_monitoring" so that end users can choose to
bypass extra models from 
[dbt-snowflake-monitoring](https://github.com/get-select/dbt-snowflake-monitoring/blob/main/CHANGELOG.md)
that are not strictly needed or not yet taken into account within fasttrack_cost_reporting
([#2](https://github.com/bdsoy/fasttrack_cost_reporting/pull/2))

### Fixes

- Remove variables that weren't actually needed or that could cause run-time parsing issues([#2](https://github.com/bdsoy/fasttrack_cost_reporting/pull/2))


## dbt-snowflake-monitoring 1.0.2 - March 11, 2025

### Fixes

- Enforce [dbt-snowflake-monitoring](https://github.com/get-select/dbt-snowflake-monitoring/blob/main/CHANGELOG.md)
v5.4+ due to previous known issues aggregating certain cost sources from Snowflake ([#1](https://github.com/bdsoy/fasttrack_cost_reporting/pull/1))


## dbt-snowflake-monitoring 1.0.1 - February 17, 2025

### Features

- Initial stable release migrated from Azure DevOps repo
