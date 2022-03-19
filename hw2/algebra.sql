-- [Problem 1]
-- Selects A from r without duplicates
SELECT DISTINCT A FROM r;

-- [Problem 2]
-- Select all attributes from r where b = 42
SELECT * FROM r WHERE B = 42;

-- [Problem 3]
-- Cartesian product of r, s
SELECT * FROM r, s;

-- [Problem 4]
-- Select attributes A, F from cartesian product of r, s
-- where attribute C equals attribute D
SELECT DISTINCT A, F FROM r, s WHERE C = D;

-- [Problem 5]
-- r1 union r2
(SELECT * FROM r1) UNION (SELECT * FROM r2);

-- [Problem 6]
-- r1 intersection r2
SELECT * FROM r1 WHERE (A, B, C) IN (SELECT * FROM r2);

-- [Problem 7]
-- r1 set difference r2
SELECT * FROM r1 WHERE (A, B, C) NOT IN (SELECT * FROM r2);