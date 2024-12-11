CREATE TABLE STUDENT (
    Enrollment_No VARCHAR(20),
    Name VARCHAR(25),
    CPI DECIMAL(5,2),
    Birthdate DATETIME
);

SELECT * FROM STUDENT

--Add two more columns City VARCHAR (20) NULL and Backlog INT NOT NULL.
ALTER TABLE STUDENT
ADD City VARCHAR(20) NULL,
Backlog INT NOT NULL;


--Change the size of NAME column of student from VARCHAR (25) to VARCHAR (35). 
ALTER TABLE STUDENT
ALTER COLUMN Name VARCHAR(35);


--Change the data type DECIMAL to INT in CPI Column.
ALTER TABLE STUDENT
ALTER COLUMN CPI INT;


--Rename Column Enrollment No to ENO. 
EXEC sp_rename 'STUDENT.Enrollment_No', 'ENO', 'COLUMN';


--Delete Column City from the STUDENT table. 
ALTER TABLE STUDENT
DROP COLUMN City;


--Change name of table STUDENT to STUDENT_MASTER.
EXEC sp_rename 'STUDENT', 'STUDENT_MASTER';


-- Remove Column Backlog from the table.
ALTER TABLE STUDENT_MASTER
DROP COLUMN Backlog;


--Change Constraint of Name Column from NULL to NOT NULL.
ALTER TABLE STUDENT_MASTER
ALTER COLUMN Name VARCHAR(35) NOT NULL;


--Rename Column Birthdate to BDate
EXEC sp_rename "STUDENT_MASTER.Birthdate","BDate","COLUMN"

SELECT * FROM STUDENT_MASTER