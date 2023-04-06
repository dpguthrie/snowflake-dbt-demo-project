with loans as (

    select * from {{ ref('customer_loans') }}

),

aggregations as (

    select
        callymd,
        sum(cre1_loans) as total_cre1_loans
    from loans
    group by 1

),

change as (

    select
        *,
        lag(total_cre1_loans, 4) over (order by callymd) as previous_year_cre1_loans,
        div0(
            total_cre1_loans,
            lag(total_cre1_loans, 4) over (order by callymd)
        ) - 1 as pct_change
    from aggregations

)

select
    *,
    percent_rank() over (order by pct_change) as pct_rank
from change
where total_cre1_loans > 0
    and previous_year_cre1_loans > 0
order by callymd