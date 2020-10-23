{{
    config(
        materialized = 'table'
    )
}}
with supplier as (

    select * from {{ ref('supplier') }}

),
nation as (

    select * from {{ ref('nation') }}
),
region as (

    select * from {{ ref('region') }}

),
final as (

    select 
        supplier.supplier_key,
        supplier.name,
        supplier.address,
        nation.name as nation,
        region.name as region,
        supplier.phone_number,
        supplier.account_balance
    from
        supplier
    inner join nation
            on supplier.nation_key = nation.nation_key
    inner join region 
            on nation.region_key = region.region_key
)
select 
    *
from
    final
order by
    supplier_key