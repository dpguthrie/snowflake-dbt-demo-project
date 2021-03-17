{% snapshot customer_snapshot %}

{# 
 Creates a snapshot table tracking slowly changing dimensions raw data in the customer_snapshot table
 NOTES: 
   - This example uses an _updated_at timestamp to track changes. We can also do this by referencing unique column combinations
   - First run creates a transient table by default, but can be overriden with the transient=false configuration
   - Subsequent runs perform a merge on that transient table
   - This will perform change tracking for you - notice that we write this to a different schema (in target_schema) than the rest of our data to restrict permissions 
#} 

{{
    config(
      target_database='analytics',
      target_schema='snapshots', 
      unique_key='c_custkey',
      strategy='timestamp',
      updated_at='_updated_at',
      transient=false
    )
}}

select * from {{ source('tpch_snapshot', 'customer_snapshot_src') }}

{% endsnapshot %}