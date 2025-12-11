{{
    config(
        materialized='view',
        schema='staging'
    )
}}

with source as (
    select * from {{ source('raw', 'netflix_ratings') }}
),

renamed as (
    select
        rating_id,
        user_id,
        title_id,
        rating,
        rating_date,
        review_text,
        _load_timestamp
    from source
)

select * from renamed


