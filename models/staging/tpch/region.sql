{{
    config(
        materialized = 'view'
    )
}}
with region as (

    select * from {{ ref('base_tpch__region') }}

)
select 
    region_key,
    name
from
    region
order by
    region_key