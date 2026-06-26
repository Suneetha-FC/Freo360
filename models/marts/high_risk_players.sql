WITH player_summary AS (
    SELECT *
    FROM {{ ref('player_session_summary') }}
),

training_loads AS (
    SELECT
        player_id,
        AVG(distance_m) AS avg_training_distance
    FROM player_summary
    WHERE session_type = 'TRAINING'
    GROUP BY player_id
),

match_loads AS (
    SELECT
        player_id,
        AVG(distance_m) AS avg_match_distance
    FROM player_summary
    WHERE session_type = 'MATCH'
    GROUP BY player_id
)

SELECT
    t.player_id,
    ROUND(t.avg_training_distance, 0)   AS avg_training_distance_m,
    ROUND(m.avg_match_distance, 0)      AS avg_match_distance_m,
    ROUND(m.avg_match_distance
        / NULLIF(t.avg_training_distance, 0), 2) AS match_to_training_ratio,
    CASE
        WHEN m.avg_match_distance
           / NULLIF(t.avg_training_distance, 0) > 1.3
        THEN 'HIGH RISK'
        WHEN m.avg_match_distance
           / NULLIF(t.avg_training_distance, 0) > 1.1
        THEN 'MONITOR'
        ELSE 'NORMAL'
    END                                 AS load_risk_flag
FROM training_loads  t
JOIN match_loads     m ON t.player_id = m.player_id
ORDER BY match_to_training_ratio DESC