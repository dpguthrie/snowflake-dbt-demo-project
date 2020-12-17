{{
    config(
        enabled=true,
        severity='error',
        tags = ['finance']
    )
}}


{{ test_all_values_gte_zero('stg_tpch_orders', 'total_price') }}