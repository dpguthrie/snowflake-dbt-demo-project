{% set base_ref = ref('base_fdic__lending_unioned') %}

with base as (
    select * from {{ base_ref }}
),

pivoted as (
    select
        cert,
        callymd,
        {{ dbt_utils.pivot(
            'variable',
            dbt_utils.get_column_values(base_ref, 'variable'),
            then_value='value',
        ) }}
    from base
    group by 1, 2
)

select
    cert,
    callymd,
{% for col, alias in var('lending_cols_map').items() -%}
    {{ col }} as {{ alias }},
{% endfor %}
    
    -- Calculated columns
    LNRECNFM + LNRECNOT as cre1_loans,
    LNREMULT + LNRENROW + LNRENROT as cre2_loans,
    cre1_loans + cre2_loans as total_cre_loans
from pivoted