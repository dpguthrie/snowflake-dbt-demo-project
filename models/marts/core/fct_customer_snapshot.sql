{{
    config(
        materialized='table'
    )
}}
with source as (
    
    select * from {{ ref('customer_snapshot') }}
​
)
​
select * from source
​
--where c_custkey = '4'