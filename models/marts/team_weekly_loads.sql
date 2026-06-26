WITH player_summary AS (
    SELECT *
    FROM {{ ref('player_session_summary') }}
)

SELECT
    DATE_TRUNC('week', session_date)        AS week_start,
    session_type,
    COUNT(DISTINCT player_id)               AS players_tracked,
    ROUND(AVG(distance_m), 0)               AS avg_distance_m,
    ROUND(MAX(distance_m), 0)               AS max_distance_m,
    ROUND(MIN(distance_m), 0)               AS min_distance_m,
    ROUND(AVG(top_speed_kmh), 1)            AS avg_top_speed_kmh,
    ROUND(MAX(top_speed_kmh), 1)            AS max_top_speed_kmh,
    ROUND(AVG(high_intensity_pct), 1)       AS avg_high_intensity_pct
FROM player_summary
GROUP BY 1, 2
ORDER BY 1, 2