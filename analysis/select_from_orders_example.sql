

SELECT order_key, 
       order_date, 
       {{ standard_account_fields() }} 
FROM {{ ref('fct_orders') }}