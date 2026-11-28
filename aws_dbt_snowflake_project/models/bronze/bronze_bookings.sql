{{ config(materialized='incremental') }}

{% set incremental_flag = 1 %}
{% set incremental_col = 'Created_At' %}

SELECT * FROM {{ source('staging', 'bookings') }}

{% if incremental_flag == 1 %}
    {% if is_incremental() %}
        WHERE {{ incremental_col }} > (
            SELECT COALESCE(MAX({{ incremental_col }}), '1900-01-01') FROM {{ this }}
        )
    {% endif %}
{% endif %}