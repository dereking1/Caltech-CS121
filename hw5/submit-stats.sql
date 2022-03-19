-- [Problem 1]
DELIMITER !

-- Given a submission id, return integer value of minimum 
-- time interval between submissions if 
-- there are at least 2 filesets, else return NULL.
CREATE FUNCTION min_submit_interval (id INT) RETURNS INT DETERMINISTIC
BEGIN

DECLARE min_interval INT DEFAULT POWER(2, 31) - 1;
DECLARE done INT DEFAULT 0;
DECLARE last_time INT DEFAULT 0;
DECLARE cur_time INT DEFAULT 0;
DECLARE sub_count INT DEFAULT 0; 

DECLARE cur CURSOR FOR
    SELECT UNIX_TIMESTAMP(sub_date) AS time_stamp
    FROM fileset WHERE sub_id = id 
    ORDER BY time_stamp ASC;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
    SET done = 1;

OPEN cur;
    WHILE NOT done DO
        FETCH cur INTO cur_time;
        IF NOT done THEN 
            SET sub_count = sub_count + 1;
            IF (cur_time - last_time) < min_interval THEN
                SET min_interval = cur_time - last_time;
            END IF;
            SET last_time = cur_time;
        END IF;
    END WHILE;
CLOSE cur;
IF sub_count < 2 THEN RETURN NULL;
ELSE RETURN min_interval;
END IF;
END !
DELIMITER ;

-- [Problem 2]
DELIMITER !

-- Given a submission id, return integer value of maximum
-- time interval between submissions if 
-- there are at least 2 filesets, else return NULL.
CREATE FUNCTION max_submit_interval (id INT) RETURNS INT DETERMINISTIC
BEGIN

DECLARE max_interval INT DEFAULT 0;
DECLARE done INT DEFAULT 0;
DECLARE last_time INT DEFAULT 0;
DECLARE cur_time INT DEFAULT 0;
DECLARE sub_count INT DEFAULT 0; 

DECLARE cur CURSOR FOR
    SELECT UNIX_TIMESTAMP(sub_date) AS time_stamp
    FROM fileset WHERE sub_id = id 
    ORDER BY time_stamp ASC;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
    SET done = 1;

OPEN cur;
    WHILE NOT done DO
        FETCH cur INTO cur_time;
        IF NOT done THEN 
            SET sub_count = sub_count + 1;
            IF sub_count > 1 AND (cur_time - last_time) > max_interval THEN
                SET max_interval = cur_time - last_time;
            END IF;
            SET last_time = cur_time;
        END IF;
    END WHILE;
CLOSE cur;
IF sub_count < 2 THEN RETURN NULL;
ELSE RETURN max_interval;
END IF;
END !
DELIMITER ;

-- [Problem 3]
DELIMITER !

-- Given a submission id, return double value for average interval
-- between submission if there are at least 2 filesets,
-- else return NULL.
CREATE FUNCTION avg_submit_interval (id INT) RETURNS DOUBLE DETERMINISTIC
BEGIN

DECLARE avg_interval DOUBLE;

SELECT (MAX(UNIX_TIMESTAMP(sub_date)) - MIN(UNIX_TIMESTAMP(sub_date)))
    /(COUNT(*) - 1) 
    INTO avg_interval FROM fileset
    WHERE sub_id = id;

RETURN avg_interval;
END !
DELIMITER ;

-- [Problem 4]
CREATE INDEX sub_idx ON fileset (sub_id, sub_date);
