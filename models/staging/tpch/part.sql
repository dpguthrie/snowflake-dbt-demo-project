{{
    config(
        materialized = 'view'
    )
}}
with part as (

    select * from {{ ref('base_tpch__part') }}

)
select 
    part_key,
    name,
    manufacturer,
    brand,
    type,
    size,
    container,
    retail_price
from
    part
order by
    part_key