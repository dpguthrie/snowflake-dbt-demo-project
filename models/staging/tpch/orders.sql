{{
    config(
        materialized = 'view'
    )
}}
with orders as (

    select * from {{ ref('base_tpch__orders') }}

)
select 
    order_key, 
    order_date,
    customer_key,
    status_code,
    priority_code,
    clerk_name,
    ship_priority,
    total_price
from
    orders
order by
    order_date