with source as (

    select * from {{ source('fdic', 'locations') }}

),

renamed as (

    select
        address,
        cbsa,
        cert,
        city,
        county,
        csa,
        estymd as branch_established_date,
        offname as office_name,
        servtype as service_type,
        stname as state,
        zip
    from source

)

select *
from renamed