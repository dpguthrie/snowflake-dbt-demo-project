select
    *
from {{ metrics.calculate(
    [
        metric('total_revenue'),
        metric('total_expenses'),
        metric('total_customers'),
        metric('total_profit'),
        metric('average_revenue_per_customer'),
    ],
    grain='week',
    dimensions=['ship_mode', 'return_flag']
) }}
union all
select
    *
from {{ metrics.calculate(
    [
        metric('total_revenue'),
        metric('total_expenses'),
        metric('total_customers'),
        metric('total_profit'),
        metric('average_revenue_per_customer'),
    ],
    grain='month',
    dimensions=['ship_mode', 'return_flag']
) }}