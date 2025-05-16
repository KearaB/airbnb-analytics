with source_table as 
(
    select * 
    from {{ source('airbnb_source', 'reviews') }}
),

transformed as 
(
    select
        listing_id,
        id,
        nullif(trim(date),'') as date,
        reviewer_id,
        nullif(trim(reviewer_name),'') as reviewer_name,
        nullif(trim(comments),'') as comments,
        nullif(trim(city_name),'') as city_name
    from 
        source_table
)
select 
    * 
from 
    transformed