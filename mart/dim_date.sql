CREATE OR REPLACE TABLE flight_to_2026.dim_date AS
WITH dates AS (
  SELECT 
    day AS date_key,
    EXTRACT(YEAR FROM day) AS year,
    EXTRACT(MONTH FROM day) AS month,
    EXTRACT(DAY FROM day) AS day_of_month,
    EXTRACT(DAYOFWEEK FROM day) AS day_of_week,
    FORMAT_DATE('%A', day) AS weekday_name
  FROM UNNEST(GENERATE_DATE_ARRAY('2024-01-01','2026-12-31')) AS day
)
SELECT * FROM dates;
