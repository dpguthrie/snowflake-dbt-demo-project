
with source as (

    select * from {{ source('yahooquery', 'tracks') }}

),

renamed as (

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
        context_library_name

    from source

)

select * from renamed
