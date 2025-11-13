
CREATE OR REPLACE TABLE flight_to_2026.raw_flight_schedule (
    Flight_ID INTEGER,
    Airline_Code STRING,
    Origin_Airport_Code STRING,
    Destination_Airport_Code STRING,
    Scheduled_Departure_Time TIMESTAMP,
    Actual_Departure_Time TIMESTAMP, 
    Gate_ID INTEGER,
    Status STRING,
    Load_TimeStamp TIMESTAMP,
); 
CREATE OR REPLACE TABLE flight_to_2026.raw_passengers (
    Booking_ID STRING,
    Flight_ID STRING,
    Passenger_ID STRING,
    Ticket_Price FLOAT, 
    Luggage_Weight_KG FLOAT
); 

CREATE OR REPLACE TABLE flight_to_2026.raw_airline (
    Airline_Code STRING,
    Airline_Name STRING,
    Country STRING,
    Is_Low_Cost_Carrier_Str BOOLEAN 
);