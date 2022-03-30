{% macro share_view(tier=0) %}

    -- Only run in production
    {% if target.name == 'prod' %}

        {% set sql %}
        -- Create a table with all data to be shared
        create or replace table share_db.private.{{ this.name }} as
            select * from {{ this }}
            where company_id in (
                select distinct company_id
                from {{ ref('company_shares') }}
            );
        
        grant select on share_db.private.{{ this.name }} to role transformer;

        -- Create a secure view which selects based on current account
        create or replace secure view share_db.public.{{ this.name }} as
            select a.*
            from share_db.private.{{ this.name }} as a
            inner join share_db.private.company_shares as b on (
                a.company_id = b.company_id
                and b.snowflake_account = current_account()
                and b.tier >= {{ tier }}
            );
        
        grant select on share_db.public.{{ this.name }} to share customer_share;
        {% endset %}

        {% set table = run_query(sql) %}

    {% endif %}

{% endmacro %}