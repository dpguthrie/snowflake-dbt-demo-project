with source as (

    select * from {{ source('tpch', 'supplier') }}

),

renamed as (

    select
        s_suppkey as supplier_key,
        s_name as name,
        s_address as address,
        s_nationkey as nation_key,
        s_phone as phone_number,
        s_acctbal as account_balance,
        s_comment as comment

    from source

)

select * from renamed