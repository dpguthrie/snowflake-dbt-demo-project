{% set sources = ['dbtc', 'yahooquery'] %}

with

{% for source in sources %}

{{ source }}_source as (
    select
        id,
        original_timestamp,
        received_at,
        timestamp,
        anonymous_id,
        context_ip,
        context_user_agent,
        link,
        context_library_version,
        event,
        event_text,
        uuid_ts,
        context_page_title,
        context_page_url,
        sent_at,
        context_library_name,
        context_locale,
        context_page_path,
        context_page_referrer,
        '{{ source }}' as src

    from {{ ref('stg_' ~ source ~ '__link_clicked') }}
),

{% endfor %}

unioned_sources as (
    {% for source in sources %}
        select * from {{ source }}_source
        {% if not loop.last %}union all{% endif %}
    {% endfor %}
)

select * from unioned_sources
