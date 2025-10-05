-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Given Info : Date = 28/7/2024. Location = Humphrey Street.

-- info about crime scene
    SELECT *
    FROM crime_scene_reports
    WHERE month = 7 AND year = 2024
    AND street = 'Humphrey Street';
-- DESCRIPTION: Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. Interviews were conducted today with three witnesses who were present at the time – each of their interview transcripts mentions the bakery
-- FURTHER RESULT: Day = 28. id = 295.


-- Read the interviews
    SELECT name, transcript
    FROM interviews
    WHERE year = 2024 AND month = 7 AND day = 28;
-- FINDINGS: 1) Ruth = Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.
        --   2) Eugene = I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.
        --   3) Raymond = As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.


-- Explore Ruth interview
-- check bakery logs for the license plate of a car that drove away within 10:15am and 10:25am on 28/7/2024
    SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2024 AND month = 7
    AND day = 28 AND hour = 10
    AND activity = 'exit'
    AND minute BETWEEN 15 AND 25;
-- FINDINGS: | activity | license_plate |
-- +----------+---------------+
-- | exit     | 5P2BI95       |
-- | exit     | 94KL13X       |
-- | exit     | 6P58WS2       |
-- | exit     | 4328GD8       |
-- | exit     | G412CB7       |
-- | exit     | L93JTIZ       |
-- | exit     | 322W7JE       |
-- | exit     | 0NTHK55       |


-- explore Eugene interview
    -- I don't know the thief's name, but it was someone I recognized.
    -- Earlier this morning, before I arrived at Emma's bakery,
    -- I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.
-- check info of who withdrew on 28/7/2024 at leggett street
    SELECT account_number
    FROM atm_transactions
    WHERE year = 2024 AND month = 7
    AND atm_location = 'Leggett Street'
    AND day = 28 AND transaction_type = 'withdraw';

-- get a list of person_id with the account numbers
SELECT person_id
FROM bank_accounts
WHERE account_number IN (
    SELECT account_number
    FROM atm_transactions
    WHERE year = 2024 AND month = 7
    AND atm_location = 'Leggett Street'
    AND day = 28 AND transaction_type = 'withdraw'
);


-- explore Raymond interview
    -- As the thief was leaving the bakery,
    -- they called someone who talked to them for less than a minute.
    -- In the call, I heard the thief say that they were planning to
    -- take the earliest flight out of Fiftyville tomorrow.
    -- The thief then asked the person on the other end of the phone
    -- to purchase the flight ticket.

-- check phone_calls for a call between 10:15 and 10:25 on 28/7/2024 than was < 1 min
    SELECT caller, receiver
    FROM phone_calls
    WHERE year = 2024 AND month = 7
    and day = 28 AND duration < 60;

-- check the earliest flight leaving fiftyville tomorrow 29/7/2024
-- first check fiftyville airport id

SELECT destination_airport_id, id
FROM flights
WHERE year = 2024 AND month = 7
AND day = 29 AND origin_airport_id = (
    SELECT id FROM airports WHERE city = 'Fiftyville'
)
ORDER BY hour ASC, minute ASC
LIMIT 1;


-- City thief fled to = destination_id_airport
SELECT city
FROM airports
WHERE id = (
    SELECT destination_airport_id
    FROM flights
    WHERE year = 2024 AND month = 7
    AND day = 29 AND origin_airport_id = (
        SELECT id FROM airports WHERE city = 'Fiftyville'
)
ORDER BY hour ASC, minute ASC
LIMIT 1
);


-- get a flight id for the earliest flight from fiftyville to new york on 29/7/2024
    SELECT id
    FROM flights
    WHERE year = 2024 AND month = 7
    AND day = 29 AND origin_airport_id = (
        SELECT id FROM airports WHERE city = 'Fiftyville'
    )
    ORDER BY hour ASC, minute ASC
    LIMIT 1;

-- get passport numbers of passengers in the above flight id
SELECT passport_number
FROM passengers
WHERE flight_id = (
    SELECT id
    FROM flights
    WHERE year = 2024 AND month = 7
    AND day = 29 AND origin_airport_id = (
        SELECT id FROM airports WHERE city = 'Fiftyville'
    )
    ORDER BY hour ASC, minute ASC
    LIMIT 1
);





-- TRIAL 1
SELECT name
FROM people
WHERE license_plate IN (
    SELECT license_plate FROM bakery_security_logs WHERE year = 2024 AND month = 7 AND day = 28 AND hour = 10 AND minute BETWEEN 15 AND 25)
    AND phone_number IN (
        SELECT caller FROM phone_calls WHERE year = 2024 AND month = 7 AND day = 28 AND duration < 60);
-- --RESULT: |  name  |
        -- +--------+
        -- | Sofia  |
        -- | Diana  |
        -- | Kelsey |
        -- | Bruce  |
        -- +--------+

-- TRIAL 2
SELECT name
FROM people
WHERE license_plate IN (
    SELECT license_plate FROM bakery_security_logs WHERE year = 2024 AND month = 7 AND day = 28 AND hour = 10 AND minute BETWEEN 15 AND 25)
    AND phone_number IN (
        SELECT caller FROM phone_calls WHERE year = 2024 AND month = 7 AND day = 28 AND duration < 60)
    AND id IN (
        SELECT person_id
        FROM bank_accounts
        WHERE account_number IN (
            SELECT account_number
            FROM atm_transactions
            WHERE year = 2024 AND month = 7
            AND atm_location = 'Leggett Street'
            AND day = 28 AND transaction_type = 'withdraw'
        ))
    AND passport_number IN (
        SELECT passport_number
        FROM passengers
        WHERE flight_id = (
            SELECT id
            FROM flights
            WHERE year = 2024 AND month = 7
            AND day = 29 AND origin_airport_id = (
                SELECT id FROM airports WHERE city = 'Fiftyville'
            )
            ORDER BY hour ASC, minute ASC
            LIMIT 1
        )
    );
-- RESULT: | name  |
        -- | Bruce |

-- For Accomplice

SELECT name FROM people WHERE phone_number = (
    SELECT receiver FROM phone_calls
    WHERE caller = (
        SELECT phone_number FROM people WHERE name = 'Bruce'
    ) AND year = 2024 AND month = 7 AND day = 28 AND duration < 60
);
-- RESULT: | name  |
        -- | Robin |