with orders as (

    select * from {{ ref('fct_orders') }}
),

orders_items as (

    select * from {{ ref('fct_order_items' )}}
)

select
    orders.order_key,
    orders.order_date,
    orders.customer_key,
    orders_items.order_item_key,
    orders_items.part_key,
    orders_items.supplier_key
from orders
left join orders_items on orders.order_key = orders_items.order_key
