{% set sources = ['dbtc', 'yahooquery'] %}

with

{% for source in sources %}

{{ source }}_source as (
    select
        anonymous_id,
        context_locale,
        context_page_referrer,
        url,
        uuid_ts,
        context_library_name,
        context_library_version,
        id,
        received_at,
        title,
        context_page_title,
        path,
        referrer,
        timestamp,
        original_timestamp,
        sent_at,
        context_ip,
        context_page_path,
        context_page_url,
        context_user_agent,
        page_url_host,
        referrer_host,
        gclid,
        device,
        device_category,
        '{{ source }}' as src

    from {{ ref('stg_' ~ source ~ '__pages') }}
    where url not like 'http://127.0.0.1:8000%'
        and url not like 'http://localhost:8000%'
),

{% endfor %}

unioned_sources as (
    {% for source in sources %}
        select * from {{ source }}_source
        {% if not loop.last %}union all{% endif %}
    {% endfor %}
)

select * from unioned_sources
