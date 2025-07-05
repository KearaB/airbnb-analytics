{{
  config(
    materialized='table',
    post_hook = set_column_descriptions(model.columns)
  )
}}

/**************************************************
Model References
**************************************************/
with listings as (

  select * from {{ ref('stg_airbnb__listings') }}
),

host_locations as (

  select * from {{ ref('seed_host_locations') }}
),

/**************************************************
Transformation
**************************************************/
agg as (

  select
    host_id                                         as host_uuid,
    min(host_since)                                 as created_at,
    any_value(host_name)                            as name,
    any_value(host_location)                        as location,
    any_value(host_neighbourhood)                   as neighbourhood,
    any_value(host_about)                           as about,

    -- Host size category
    case
      when count(distinct id) = 1                then 'solo_host'
      when count(distinct id) between 2  and 5   then 'small_host'
      when count(distinct id) between 6  and 20  then 'medium_host'
      when count(distinct id) between 21 and 100 then 'large_host'
      when count(distinct id) > 100              then 'enterprise_host'
      else                                            'unclassified'
    end                                             as host_category,

    any_value(host_verifications)                   as raw_verifications,

    any_value(host_url)                             as url,
    any_value(host_picture_url)                     as picture_url,
    any_value(host_thumbnail_url)                   as thumbnail_url,

    any_value(host_response_time)                   as response_time,
    any_value(host_response_rate)                   as response_rate,
    any_value(host_acceptance_rate)                 as acceptance_rate,
    count(distinct id)                              as total_listings_count,

    any_value(host_identity_verified = 't')         as is_verified,
    any_value(coalesce(host_is_superhost, false))   as is_superhost,
    any_value(host_has_profile_pic)                 as has_profile_pic

  from
    listings
  group by
    host_id
),

base as (

  select
    *,
    array(
      select distinct trim(lower(part))
      from unnest(
        split(
          regexp_replace(
            coalesce(raw_verifications, '[]'),
            r'[\[\]\' ]',                  -- remove [, ], ', blanks
            ''
          ),
          ','                              -- split on commas
        )
      ) part
      where part <> ''
    )                                               as verification_array
  from
    agg
),

transformed as (

  select
    b.*,
    array_length(b.verification_array)               as total_verifications_count,
    case array_length(b.verification_array)
      when 0 then 'unverified'
      when 1 then 'basic_verified'
      when 2 then 'multi_verified'
      when 3 then 'multi_verified'
      else      'fully_verified'
    end                                            as verification_category,
    hl.country,
    hl.state,
    hl.city,

    'email'        in unnest(b.verification_array)   as has_email,
    'phone'        in unnest(b.verification_array)   as has_phone,
    'work_email'   in unnest(b.verification_array)   as has_work_email,
    'photographer' in unnest(b.verification_array)   as has_photographer

  from
    base as b
  left join host_locations as hl
    on b.location = hl.lookup_value
),

/**************************************************
Final Output
**************************************************/
final as (

  select

    -- Identifiers --
    host_uuid,

    -- Time Attributes --
    created_at,

    -- Descriptive Attributes --
    name,
    location,
    country,
    state,
    city,
    neighbourhood,
    about,
    host_category,
    verification_category,
    url,
    picture_url,
    thumbnail_url,

    -- Quantitative Attributes --
    total_listings_count,
    total_verifications_count,
    response_time,
    response_rate,
    acceptance_rate,

    -- Indicators --
    is_verified,
    is_superhost,
    has_profile_pic,
    has_email,
    has_phone,
    has_work_email,
    has_photographer

  from
    transformed
)

select * from final
