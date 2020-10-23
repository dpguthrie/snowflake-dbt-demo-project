{{
    config(
        materialized = 'view'
    )
}}
with nation as (

    select * from {{ ref('base_tpch__nation') }}

)
select 
    nation_key,
    name,
    region_key
from
    nation
order by
    nation_key