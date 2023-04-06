with source as (
    select * from {{ source('salesforce_1', 'account') }}
)

select *
from source