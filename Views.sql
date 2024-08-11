-- VIEW IN SQL
-- A VIEW is a virtual table that is based on the result-set of a SQL query. 
-- A view contains rows and columns, just like a real table.
-- The fields in a view are fields from one or more real tables in the database. 
-- You can think of a view as a saved query that you can treat as if it were a table.

-- Creating a simple view named CUST_VIEW from the CUSTOMER table
CREATE VIEW CUST_VIEW
AS 
SELECT CUST_NAME, CUST_CODE, CUST_CITY
FROM CUSTOMER;

-- Selecting all records from the view CUST_VIEW to display the data
SELECT * FROM CUST_VIEW;

-- Altering the view CUST_VIEW to change its structure
ALTER VIEW [dbo].[CUST_VIEW]
AS 
SELECT CUST_NAME, CUST_CITY, CUST_COUNTRY
FROM CUSTOMER;

-- Selecting all records from the altered view CUST_VIEW to display the updated data
SELECT * FROM CUST_VIEW;

-- Dropping (deleting) the view CUST_VIEW
DROP VIEW [dbo].[CUST_VIEW];


-- Creating a new STUDENT table to store student details
CREATE TABLE STUDENT (
    STUDENT_ID INT PRIMARY KEY,              -- Primary key for uniquely identifying each student
    STUDENT_NAME VARCHAR(50) NOT NULL,       -- Student's name, cannot be null
    BRANCH VARCHAR(50) NOT NULL              -- Branch of study, cannot be null
);

-- Inserting sample data into the STUDENT table
INSERT INTO STUDENT (STUDENT_ID, STUDENT_NAME, BRANCH) VALUES
(1, 'Alice Johnson', 'Computer Science'),
(2, 'Bob Smith', 'Mechanical Engineering'),
(3, 'Charlie Brown', 'Electrical Engineering'),
(4, 'Diana Prince', 'Civil Engineering'),
(5, 'Eve Adams', 'Information Technology');

-- Selecting all records from the STUDENT table to verify the data
SELECT * FROM STUDENT;

-- Creating a view named STUDENT_VIEW that includes only STUDENT_NAME and BRANCH columns
CREATE VIEW STUDENT_VIEW AS
SELECT STUDENT_NAME, BRANCH
FROM STUDENT;

-- Selecting all records from the STUDENT_VIEW to display the data
SELECT * FROM STUDENT_VIEW;

-- Attempting to insert a new record into STUDENT_VIEW without specifying STUDENT_ID
-- This will raise an error because STUDENT_ID is a required column in the STUDENT table
-- INSERT INTO STUDENT_VIEW (STUDENT_NAME, BRANCH) VALUES ('Frank Miller', 'Aeronautical Engineering');

-- Updating a record in the STUDENT_VIEW to change the student's name from 'Eve Adams' to 'Ayush Ginoya'
UPDATE STUDENT_VIEW 
SET STUDENT_NAME='Ayush Ginoya'
WHERE STUDENT_NAME='Eve Adams';

-- Selecting all records from STUDENT_VIEW to verify the update
SELECT * FROM STUDENT_VIEW;


-- Creating a new STUDENT1 table to store student details along with birthdate
CREATE TABLE STUDENT1 (
    STUDENT_ID INT PRIMARY KEY,              -- Primary key for uniquely identifying each student
    STUDENT_NAME VARCHAR(50) NOT NULL,       -- Student's name, cannot be null
    BIRTHDATE DATE NOT NULL                  -- Student's birthdate, cannot be null
);

-- Inserting sample data into the STUDENT1 table
INSERT INTO STUDENT1 (STUDENT_ID, STUDENT_NAME, BIRTHDATE) VALUES
(1, 'Alice Johnson', '2000-05-15'),
(2, 'Bob Smith', '1998-11-23'),
(3, 'Charlie Brown', '2002-08-10'),
(4, 'Diana Prince', '1999-01-30'),
(5, 'Eve Adams', '2001-06-05');

-- Creating a view named STUDENT_AGE_VIEW that calculates the age based on the birthdate
CREATE VIEW STUDENT_AGE_VIEW AS
SELECT 
    STUDENT_ID,                                  -- Including the student's ID
    STUDENT_NAME,                                -- Including the student's name
    BIRTHDATE,                                   -- Including the student's birthdate
    DATEDIFF(YEAR, BIRTHDATE, GETDATE()) -       -- Calculating the age by subtracting birth year from the current year
        CASE WHEN MONTH(BIRTHDATE) > MONTH(GETDATE()) 
                  OR (MONTH(BIRTHDATE) = MONTH(GETDATE()) AND DAY(BIRTHDATE) > DAY(GETDATE())) 
             THEN 1 ELSE 0 END AS AGE            -- Adjusting the age if the birthday hasn't occurred yet this year
FROM STUDENT1;

-- Selecting all records from STUDENT_AGE_VIEW to display the calculated ages
SELECT * FROM STUDENT_AGE_VIEW;
