CREATE TABLE IF NOT EXISTS `flight_to_2026.dim_airlines` (
  airline_sk STRING NOT NULL,
  airline_code STRING,
  airline_name STRING,
  country STRING,
  is_low_cost_carrier BOOL,
  valid_from TIMESTAMP NOT NULL,
  valid_to TIMESTAMP,
  is_current BOOL NOT NULL
);

CREATE OR REPLACE TABLE `flight_to_2026.stg_airlines_source` AS (
  SELECT 
    UPPER(TRIM(Airline_Code)) AS airline_code, 
    TRIM(Airline_Name) AS airline_name, 
    TRIM(Country) AS country, 
    SAFE_CAST(Is_Low_Cost_Carrier_Str AS BOOL) AS is_low_cost_carrier,
    CURRENT_TIMESTAMP() AS load_time
  FROM  `flight_to_2026.raw_airline`
  WHERE Airline_Code IS NOT NULL
    AND UPPER(TRIM(Airline_Code)) != 'AIRLINE_CODE' -- Filter header
  QUALIFY ROW_NUMBER() OVER(PARTITION BY UPPER(TRIM(Airline_Code)) ORDER BY Airline_Code ) = 1
);

MERGE `flight_to_2026.dim_airlines` T
USING `flight_to_2026.stg_airlines_source` S
  ON T.airline_code = S.airline_code AND T.is_current = TRUE
WHEN MATCHED 
  AND (
    T.airline_name != S.airline_name
    OR T.country != S.country
    OR T.is_low_cost_carrier != S.is_low_cost_carrier
  )
THEN
  UPDATE SET
    T.is_current = FALSE,
    T.valid_to = S.load_time;


INSERT INTO `flight_to_2026.dim_airlines` (
  airline_sk, airline_code, airline_name,
  country, is_low_cost_carrier,
  valid_from, valid_to, is_current
)
SELECT 
  CAST(FARM_FINGERPRINT(CONCAT(S.airline_code, CAST(S.load_time AS STRING))) AS STRING) AS airline_sk,
  S.airline_code, S.airline_name, S.country, S.is_low_cost_carrier, S.load_time AS valid_from,
  NULL AS valid_to, TRUE AS is_current
FROM `flight_to_2026.stg_airlines_source` S
LEFT JOIN `flight_to_2026.dim_airlines` T
  ON S.airline_code = T.airline_code AND T.is_current = TRUE
WHERE
  T.airline_code IS NULL 
  OR (
    T.airline_name != S.airline_name
    OR T.country != S.country
    OR T.is_low_cost_carrier != S.is_low_cost_carrier
  );
