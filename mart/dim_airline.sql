CREATE OR REPLACE TABLE flight_to_2026.dim_airline AS
SELECT
    airline_code AS airline_key,
    airline_name,
    country,
    is_low_cost_carrier,
    load_timestamp
FROM flight_to_2026.stg_airlines;
