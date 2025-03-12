{#-/*
  helper macro for copying azure exports into snowflake, to be used externally
*/-#}

{%-
  macro copy_into_azure_cost_data(
    subscriptionname,
    stagename='stage_azure_cost_data_export',
    fileformat='fmt_csv',
    sourcedatabase=target.database,
    sourceschema='landing_azure_cost_data_export',
    sourcepath='dailyexportmtd',
    targetdatabase=target.database,
    targetschema='landing_azure_cost_data_export',
    targettable='dailyexportmtd'
  ) 
-%}

{% set copy_into %}

copy into {{ targetdatabase }}.{{ targetschemaa }}.{{ targettable }}
from (
  select
    to_char(try_to_date(t.$12)) || t.$30 || $17 as unique_id,
    t.$1 as billingaccountname,
    t.$2 as partnername,
    t.$3 as resellername,
    t.$4 as resellermpnid,
    t.$5 as customertenantid,
    t.$6 as customername,
    t.$7 as costcenter,
    t.$8 as billingperiodenddate,
    t.$9 as billingperiodstartdate,
    t.$10 as serviceperiodenddate,
    t.$11 as serviceperiodstartdate,
    try_to_date(t.$12) as billingdate,
    t.$13 as servicefamily,
    t.$14 as productorderid,
    t.$15 as productordername,
    t.$16 as consumedservice,
    t.$17 as meterid,
    t.$18 as metername,
    t.$19 as metercategory,
    t.$20 as metersubcategory,
    t.$21 as meterregion,
    t.$22 as productid,
    t.$23 as productname,
    t.$24 as subscriptionid,
    t.$25 as subscriptionname,
    t.$26 as publishertype,
    t.$27 as publisherid,
    t.$28 as publishername,
    t.$29 as resourcegroupname,
    t.$30 as resourceid,
    t.$31 as resourcelocation,
    t.$32 as location,
    t.$33 as effectiveprice,
    t.$34 as quantity,
    t.$35 as unitofmeasure,
    t.$36 as chargetype,
    t.$37 as billingcurrency,
    t.$38 as pricingcurrency,
    t.$39 as costinbillingcurrency,
    t.$40 as costinusd,
    t.$41 as exchangeratepricingtobilling,
    t.$42 as exchangeratedate,
    t.$43 as serviceinfo1,
    t.$44 as serviceinfo2,
    t.$45 as additionalinfo,
    t.$46 as tags,
    t.$47 as paygprice,
    t.$48 as frequency,
    t.$49 as term,
    t.$50 as reservationid,
    t.$51 as reservationname,
    t.$52 as pricingmodel,
    t.$53 as unitprice,
    t.$54 as benefitid,
    t.$55 as benefitname,
    t.$56 as provider,
    '{{ subscriptionname }}' as subscription,
    metadata$filename as path,
    convert_timezone('UTC', metadata$start_scan_time)::date as ingested_date,
    convert_timezone('UTC', metadata$start_scan_time)::timestamp_ntz as ingested_at,
    convert_timezone('UTC', current_timestamp())::timestamp_ntz as batch_timestamp
  from @{{ sourcedatabase }}.{{ sourceschema }}.{{ stagename }}/{{ subscriptionname }}/{{ sourcepath }}/ as t
)
file_format = (format_name = '{{ sourcedatabase }}.{{ sourceschema }}.{{ fileformat }}');

{%- endset -%}


{% do run_query(copy_into) %}

{%- endmacro -%}
