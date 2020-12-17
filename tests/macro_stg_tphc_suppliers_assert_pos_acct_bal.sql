{{
    config(
        enabled=true,
        severity='warn',
        tags = ['finance']
    )
}}


{{ test_all_values_gte_zero('stg_tpch_suppliers', 'account_balance') }}