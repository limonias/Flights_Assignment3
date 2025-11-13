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
