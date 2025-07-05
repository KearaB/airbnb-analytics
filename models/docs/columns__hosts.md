## ##########################################################
## Identifiers
## ##########################################################
#-------------------------------------------------
{% docs columns__hosts__host_uuid %}
Unique identiifer for each host.
{% enddocs %}
#-------------------------------------------------


## ##########################################################
## Time Attributes
## ##########################################################
#-------------------------------------------------
{% docs columns__hosts__created_at %}
The earliest known date the host joined the platform.
{% enddocs %}
#-------------------------------------------------


## ##########################################################
## Descriptive Attributes
## ##########################################################
#-------------------------------------------------
{% docs columns__hosts__name %}
The display name of the host.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__location %}
Raw location string provided by the host (e.g., "Berlin, Germany").
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__country %}
Extracted country from the host's location.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__state %}
Extracted state or region from the host's location, if available.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__city %}
Extracted city from the host's location, if available.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__neighbourhood %}
Neighbourhood description provided by the host.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__about %}
Freeform “about” section written by the host.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__host_category %}
Categorization of the host based on the number of listings they manage.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__verification_category %}
Categorization based on types of identity verifications completed.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__url %}
Link to the host's public Airbnb profile.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__picture_url %}
URL to the host's profile picture.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__thumbnail_url %}
URL to a smaller thumbnail version of the host's profile picture.
{% enddocs %}
#-------------------------------------------------


## ##########################################################
## Quantitative Attributes
## ##########################################################
#-------------------------------------------------
{% docs columns__hosts__total_listings_count %}
Number of unique listings associated with the host.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__total_verifications_count %}
Number of verification methods completed by the host.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__response_time %}
Typical time taken by the host to respond to messages.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__response_rate %}
Percentage of guest inquiries the host responds to.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__acceptance_rate %}
Percentage of booking requests the host accepts.
{% enddocs %}
#-------------------------------------------------


## ##########################################################
## Indicators
## ##########################################################
#-------------------------------------------------
{% docs columns__hosts__is_verified %}
Indicates whether the host's identity has been verified.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__is_superhost %}
Indicates whether the host has Superhost status.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__has_profile_pic %}
Indicates whether the host has uploaded a profile picture.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__has_email %}
Indicates whether the host has a verified email address.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__has_phone %}
Indicates whether the host has a verified phone number.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__has_work_email %}
Indicates whether the host has a verified work email.
{% enddocs %}
#-------------------------------------------------
{% docs columns__hosts__has_photographer %}
Indicates whether the host has used Airbnb's professional photography service.
{% enddocs %}
#-------------------------------------------------
