with source_table as
(
    select *
    from {{ source('airbnb_source', 'neighbourhoods') }}
),

transformed as
(
    select
        nullif(trim(neighbourhood_group),'') as neighbourhood_group,
        nullif(trim(neighbourhood),'') as neighbourhood,
        nullif(trim(city_name),'') as city_name,
        nullif(trim(id),'') as id
    from
        source_table
)
select
    *
from
    transformed