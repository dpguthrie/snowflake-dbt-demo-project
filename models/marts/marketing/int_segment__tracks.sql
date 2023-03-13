

{% set sources = ['dbtc', 'yahooquery'] -%}

with

{% for source in sources -%}

{{ source }}_source as (
    select
        event_text,
        context_library_version,
        context_page_referrer,
        context_page_url,
        event,
        context_ip,
        context_page_path,
        context_page_title,
        received_at,
        sent_at,
        timestamp,
        uuid_ts,
        context_locale,
        context_user_agent,
        id,
        original_timestamp,
        anonymous_id,
        context_library_name,
        '{{ source }}' as src

    from {{ ref('stg_' ~ source ~ '__tracks') }}
),

{% endfor -%}

unioned_sources as (
    {% for source in sources -%}
        select * from {{ source }}_source
        {% if not loop.last %}union all{% endif %}
    {% endfor -%}
)

select * from unioned_sources
