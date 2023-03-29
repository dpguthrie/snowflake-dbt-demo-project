{% macro dont_do_this() %}

{% set sql %}

select * from {{ ref('dim_customers') }}
limit 10

{% endset %}

{% set results = run_query(sql).rows %}

{% for result in results %}

    {{ log(result, info=True) }}

{% endfor %}

{% endmacro %}