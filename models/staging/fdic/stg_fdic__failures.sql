with source as (

    select * from {{ source('fdic', 'failures') }}

),

renamed as (

    select
        cert,
        cost as estimated_loss,
        faildate as failure_date,
        failyr as failure_year,
        name,
        restype as resolution,
        restype1 as transaction_type,
        savr as insurance_fund
    from source

)

select *
from renamed