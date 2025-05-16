with source_table as 
(
    select * 
    from {{ source('airbnb_source', 'calendars') }}
),

transformed as 
(
    select
        listing_id,
        nullif(trim(date),'') as date,
        nullif(trim(available),'') as available,
        nullif(trim(price),'') as price,
        nullif(trim(adjusted_price),'') as adjusted_price,
        minimum_nights,
        maximum_nights,
        nullif(trim(city_name),'') as city_name
    from 
        source_table
)
select 
    * 
from 
    transformed