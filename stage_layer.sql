
CREATE OR REPLACE TABLE `flight_to_2026.stg_airlines` AS (
  SELECT 
    UPPER(TRIM(CAST(Airline_Code AS STRING))) AS airline_code, 
    TRIM(Airline_Name) AS airline_name, TRIM(Country) AS country, 
    SAFE_CAST(Is_Low_Cost_Carrier_Str AS BOOL) AS is_low_cost_carrier,
    CURRENT_TIMESTAMP() AS load_timestamp
  FROM `flight_to_2026.raw_airline`
  WHERE Airline_Code IS NOT NULL
  QUALIFY ROW_NUMBER() OVER(PARTITION BY UPPER(TRIM(CAST(Airline_Code AS STRING))) ORDER BY Airline_Code) = 1
);


CREATE OR REPLACE TABLE flight_to_2026.stg_flight_schedule AS (
  SELECT 
    FARM_FINGERPRINT(UPPER(TRIM(CAST(Flight_ID AS STRING)))) AS flight_id, 
    UPPER(TRIM(CAST(Airline_Code AS STRING))) AS airline_code,
    UPPER(TRIM(CAST(Origin_Airport_Code AS STRING))) AS origin_airport_code, 
    UPPER(TRIM(CAST(Destination_Airport_Code AS STRING))) AS destination_airport_code,
    SAFE.PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', Scheduled_Departure_Time) AS scheduled_departure_time,
    SAFE.PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', Actual_Departure_Time) AS actual_departure_time,
    FARM_FINGERPRINT(NULLIF(TRIM(CAST(Gate_ID AS STRING)), '')) AS gate_id, 
    TRIM(Status) AS status, 
    CURRENT_TIMESTAMP() AS load_timestamp
  FROM `flight_to_2026.raw_flight_schedule`
  WHERE Flight_ID IS NOT NULL
  QUALIFY ROW_NUMBER() OVER(PARTITION BY UPPER(TRIM(CAST(Flight_ID AS STRING))) ORDER BY Scheduled_Departure_Time) = 1
);


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
