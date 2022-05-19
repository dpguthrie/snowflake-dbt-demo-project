select
    1 as order_key,
    1 as customer_key,
    'A' as status_code,
    5 as total_price,
    '2021-02-01' as order_date,
    'P0' as priority_code,
    'a' as clerk_name,
    1 as ship_priority,
    'hello' as comment
union all
select
    2 as order_key,
    2 as customer_key,
    'A' as status_code,
    5 as total_price,
    '2021-02-01' as order_date,
    'P0' as priority_code,
    'a' as clerk_name,
    1 as ship_priority,
    'hello' as comment
