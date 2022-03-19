-- [Problem 1a]
-- Find the names of all students 
-- who have taken at least one Comp. Sci. course. 
SELECT DISTINCT name FROM student, takes, course 
    WHERE student.ID = takes.ID 
    AND takes.course_id = course.course_id 
    AND course.dept_name = 'Comp. Sci.';

-- [Problem 1b]
-- Find the maximum salary of instructors in that department.
SELECT dept_name, MAX(salary) AS max_salary 
    FROM instructor GROUP BY dept_name;

-- [Problem 1c]
-- Find the lowest, across all departments, 
-- of the per department maximum salary.
SELECT MIN(max_salary) AS min_salary 
   FROM (SELECT dept_name, MAX(salary) AS max_salary 
   FROM instructor GROUP BY dept_name) AS max_salaries;

-- [Problem 1d]
-- rewrite your answer from part c 
-- using a WITH clause to perform the innermost aggregation.
WITH max_salaries AS
    (SELECT dept_name, MAX(salary) AS max_salary 
    FROM instructor GROUP BY dept_name)
    SELECT MIN(max_salary) AS min_salary FROM max_salaries;

-- [Problem 2a]
-- Create a new course CS-001, 
-- titled Weekly Seminar, with 3 credits.
INSERT INTO course VALUES('CS-001', 'Weekly Seminar', 'Comp. Sci.', 3);

-- [Problem 2b]
-- Create a section of this course in Winter 2021, with sec_id of 1.
INSERT INTO section 
    VALUES('CS-001', '1', 'Winter', 2021, NULL, NULL, NULL);

-- [Problem 2c]
-- Enroll every student in the Comp. Sci. department in the above section.
INSERT INTO takes(ID, course_id, sec_id, semester, year) 
   SELECT ID, course_id, sec_id, semester, year
   FROM student, section
   WHERE course_id = 'CS-001' AND dept_name = 'Comp. Sci.';

-- [Problem 2d]
-- Delete enrollments in the above section where the student's name is Chavez.
DELETE FROM takes
   WHERE course_id = 'CS-001' AND sec_id = '1' AND semester = 'Winter'
   AND year = '2021' AND
   ID IN (SELECT ID FROM student WHERE NAME = 'Chavez');

-- [Problem 2e]
-- Delete the course CS-001.  
-- What will happen if you run this delete statement without first 
-- deleting offerings (sections) of this course?
DELETE FROM course WHERE course_id = 'CS-001';

-- [Problem 2f]
-- Delete all takes tuples corresponding to any section of any course
-- with the word "database" as a part of the title. 
DELETE FROM takes WHERE course_id IN 
    (SELECT course_id FROM course WHERE title LIKE '%database%');

-- [Problem 3a]
-- Retrieve the names of members 
-- who have borrowed any book published by "McGraw-Hill". 
SELECT DISTINCT name FROM member, borrowed, book
    WHERE member.memb_no = borrowed.memb_no 
    AND book.isbn = borrowed.isbn
    AND book.publisher = 'McGraw-Hill';
    
-- [Problem 3b]
-- Retrieve the names of members who have borrowed 
-- all books published by "McGraw-Hill".
SELECT DISTINCT name 
    FROM (member JOIN borrowed ON member.memb_no = borrowed.memb_no)
    JOIN (SELECT DISTINCT isbn FROM book WHERE publisher = 'McGraw-Hill')
    AS books ON borrowed.isbn = books.isbn GROUP BY member.name
    HAVING COUNT(*) = (SELECT COUNT(*) 
    FROM book WHERE publisher = 'McGraw-Hill');

-- [Problem 3c]
-- For each publisher, retrieve the names of members 
-- who have borrowed more than five books of that publisher.
SELECT book.publisher, member.name FROM member, borrowed, book
    WHERE member.memb_no = borrowed.memb_no
    AND borrowed.isbn = book.isbn
    GROUP BY publisher, name
    HAVING COUNT(borrowed.isbn) > 5;

-- [Problem 3d]
-- Compute the average number of books borrowed per member.
SELECT COUNT(*) * 1.0 / (SELECT COUNT(*) FROM member)
    FROM borrowed;

-- [Problem 3e]
-- Rewrite your answer for part d using a WITH clause.
WITH counts AS 
    (SELECT COUNT(*) * 1.0 AS books FROM borrowed)
    SELECT (SELECT books FROM counts) / (SELECT COUNT(*) FROM member);
