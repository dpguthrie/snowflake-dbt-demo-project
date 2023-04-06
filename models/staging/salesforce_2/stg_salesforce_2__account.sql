with source as (
    select * from {{ source('salesforce_2', 'account') }}
)

select *
from source