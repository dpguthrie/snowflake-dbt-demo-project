{% macro share_view() %}

{#

Usage:

This would be used as a post-hook in the config block at the top of a model

Example:

{{ config(post_hook='{{ share_view() }}') }}

#}

    -- Only run in production
    {% if target.name == 'prod' %}

        {% set sql %}
        -- Create a table with all data to be shared
        create or replace table share_db.private.{{ this.name }} as
            select * from {{ this }};
        
        grant select on share_db.private.{{ this.name }} to role transformer;

        -- Create a secure view which selects based on current account
        create or replace secure view share_db.public.{{ this.name }} as
            select a.*
            from share_db.private.{{ this.name }} as a
            inner join share_db.private.company_shares as b on (
                a.customer_id = b.customer_id
                and b.snowflake_account = current_account()
            );
        
        grant select on share_db.public.{{ this.name }} to share customer_share;
        {% endset %}

        {% set table = run_query(sql) %}

    {% endif %}

{% endmacro %}