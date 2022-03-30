{% macro omit_soft_deletions(table, columns) %}

    select {{ ', '.join(columns) }}
    from {{ table }}
    where not is_deleted

{% endmacro %}


{# Example Usage

-- fct_orders.sql
with orders as (
    {{ omit_soft_deletions(
        source('tpch', 'orders'),
        [
            'order_key',
            'customer_key',
            'status_code',
            'total_price',
            'order_date',
            'priority_code',
            'clerk_name',
            'ship_priority',
            'comment'
        ]
    )}}
)

select * from orders

#}