{{
    config(
        materialized = 'view'
    )
}}
with part as (
    
    select * from {{ ref('part') }}

),
supplier as (

    select * from {{ ref('supplier') }}

),
part_supplier as (

    select * from {{ ref('base_tpch__part_supplier') }}

)
select 

    {{ dbt_utils.surrogate_key(['part.part_key', 'supplier.supplier_key']) }} as part_supplier_key,

    part.part_key,
    part.name as part_name,
    part.manufacturer,
    part.brand,
    part.type as part_type,
    part.size as part_size,
    part.container,
    part.retail_price,

    supplier.supplier_key,
    supplier.name as supplier_name,
    supplier.nation_key,

    part_supplier.available_quantity,
    part_supplier.cost
from
    part 
inner join 
    part_supplier
        on part.part_key = part_supplier.part_key
inner join
    supplier
        on part_supplier.supplier_key = supplier.supplier_key
order by
    part.part_key