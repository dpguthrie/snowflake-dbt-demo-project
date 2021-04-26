/* Create a pivot table with hard-coded columns based on a query of the parts that are in the system */

with fct_order_items as (
    select * from {{ ref('fct_order_items') }}
),

dim_parts as (
    select * from {{ ref('dim_parts') }}
),

merged as (
    select
        date_part('year', fct_order_items.order_date) as order_year,
        dim_parts.name,
        fct_order_items.gross_item_sales_amount
    from
        fct_order_items
        inner join dim_parts
            on fct_order_items.part_key = dim_parts.part_key 
)

select
    * 
from
    merged
    -- have to manually map strings in the pivot operation
    pivot(sum(gross_item_sales_amount) for name in (
        'goldenrod lavender spring chocolate lace',
        'blush thistle blue yellow saddle'
    )) as p 

order by order_year
