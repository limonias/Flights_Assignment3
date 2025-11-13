CREATE OR REPLACE TABLE flight_to_2026.fact_flight_passengers AS
SELECT
    p.booking_id,
    p.passenger_id,
    
    f.flight_id      AS flight_key,
    f.airline_code   AS airline_key,
    DATE(f.scheduled_departure_time) AS flight_date_key,
    DATE(p.load_timestamp) AS booking_date_key,
    
    p.ticket_price,
    p.luggage_weight_kg,
    
    CASE WHEN f.actual_departure_time IS NULL THEN 1 ELSE 0 END AS is_cancelled,
    
    p.load_timestamp
FROM flight_to_2026.stg_passengers p
LEFT JOIN flight_to_2026.stg_flight_schedule f
    ON p.flight_id = f.flight_id;
