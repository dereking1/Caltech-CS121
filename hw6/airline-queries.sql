-- [Problem 6a]
SELECT purchase_date, flight_date, last_name AS traveler_last_name, 
    first_name AS traveler_first_name
    FROM ticket NATURAL JOIN ticket_info NATURAL JOIN customer NATURAL JOIN
    (SELECT purchse_date FROM purchase WHERE cust_id = 54321) AS p 
    ORDER BY purchase_date DESC, flight_date ASC, last_name ASC, first_name ASC;

-- [Problem 6b]
WITH revenues AS (
    SELECT aircraft_type, SUM(price) AS revenue
    FROM flight NATURAL JOIN ticket NATURAL JOIN ticket_info
    WHERE TIMESTAMP(flight_date, flight_time)
        BETWEEN NOW() - INTERVAL 2 WEEK AND NOW()
    GROUP BY aircraft_type)
SELECT aircraft_code, IFNULL(revenue, 0) AS revenue
    FROM aircraft NATURAL LEFT JOIN revenues;

-- [Problem 6c]
SELECT cust_id, first_name, last_name, email
    FROM traveler NATURAL JOIN ticket NATURAL JOIN ticket_info NATURAL JOIN customer
    NATURAL JOIN flight
    WHERE international = TRUE AND (
        ISNULL(passport_number) OR ISNULL(country) OR ISNULL(emergency_name) OR
        ISNULL(emergency_phone));
