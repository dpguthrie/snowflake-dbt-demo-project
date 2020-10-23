{{
    config(
        materialized = 'view'
    )
}}
with customer as (

    select * from {{ ref('base_tpch__customer') }}

)
select 
    customer_key,
    name,
    address,
    nation_key,
    phone_number,
    account_balance,
    market_segment
from
    customer
order by
    customer_key