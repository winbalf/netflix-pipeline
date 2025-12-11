{{
    config(
        materialized='view',
        schema='staging'
    )
}}

with source as (
    select * from {{ source('raw', 'netflix_viewing_history') }}
),

renamed as (
    select
        viewing_id,
        user_id,
        title_id,
        watch_date,
        watch_duration_minutes,
        completion_percentage,
        device_type,
        _load_timestamp
    from source
)

select * from renamed


