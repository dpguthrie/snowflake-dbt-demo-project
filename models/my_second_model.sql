select my_lucky_number*2 as doubled_lucky_number
from {{ ref('my_first_model') }}
