select *
from {{ metrics.metric(
    metric_name='order_amount_over_time',
    grain='month',
    dimensions=['priority_code'],
    secondary_calculations=[
        metrics.period_over_period(comparison_strategy='ratio', interval=1, alias='pct_chg_monthly'),
        metrics.period_over_period(comparison_strategy='ratio', interval=3, alias='pct_chg_quarterly'),
        metrics.period_over_period(comparison_strategy='ratio', interval=12, alias='pct_chg_annually'),
    ]
)}}
