{{ config(
    materialized='incremental',
    unique_key='location_id',
    incremental_strategy='merge'
) }}

WITH source_data AS (
    SELECT * FROM {{ ref('clean_restaurant_location') }}
),
scd2_updates AS (
    SELECT 
        location_id,
        city,
        state,
        state_code,
        is_union_territory,
        zip_code,
        active_flag,
        created_ts AS eff_start_dt,
        NULL AS eff_end_dt,
        TRUE AS current_flag,
        SHA1(CONCAT(city, state, state_code, zip_code)) AS restaurant_location_hk
    FROM source_data
)

SELECT * FROM scd2_updates
