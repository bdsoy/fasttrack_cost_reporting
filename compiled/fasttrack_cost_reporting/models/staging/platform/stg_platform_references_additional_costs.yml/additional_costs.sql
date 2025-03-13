
-- Fixture for additional_costs
select 
    
        try_cast('x1' as character varying(16777216))
     as platform, 
    
        try_cast('x1.daily' as character varying(16777216))
     as servicecharge, 
    
        try_cast('a cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-01' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-01-03' as character varying(16777216))
     as billingdateto, 
    
        try_cast('5.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('0.250000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('daily' as character varying(16777216))
     as granularity
union all
select 
    
        try_cast('x1' as character varying(16777216))
     as platform, 
    
        try_cast('x1.daily' as character varying(16777216))
     as servicecharge, 
    
        try_cast('a cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-02' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-01-04' as character varying(16777216))
     as billingdateto, 
    
        try_cast('5.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('0.500000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('daily' as character varying(16777216))
     as granularity
union all
select 
    
        try_cast('x1' as character varying(16777216))
     as platform, 
    
        try_cast('x1.daily' as character varying(16777216))
     as servicecharge, 
    
        try_cast('some cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-03' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-01-05' as character varying(16777216))
     as billingdateto, 
    
        try_cast('2.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('2.500000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('daily' as character varying(16777216))
     as granularity
union all
select 
    
        try_cast('x1' as character varying(16777216))
     as platform, 
    
        try_cast('x1.daily' as character varying(16777216))
     as servicecharge, 
    
        try_cast('a cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-07' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-01-07' as character varying(16777216))
     as billingdateto, 
    
        try_cast('5.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('0.500000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('daily' as character varying(16777216))
     as granularity
union all
select 
    
        try_cast('x2' as character varying(16777216))
     as platform, 
    
        try_cast('x2.weekly' as character varying(16777216))
     as servicecharge, 
    
        try_cast('some cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-01' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-03-31' as character varying(16777216))
     as billingdateto, 
    
        try_cast('15.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('1.250000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('weekly' as character varying(16777216))
     as granularity
union all
select 
    
        try_cast('x3' as character varying(16777216))
     as platform, 
    
        try_cast('x3.monthly' as character varying(16777216))
     as servicecharge, 
    
        try_cast('a cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-01' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-03-15' as character varying(16777216))
     as billingdateto, 
    
        try_cast('2.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('3.750000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('monthly' as character varying(16777216))
     as granularity
union all
select 
    
        try_cast('x4' as character varying(16777216))
     as platform, 
    
        try_cast('x4.yearly' as character varying(16777216))
     as servicecharge, 
    
        try_cast('yrly cost' as character varying(16777216))
     as servicesubcharge, 
    
        try_cast('2024-01-01' as character varying(16777216))
     as billingdatefrom, 
    
        try_cast('2024-02-10' as character varying(16777216))
     as billingdateto, 
    
        try_cast('1.000000000000' as character varying(16777216))
     as qty, 
    
        try_cast('100.000000000000' as character varying(16777216))
     as price, 
    
        try_cast('USD' as character varying(16777216))
     as currency, 
    
        try_cast('yearly' as character varying(16777216))
     as granularity