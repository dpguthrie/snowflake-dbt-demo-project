with source as (

    select * from {{ source('fdic', 'institutions') }}

),

renamed as (

    select
        active,
        address,
        cert,
        bkclass as bank_charter_class,
        cb as community_bank,
        chrtagnt as chartering_agency,
        city,
        county,
        estymd as established_date,
        fed as federal_reserve_id,
        name as bank_name,
        stname as state,
        subchaps as s_corp,
        zip
    from source

)

select *
from renamed