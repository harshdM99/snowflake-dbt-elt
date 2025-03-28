{{ config(
    materialized='incremental',
    unique_key='location_id',
    on_schema_change='merge'
) }}

WITH base AS (
    SELECT *
    FROM {{ ref('stg_location') }}
),
transformed AS (
    SELECT
        location_id,
        city,
        CASE WHEN state = 'Delhi' THEN 'New Delhi' ELSE state END AS state,
        CASE 
            WHEN state = 'Delhi' THEN 'DL'
            WHEN state = 'Maharashtra' THEN 'MH'
            ELSE NULL
        END AS state_code,
        CASE WHEN state IN ('Delhi', 'Chandigarh') THEN TRUE ELSE FALSE END AS is_union_territory,
        zip_code,
        active_flag,
        created_ts,
        modified_ts,
        _stg_file_name,
        _stg_file_load_ts,
        _stg_file_md5,
        _copy_data_ts
    FROM base
)

SELECT * FROM transformed
