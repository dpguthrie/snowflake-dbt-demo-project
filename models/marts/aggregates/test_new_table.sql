/*  Manually driven approach to mapping part names for iteration - this is automated by the call statement below

  {% set part_names = ['goldenrod lavender spring chocolate lace',
                     'blush thistle blue yellow saddle',
                     'spring green yellow purple cornsilk',
                     'cornflower chocolate smoke green pink',
                     'forest brown coral puff cream'] %} */

{%- call statement('result', fetch_result=True) -%}
 -- this pulls the unique part names from the dim_part table
 select name from {{ ref('dim_parts') }} group by 1 

{%- endcall %}

{% set part_names = load_result('result').table.columns[0].values()[0:10] %}               

with fct_order_items as ( select * from {{ ref('fct_order_items') }} ),

dim_parts as ( select * from {{ ref('dim_parts') }} )

select date_part('year', order_date) as order_year,
       
       {# loop over part_names array from above #}
       {%- for part_name in part_names -%}

         {# map the part name for individual sum by date #}
         sum(case when dp.name = '{{part_name}}' then gross_item_sales_amount end) as "{{part_name}}_amount"
         {%- if not loop.last -%}
         {# attach commas for all but the last line #}
         ,
         {%- endif -%}
        
       {%- endfor %}

from   fct_order_items foi
inner join dim_parts dp 
  on foi.part_key = dp.part_key 
group by 1
