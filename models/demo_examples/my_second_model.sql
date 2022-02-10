with

final as (

    select *
    from {{ ref('my_first_model') }}

)

select * from final
