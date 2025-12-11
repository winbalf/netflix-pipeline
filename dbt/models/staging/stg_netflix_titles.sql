{{
    config(
        materialized='view',
        schema='staging'
    )
}}

with source as (
    select * from {{ source('raw', 'netflix_titles') }}
),

renamed as (
    select
        show_id,
        type,
        title,
        director,
        "cast",
        country,
        date_added,
        release_year,
        rating,
        duration,
        listed_in as genres,
        description,
        _load_timestamp
    from source
)

select * from renamed


