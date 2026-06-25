WITH silver AS (
    SELECT *
    FROM {{ ref('stg_gps') }}
    WHERE is_valid = TRUE
)

SELECT
    player_id,
    session_date,
    session_type,
    distance_m,
    top_speed_kmh,
    accel_efforts,
    decel_efforts,
    high_intensity_distance_m,
    ROUND(high_intensity_distance_m / NULLIF(distance_m, 0) * 100, 1) AS high_intensity_pct,
    source_file,
    transformed_at
FROM silver