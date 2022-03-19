-- [Problem 1a]
SELECT SUM(perfectscore) AS perfect_score FROM assignment;

-- [Problem 1b]
SELECT sec_name, COUNT(*) AS num_students
    FROM section NATURAL JOIN student
    GROUP BY sec_name;

-- [Problem 1c]
CREATE VIEW score_totals AS
    SELECT username, SUM(score) AS total_score
    FROM submission WHERE graded = 1
    GROUP BY username;

-- [Problem 1d]
CREATE VIEW passing AS
    SELECT username, total_score
    FROM score_totals
    WHERE total_score >= 40;

-- [Problem 1e]
CREATE VIEW failing AS
    SELECT username, total_score
    FROM score_totals
    WHERE total_score < 40;

-- [Problem 1f]
SELECT DISTINCT username FROM
    passing NATURAL JOIN submission
    WHERE sub_id NOT IN
    (SELECT sub_id FROM fileset)
    AND asn_id IN
    (SELECT asn_id FROM assignment
    WHERE shortname LIKE 'lab%');
-- Query Result:
-- username:
-- 'harris'
-- 'ross'
-- 'miller'
-- 'turner'
-- 'edwards'
-- 'murphy'
-- 'simmons'
-- 'tucker'
-- 'coleman'
-- 'flores'
-- 'gibson'

-- [Problem 1g]
SELECT DISTINCT username FROM
    passing NATURAL JOIN submission
    WHERE sub_id NOT IN
    (SELECT sub_id FROM fileset)
    AND asn_id IN
    (SELECT asn_id FROM assignment
    WHERE shortname = 'midterm' OR 
    shortname = 'final');
-- Query Result:
-- username
-- 'collins'

-- [Problem 2a]
SELECT DISTINCT username 
    FROM submission NATURAL JOIN fileset NATURAL JOIN assignment
    WHERE shortname = 'midterm'
    AND sub_date > due;

-- [Problem 2b]
SELECT EXTRACT(HOUR FROM sub_date) AS `hour`, 
    IFNULL(COUNT(*), 0) AS num_submits 
    FROM submission NATURAL JOIN fileset NATURAL JOIN assignment
    WHERE shortname LIKE 'lab%' 
    GROUP BY `hour`;

-- [Problem 2c]
SELECT COUNT(*) AS num_submits 
    FROM submission NATURAL JOIN fileset NATURAL JOIN assignment
    WHERE shortname = 'final'
    AND sub_date BETWEEN due - INTERVAL 30 MINUTE AND due;

-- [Problem 3a]
ALTER TABLE student
    ADD email VARCHAR(200);

UPDATE student
   SET email = CONCAT(username, '@school.edu');

ALTER TABLE student
    CHANGE COLUMN email email
        VARCHAR(200) NOT NULL;

-- [Problem 3b]
ALTER TABLE assignment
    ADD submit_files TINYINT
        DEFAULT 1;

UPDATE assignment
    SET submit_files = 0
    WHERE shortname LIKE 'dq%';

-- [Problem 3c]
CREATE TABLE gradescheme (
    scheme_id INT,
    scheme_desc VARCHAR(100) NOT NULL,
    PRIMARY KEY (scheme_id)
);

INSERT INTO gradescheme VALUES
    (0, 'Lab assignment with min-grading.'),
    (1, 'Daily quiz.'),
    (2, 'Midterm or final exam.');

ALTER TABLE assignment
    CHANGE COLUMN gradescheme scheme_id
        INT NOT NULL;

ALTER TABLE assignment
    ADD CONSTRAINT FOREIGN KEY (scheme_id)
        REFERENCES gradescheme(scheme_id);
