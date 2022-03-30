{{
    config(
        enabled=true,
        severity='error',
        error_if='>10',
        tags = ['finance']
    )
}}

with orders as ( select * from {{ ref('stg_tpch_orders') }} )

select *
from   orders 
where  total_price < 0
