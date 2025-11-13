CREATE OR REPLACE TABLE `flight_to_2026.stg_airlines` AS (
  SELECT UPPER(TRIM(Airline_Code)) AS airline_code, TRIM(Airline_Name) AS airline_name,
        TRIM(Country) AS country, SAFE_CAST(Is_Low_Cost_Carrier_Str AS BOOL) AS is_low_cost_carrier,
        CURRENT_TIMESTAMP() AS load_timestamp
  FROM `flight_to_2026.raw_airline`
  WHERE Airline_Code IS NOT NULL
  QUALIFY ROW_NUMBER() OVER(PARTITION BY UPPER(TRIM(Airline_Code)) ORDER BY Airline_Code) = 1
);


CREATE OR REPLACE TABLE flight_to_2026.stg_flights AS (
  SELECT UPPER(TRIM(Flight_ID)) AS flight_id, UPPER(TRIM(Airline_Code)) AS airline_code,
        UPPER(TRIM(Origin_Airport_Code)) AS origin_airport_code, UPPER(TRIM(Destination_Airport_Code)) AS destination_airport_code,
        SAFE.PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', Scheduled_Departure_Time) AS scheduled_departure_time,
        SAFE.PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', Actual_Departure_Time) AS actual_departure_time,
        NULLIF(TRIM(Gate_ID), '') AS gate_id, TRIM(Status) AS status, CURRENT_TIMESTAMP() AS load_timestamp
  FROM `flight_to_2026.flights`
  WHERE Flight_ID IS NOT NULL
  QUALIFY ROW_NUMBER() OVER(PARTITION BY UPPER(TRIM(Flight_ID)) ORDER BY Scheduled_Departure_Time) = 1
);


CREATE OR REPLACE TABLE flight_to_2026.stg_passengers AS (
  SELECT UPPER(TRIM(Booking_ID)) AS booking_id, UPPER(TRIM(Flight_ID)) AS flight_id,
        TRIM(Passenger_ID) AS passenger_id, SAFE_CAST(Ticket_Price AS NUMERIC) AS ticket_price,
        SAFE_CAST(NULLIF(TRIM(Luggage_Weight_KG), '') AS NUMERIC) AS luggage_weight_kg,
        CURRENT_TIMESTAMP() AS load_timestamp
  FROM `flight_to_2026.passengers`
  WHERE Booking_ID IS NOT NULL
  QUALIFY ROW_NUMBER() OVER(PARTITION BY UPPER(TRIM(Booking_ID)) ORDER BY Flight_ID) = 1
