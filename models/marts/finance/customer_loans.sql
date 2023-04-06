with loans as (
    
    select * from {{ ref('stg_fdic__lending') }}

),

institutions as (

    select * from {{ ref('stg_fdic__institutions') }}

),

joined as (

    select
        i.bank_name,
        i.state,
        i.s_corp,
        i.bank_charter_class,
        i.community_bank,
        l.*
    from loans as l
    join institutions as i on
        l.cert = i.cert

    -- Only include active banks for our analyis
    where i.active = 1

)

select *
from joined