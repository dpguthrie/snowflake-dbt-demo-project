{{
    config(
        materialized='incremental',
        unique_key=['cert', 'callymd'],
    )
}}

{% set tables = ['lending_0', 'lending_1', 'lending_2'] %}

with unioned as (
    {% for table in tables %}

        select * from {{ source('fdic', table) }}
        {% if is_incremental() %}
        where callymd > (select max(callymd) from {{ this }})
        {% endif %}

        {% if not loop.last %}
        union all
        {% endif %}
        
    {% endfor %}
),

renamed as (
    select
        cert,
        callymd,
        variable,
        zeroifnull(value) as value
    from unioned
)

select *
from renamed
