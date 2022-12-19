with source as (

    select * from {{ source('dbtc', 'pages') }}

),

renamed as (

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

        -- calculated
        {{ dbt_utils.get_url_host('url') }} as page_url_host,
        replace(
            {{ dbt_utils.get_url_host('referrer') }},
            'www.',
            ''
        ) as referrer_host,
        {{ dbt_utils.get_url_parameter('url', 'gclid') }} as gclid,
        case
            when lower(context_user_agent) like '%android%' then 'Android'
            else replace(
                {{ dbt.split_part(dbt.split_part('context_user_agent', "'('", 2), "' '", 1) }},
                ';', '')
        end as device,
        case
            when device = 'iPhone' then 'iPhone'
            when device = 'Android' then 'Android'
            when device in ('iPad', 'iPod') then 'Tablet'
            when device in ('Windows', 'Macintosh', 'X11') then 'Desktop'
            else 'Uncategorized'
        end as device_category

    from source

)

select * from renamed
