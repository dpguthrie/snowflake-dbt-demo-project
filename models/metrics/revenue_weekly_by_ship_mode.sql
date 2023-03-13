select
    *
from {{ metrics.calculate(
    metric('total_revenue'),
    grain='week',
    dimensions=['ship_mode']
) }}