{% snapshot tpch_customer_snapshot %}

{{ config(
    target_database='doug_demo_v2',
    target_schema='snapshots',
    unique_key='c_custkey',
    strategy='timestamp',
    updated_at='_etl_updated_timestamp',
)}}

select * from {{ source('tpch', 'customer') }}

{% endsnapshot %}