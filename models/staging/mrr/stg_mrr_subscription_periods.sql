with source as (

    select * from {{ source('mrr', 'subscription_periods') }}

),

cleanup as (

    select
    
        subscription_id,
        customer_id,
        start_date,
        end_date,
        monthly_amount

    from source

)

select * from cleanup