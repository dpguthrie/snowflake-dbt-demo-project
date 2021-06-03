
with order_items as (select * from {{ ref('fct_order_items') }} )

-- good query
select part_key, sum(quantity) as quantity from order_items group by 1

-- bad query
-- select part_key, count(quantity) as quantity from order_items group by 1
