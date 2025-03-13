# sources
setup guidelines for the required sources used on `fasttrack_cost_reporting`:
- [azure_exports](#azure_exports)
- [platform_references](#platform_references)
- [snowflake_account_usage](#snowflake_usage)
- [snowflake_organization_usage](#snowflake_usage)

instructions for customizing package source configurations in the end-user project:
- [source configuration (overrides)](#source-configuration-overrides)

## azure_exports
Azure export tables used as primary sources

- ### azure_exports.daily_mtd
  source table/view of azure month-to-date
  [cost data exports](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-export-acm-data)

  ```sql
  create or replace table [export_db].[export_schema].dailyexportmtd (
    unique_id text,
    billingaccountname text,
    partnername text,
    resellername text,
    resellermpnid text,
    customertenantid text,
    customername text,
    costcenter text,
    billingperiodenddate text,
    billingperiodstartdate text,
    serviceperiodenddate text,
    serviceperiodstartdate text,
    billingdate date,
    servicefamily text,
    productorderid text,
    productordername text,
    consumedservice text,
    meterid text,
    metername text,
    metercategory text,
    metersubcategory text,
    meterregion text,
    productid text,
    productname text,
    subscriptionid text,
    subscriptionname text,
    publishertype text,
    publisherid text,
    publishername text,
    resourcegroupname text,
    resourceid text,
    resourcelocation text,
    location text,
    effectiveprice text,
    quantity text,
    unitofmeasure text,
    chargetype text,
    billingcurrency text,
    pricingcurrency text,
    costinbillingcurrency text,
    costinusd text, --> a warning will be thrown in case this a numeric type
    exchangeratepricingtobilling text,
    exchangeratedate text,
    serviceinfo1 text,
    serviceinfo2 text,
    additionalinfo text,
    tags text,
    paygprice text,
    frequency text,
    term text,
    reservationid text,
    reservationname text,
    pricingmodel text,
    unitprice text,
    benefitid text,
    benefitname text,
    provider text,
    subscription text,
    path text not null,
    ingested_date date not null,
    ingested_at timestamp_ntz(9) not null,
    batch_timestamp timestamp_ntz(9) not null
  );
  ```

  obs. the package macro
  [`fasttrack_cost_reporting.copy_into_azure_cost_data`](https://bdsoy.github.io/fasttrack_cost_reporting/#!/macro/macro.fasttrack_cost_reporting.copy_into_azure_cost_data)
  is provided as a helper to load azure cost data into this table, via e.g.:
  ```sh
  dbt run-operation copy_into_azure_cost_data --args '{ subscriptionname: DEV_TST___ISOLATED___FASTTRACK_SF_DEV, stagename: STAGE_AZURE_COST_DATA_EXPORT_DEV }'
  ```

## platform_references
Fast Track mapping tables used as primary sources (references)

- ### platform_references.additional_costs
  reference mapping table/view describing additional recurring daily/weekly/monthly/yearly costs

  **attention**: even if there are no recurring aditional costs to be taken into account an empty
  mapping table with the correct schema is still required for the package to work

  ```sql
  create or replace table [cost_db].[reference_schema].fasttrack_additional_platform_costs (
    platform text,
    servicecharge text,
    servicesubcharge text,
    billingdatefrom text,
    billingdateto text,
    qty text, --> a warning will be thrown in case this a numeric type
    price text, --> a warning will be thrown in case this a numeric type
    currency text,
    granularity text --> accepted values: daily | weekly | monthly | yearly
  ) as (
    select
      'dbt' as platform,
      'Team Licence' as servicecharge,
      'Developer Licence Per User' as servicesubcharge,
      '2024-01-01' as billingdatefrom,
      '2024-12-31' as billingdateto,
      '8' as qty,
      '100' as price,
      'USD' as currency,
      'Monthly' as granularity

    union all

    select
      'dbt' as platform,
      'Team Licence' as servicecharge,
      'Developer Licence Per User' as servicesubcharge,
      '2025-01-01' as billingdatefrom,
      '2025-12-31' as billingdateto,
      '8' as qty,
      '100' as price,
      'USD' as currency,
      'Monthly' as granularity
  )
  ```

  the dbt project using the package may provision this source as a table
  [seed](https://docs.getdbt.com/docs/build/seeds)
  with the data type for **all columns set to TEXT/VARCHAR** via:

  - #### seeds/fasttrack_additional_platform_costs.csv
    ```csv
    platform,servicecharge,servicesubcharge,billingdatefrom,billingdateto,qty,price,currency,granularity
    dbt,Team Licence,Developer Licence Per User,2024-01-01,2024-12-31,8,100,USD,Monthly
    dbt,Team Licence,Developer Licence Per User,2025-01-01,2025-12-31,8,100,USD,Monthly
    ```

  - #### seeds/fasttrack_additional_platform_costs.yaml
    ```yaml
    seeds:
      - name: fasttrack_additional_platform_costs
        config:
          database: platform_references_database # default: {{ target.database }}
          schema: platform_referemces_schema # default: reference_cost_reporting
          alias: platform_references_additional_costs # default: fasttrack_additional_platform_costs
          delimiter: ','
          column_types:
            platform: text
            servicecharge: text
            servicesubcharge: text
            billingdatefrom: text
            billingdateto: text
            qty: text # a warning will be thrown in case this a numeric type
            price: text # a warning will be thrown in case this a numeric type
            currency: text
            granularity: text # accepted values: daily | weekly | monthly | yearly       
    ```

  - #### dbt_project.yaml
    alternative option to configure seeds on the project-level:

    ```yaml
    seeds:
      [dbt-project-name]:
        fasttrack_additional_platform_costs:
          +database: platform_references_database # default: {{ target.database }}
          +schema: platform_referemces_schema # default: reference_cost_reporting
          +alias: platform_references_additional_costs # default: fasttrack_additional_platform_costs
          +delimiter: ','
          +column_types:
            platform: text
            servicecharge: text
            servicesubcharge: text
            billingdatefrom: text
            billingdateto: text
            qty: text # a warning will be thrown in case this a numeric type
            price: text # a warning will be thrown in case this a numeric type
            currency: text
            granularity: text # accepted values: daily | weekly | monthly | yearly    
    ```

## snowflake_usage
snowflake metadata sources `snowflake_account_usage` and `snowflake_organization_usage` do not
require additional setup configurations as these are standardized but it's important to ensure
that `ORGADMIN` is enabled on the snowflake account (instructions
[here](https://select.dev/docs/snowflake-metadata-access#step-5-ensure-your-account-has-orgadmin-access))
and that the dbt user role has sufficient privileges (see below) to read cost data for the account

```sql
grant imported privileges on database snowflake to role transformer_ft_[env];
grant monitor usage on account to role transformer_ft_[env];
```
## source configuration (overrides)
settings for package sources can be customized via:

- #### models/source_overrides.yml
  this file can be located anywhere within `/models` in the project using the package:

  ```yaml
  sources:
    - name: azure_exports
      overrides: fasttrack_cost_reporting

      database: azure_exports_landing_database # default: {{ target.database }}
      schema: azure_exports_landing_schema # default: landing_azure_cost_data_export

      tables:
        - name: daily_mtd
          identifier: daily_export_month_to_date # default: dailyexportmtd

    - name: snowflake_organization_usage
      overrides: fasttrack_cost_reporting

      database: platform_references_database # default: {{ target.database }}
      schema: platform_referemces_schema # default: reference_cost_reporting

      tables:
        - name: additional_costs
          identifier: platform_references_additional_costs # default: fasttrack_additional_platform_costs
  ```

- #### dbt_project.yml
  alternative option to override package source settings on the project-level:

  ```yaml
  sources:
    fasttrack_cost_reporting:
      azure_exports:
        +database: azure_exports_landing_database # default: {{ target.database }}
        +schema: azure_exports_landing_schema # default: landing_azure_cost_data_export

        daily_mtd:
          +identifier: daily_export_month_to_date # default: dailyexportmtd

      platform_references:
        +database: platform_references_database # default: {{ target.database }}
        +schema: platform_referemces_schema # default: reference_cost_reporting

        additional_costs:
          +identifier: platform_references_additional_costs # default: fasttrack_additional_platform_costs
  ```
