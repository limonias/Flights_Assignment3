CREATE OR REPLACE TABLE flight_to_2026.dim_flight AS
SELECT
    flight_id AS flight_key,
    airline_code,  
    origin_airport_code,
    destination_airport_code,
    scheduled_departure_time,
    actual_departure_time,
    gate_id,
    status,
    load_timestamp
FROM flight_to_2026.stg_flight_sched;
