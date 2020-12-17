with fct_order_items as ( select * from {{ ref('fct_order_items') }} ),

dim_parts as ( select * from {{ ref('dim_parts') }} ),

merged as (
  select date_part('year', foi.order_date) as order_year,
         dp.name,
         foi.gross_item_sales_amount

  from   fct_order_items foi
  inner join dim_parts dp 
    on foi.part_key = dp.part_key 
)

select * 
from merged
  -- have to manually map strings in the pivot operation
  pivot(sum(gross_item_sales_amount) for name in ('goldenrod lavender spring chocolate lace', 'blush thistle blue yellow saddle') ) as p 
  order by order_year
