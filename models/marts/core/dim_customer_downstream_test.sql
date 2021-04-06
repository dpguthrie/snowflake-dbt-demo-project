{{ block_on_tests([
    test_unique(model = source('tpch', 'customer') , column_name = 'c_custkey')
]) }}


select * from {{ source('tpch', 'customer') }}