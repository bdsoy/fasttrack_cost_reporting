

select
  billingaccountname as billing_account_name,
  partnername as partner_name,
  resellername as reseller_name,
  resellermpnid as reseller_mpn_id,
  customertenantid as customer_tenant_id,
  customername as customer_name,
  costcenter as cost_center,
  billingperiodenddate::date as billing_period_end_date,
  billingperiodstartdate::date as billing_period_start_date,
  serviceperiodenddate::date as service_period_end_date,
  serviceperiodstartdate::date as service_period_start_date,
  billingdate::date as billing_date,
  servicefamily as service_family,
  productorderid as product_order_id,
  productordername as product_order_name,
  consumedservice as consumed_service,
  coalesce(meterid, '') as meter_id,
  metername as meter_name,
  metercategory as meter_category,
  metersubcategory as meter_subcategory,
  meterregion as meter_region,
  productid as product_id,
  productname as product_name,
  subscriptionid as subscription_id,
  subscriptionname as subscription_name,
  publishertype as publisher_type,
  publisherid as publisher_id,
  publishername as publisher_name,
  resourcegroupname as resource_group_name,
  coalesce(resourceid, '') as resource_id,
  resourcelocation as resource_location,
  location,
  effectiveprice::number(38,12) as effective_price,
  quantity::number(38,12) as quantity,
  unitofmeasure as unit_of_measure,
  chargetype as charge_type,
  billingcurrency as billing_currency,
  pricingcurrency as pricing_currency,
  costinbillingcurrency::number(38,12) as cost_in_billing_currency,
  costinusd::number(38,12) as cost_in_usd,
  exchangeratepricingtobilling::number(38,12) as exchange_rate_pricing_to_billing,
  exchangeratedate::date as exchange_rate_date,
  serviceinfo1 as service_info_1,
  serviceinfo2 as service_info_2,
  additionalinfo as additional_info,
  try_parse_json(tags) as tags,
  paygprice::number(38,12) as payg_price,
  frequency,
  term,
  reservationid as reservation_id,
  reservationname as reservation_name,
  pricingmodel as pricing_model,
  unitprice::number(38,12) as unit_price,
  benefitid as benefit_id,
  benefitname as benefit_name,
  provider,
  subscription,
  path,
  ingested_date,
  ingested_at,
  batch_timestamp,
  abs(
    hash(
      billing_date || resource_id || meter_id
    )
  ) as unique_key,
  sysdate() as dbt_loaded_at
from fasttrack_cost_reporting_dev.landing_azure_cost_data_export.dailyexportmtd
where billingdate::date is not null
  and ingested_at > (
    select coalesce(max(ingested_at), '2001-01-01')
    from fasttrack_cost_reporting_dev.transform_cost_reporting.stg_azure_daily_exports
  )
qualify row_number() over (
  partition by unique_key
  order by ingested_at desc
) = 1