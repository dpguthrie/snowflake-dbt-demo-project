with model_data as ( select * from {{ ref('my_first_model') }} )

select *
from   model_data
where  amount < 0