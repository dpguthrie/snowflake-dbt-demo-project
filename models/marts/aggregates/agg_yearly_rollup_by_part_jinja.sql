/* Create a pivot table with dynamic columns based on the parts that are in the system */

{%- call statement('result', fetch_result=True) -%}

    {# this pulls the unique part names from the dim_part table #}
    select name from {{ ref('dim_parts') }} group by 1 

{%- endcall %}

{# Only fetch the first 10 since there are so many! #}
{% set part_names = load_result('result').table.columns[0].values()[0:10] %}

with fct_order_items as (
    select * from {{ ref('fct_order_items') }}
),

dim_parts as (
    select * from {{ ref('dim_parts') }}
)

select
    date_part('year', order_date) as order_year,

    {# Loop over part_names array from above, and sum based on whether the record matches the part name #}
    {%- for part_name in part_names -%}
        sum(case when dim_parts.name = '{{part_name}}' then gross_item_sales_amount end) as "{{part_name}}_amount"
        {%- if not loop.last -%},{% endif %}
    {% endfor %}

from
    fct_order_items
    inner join dim_parts
        on fct_order_items.part_key = dim_parts.part_key 

group by 1
