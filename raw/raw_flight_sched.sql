CREATE OR REPLACE TABLE flight_to_2026.raw_flight_schedule (
    Flight_ID STRING,
    Airline_Code STRING,
    Origin_Airport_Code STRING,
    Destination_Airport_Code STRING,
    Scheduled_Departure_Time TIMESTAMP,
    Actual_Departure_Time TIMESTAMP, 
    Gate_ID STRING,
    Status STRING,
    Load_TimeStamp TIMESTAMP,
); 