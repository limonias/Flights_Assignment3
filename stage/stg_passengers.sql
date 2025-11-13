CREATE OR REPLACE TABLE flight_to_2026.stg_passengers AS (
  SELECT
    FARM_FINGERPRINT(UPPER(TRIM(CAST(Booking_ID AS STRING)))) AS booking_id, 
    FARM_FINGERPRINT(UPPER(TRIM(CAST(Flight_ID AS STRING)))) AS flight_id,
    FARM_FINGERPRINT(TRIM(CAST(Passenger_ID AS STRING))) AS passenger_id,
    SAFE_CAST(Ticket_Price AS NUMERIC) AS ticket_price,
    Luggage_Weight_KG AS luggage_weight_kg, CURRENT_TIMESTAMP() AS load_timestamp
  FROM `flight_to_2026.raw_passengers`
  WHERE Booking_ID IS NOT NULL
  QUALIFY ROW_NUMBER() OVER(PARTITION BY UPPER(TRIM(CAST(Booking_ID AS STRING))) ORDER BY Flight_ID) = 1
);