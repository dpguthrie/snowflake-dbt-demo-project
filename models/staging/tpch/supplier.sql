{{
    config(
        materialized = 'view'
    )
}}
with supplier as (

    select * from {{ ref('base_tpch__supplier') }}

)
select 
    supplier_key,
    name,
    address,
    nation_key,
    phone_number,
    account_balance,
    comment
from
    supplier
order by
    supplier_key