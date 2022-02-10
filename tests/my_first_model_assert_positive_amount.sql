{{
    config(
        enabled=true,
        severity='error'
    )
}}

/*
The assumption is that my_first_model should contain zero rows with
an amount < 0

So, our query should look to return any rows that disprove our assumption
*/
with model_data as ( select * from {{ ref('my_first_model') }} )

select *
from   model_data
where  amount < 0