{{
    config(
        materialized = 'table'
    )
}}

with supplier as (

    select * from {{ ref('stg_tpch_suppliers') }}

),
nation as (

    select * from {{ ref('stg_tpch_nations') }}
),
region as (

    select * from {{ ref('stg_tpch_regions') }}

),
final as (

    select 
        supplier.supplier_key,
        supplier.supplier_name,
        supplier.supplier_address,
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

select * from final
