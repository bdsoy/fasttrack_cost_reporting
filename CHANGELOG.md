# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)

## dbt-snowflake-monitoring 1.0.3 - March 11, 2025

### Features

- Add project variable `fasttrack_cost_reporting_enable_extras` so that end users can choose to
enable full functionality from package
[dbt-snowflake-monitoring](https://github.com/get-select/dbt-snowflake-monitoring/blob/main/CHANGELOG.md)
including granular cost data not strictly needed or not yet implemented for fasttrack_cost_reporting
([#2](https://github.com/bdsoy/fasttrack_cost_reporting/pull/2))


## dbt-snowflake-monitoring 1.0.2 - March 11, 2025

### Fixes

- Enforce [dbt-snowflake-monitoring](https://github.com/get-select/dbt-snowflake-monitoring/blob/main/CHANGELOG.md)
v5.4+ due to previous known issues aggregating certain cost sources from Snowflake ([#1](https://github.com/bdsoy/fasttrack_cost_reporting/pull/1))


## dbt-snowflake-monitoring 1.0.1 - February 17, 2025

### Features

- Initial stable release migrated from Azure DevOps repo
