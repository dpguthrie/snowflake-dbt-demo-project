{% snapshot tpch_supplier_snapshot %}

{{ config(
    target_database='doug_demo_v2',
    target_schema='snapshots',
    unique_key='s_suppkey',
    strategy='timestamp',
    updated_at='_etl_updated_timestamp',
)}}

select * from {{ source('tpch', 'supplier') }}

{% endsnapshot %}