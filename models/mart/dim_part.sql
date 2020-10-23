{{
    config(
        materialized = 'table'
    )
}}
with part as (

    select * from {{ref('part')}}
),
final as (
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
)
select *
from final  
order by part_key