with source as (

    select * from {{ source('yahooquery', 'pages') }}

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
        context_user_agent

    from source

)

select * from renamed
