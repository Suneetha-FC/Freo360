WITH source AS (
    SELECT *
    FROM {{ source('bronze', 'gps_raw') }}
),

transformed AS (
    SELECT
        player_id,
        TRY_TO_DATE(session_date)                    AS session_date,
        TRY_TO_DOUBLE(distance_m)                    AS distance_m,
        TRY_TO_DOUBLE(top_speed_kmh)                 AS top_speed_kmh,
        TRY_TO_NUMBER(accel_efforts)                 AS accel_efforts,
        TRY_TO_NUMBER(decel_efforts)                 AS decel_efforts,
        TRY_TO_DOUBLE(high_intensity_distance_m)     AS high_intensity_distance_m,
        UPPER(TRIM(session_type))                    AS session_type,
        CASE
            WHEN TRY_TO_DOUBLE(distance_m) IS NULL THEN FALSE
            WHEN TRY_TO_DATE(session_date)  IS NULL THEN FALSE
            ELSE TRUE
        END                                          AS is_valid,
        source_file,
        CURRENT_TIMESTAMP()                          AS transformed_at
    FROM source
)

SELECT * FROM transformed