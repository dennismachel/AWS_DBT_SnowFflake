{{ config(materialized='incremental') }}

SELECT * FROM {{ source('staging', 'hosts') }}

{% if is_incremental() %}
WHERE HOST_ID > (
    SELECT COALESCE(MAX(HOST_ID), -1)
    FROM {{ this }}
)
{% endif %}
