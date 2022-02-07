with

final as (

    select 1 as id
    union all
    select 2 as id
    union all
    select null as id

)

select * from final