with part as (
    
    select * from {{ ref('stg_tpch_part') }}

),
supplier as (

    select * from {{ ref('stg_tpch_supplier') }}

),
part_supplier as (

    select * from {{ ref('stg_tpch_part_supplier') }}

)
select 

    part_supplier.part_supplier_key,
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