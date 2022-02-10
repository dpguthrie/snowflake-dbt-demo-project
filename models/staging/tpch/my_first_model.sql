with

final as (

    select 1 as id, 1000 as amount
    union all
    select 2 as id, 1250 as amount
    union all
    select null as id, -1000 as amount

)

select * from final