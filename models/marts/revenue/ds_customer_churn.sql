{{
    config(
        meta = {
            'continual': {
                'type':'Model',
                'index':'customer_id',
                'time_index': 'date_month',
                'target': 'next_month_is_active',
            }
        }
    )
}}

select customer_id
    , date_month
    , mrr
    , mrr_change
    , is_first_month
    , next_month_is_active
from (
    select *
        , lead(is_active) over (partition by customer_id order by date_month) as next_month_is_active
    from  {{ ref('mrr') }}
)
where is_active = True