with source as (

    select * from {{ source('tpch', 'partsupp') }}

),

renamed as (

    select
    
        {{ dbt_utils.surrogate_key(
            ['ps_partkey', 
            'ps_suppkey']) }} 
                as part_supplier_key,
        ps_partkey as part_key,
        ps_suppkey as supplier_key,
        ps_availqty as available_quantity,
        ps_supplycost as cost,
        ps_comment as comment

    from source

)

select * from renamed