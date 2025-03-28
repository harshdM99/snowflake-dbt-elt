{{ config(
    materialized='incremental',
    unique_key='locationid',
    on_schema_change='merge'
) }}

SELECT
    locationid::NUMBER AS location_id,
    city::STRING AS city,
    state::STRING AS state,
    zipcode::STRING AS zip_code,
    activeflag::STRING AS active_flag,
    TRY_TO_TIMESTAMP(createddate, 'YYYY-MM-DD HH24:MI:SS') AS created_ts,
    TRY_TO_TIMESTAMP(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS modified_ts,
    _stg_file_name,
    _stg_file_load_ts,
    _stg_file_md5,
    _copy_data_ts
FROM {{ source('swiggy_stage', 'location') }}
{% if is_incremental() %}
-- Only load new records after initial batch
WHERE _copy_data_ts > (SELECT MAX(_copy_data_ts) FROM {{ this }})
{% endif %}
