
{{ config(materialized='incremental') }}

{% set incremental_flag = 1 %}
{% set incremental_col = 'CREATED_AT' %}

SELECT * FROM {{ source('staging', 'listings') }}

{% if incremental_flag == 1 %}
    {% if is_incremental() %}
        WHERE {{ incremental_col }} > (
            SELECT COALESCE(MAX({{ incremental_col }}), '1900-01-01'::TIMESTAMP)
            FROM {{ this }}
        )
    {% endif %}
{% endif %}
