{% snapshot customer_snapshot %}

{{
  config(
    target_database='analytics',
    target_schema='snapshots',
    unique_key='c_custkey',
    strategy='timestamp',
    updated_at='_updated_at',
    transient=False
  )
}}

select * from {{ source('tpch_snapshot', 'customer_snapshot_src') }}

{% endsnapshot %}
