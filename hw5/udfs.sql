-- [Problem 1a]
-- Given: Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Given a date value, returns 1 if it is a weekend, 0 if weekday
CREATE FUNCTION is_weekend (d DATE) RETURNS TINYINT DETERMINISTIC
BEGIN

-- DAYOFWEEK returns 7 for Saturday, 1 for Sunday
IF DAYOFWEEK(d) = 7 OR DAYOFWEEK(d) = 1
   THEN RETURN 1;
ELSE RETURN 0;
END IF;
END !

-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 1b]
-- Set the "end of statement" character to ! so we don't confuse MySQL
DELIMITER !

-- Given a date value, returns the name of the holiday if it's a holiday
-- or NULL if it's not a holiday
CREATE FUNCTION is_holiday(d DATE) RETURNS VARCHAR(30) DETERMINISTIC
BEGIN
  
-- TODO
DECLARE DAY INT;
DECLARE MONTH INT;
DECLARE WEEKDAY INT;
SELECT EXTRACT(DAY FROM d) INTO DAY;
SELECT EXTRACT(MONTH FROM d) INTO MONTH;
SELECT DAYOFWEEK(d) INTO WEEKDAY;
IF MONTH = 1 AND DAY = 1
    THEN RETURN 'New Year\'s Day';
ELSEIF MONTH = 5 AND DAY > 24 AND WEEKDAY = 2
    THEN RETURN 'Memorial Day';
ELSEIF MONTH = 8 AND DAY = 26
    THEN RETURN 'National Dog Day';
ELSEIF MONTH = 9 AND DAY < 7 AND WEEKDAY = 2
    THEN RETURN 'Labor Day';
ELSEIF MONTH = 11 AND WEEKDAY = 5 AND DAY BETWEEN 22 AND 28
    THEN RETURN 'Thanksgiving';
ELSE RETURN NULL;
END IF;
END !

-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 2a]
SELECT is_holiday(DATE(sub_date)) AS holiday, COUNT(*) AS num_submissions FROM
    fileset GROUP BY holiday;

-- [Problem 2b]
SELECT
    CASE
        WHEN is_weekend(DATE(sub_date)) = 1 THEN 'weekend'
        WHEN is_weekend(DATE(sub_date)) = 0 THEN 'weekday'
    END
    AS day_type,
    COUNT(*) AS num_submissions
    FROM fileset GROUP BY day_type;
