-- Create table Student_Marks with Sid int not null, SName varchar (50) not null & Marks int not null columns & insert records as given below. 


CREATE TABLE Student_Marks (
    Sid INT NOT NULL,
    SName VARCHAR(50) NOT NULL,
    Marks INT NOT NULL
);


INSERT INTO Student_Marks (Sid, SName, Marks)
VALUES 
    (1, 'John', 90),
    (2, 'Martin', 80),
    (3, 'Carol', 89),
    (4, 'Jack', 99),
    (5, 'Rose', 88),
    (6, 'Mary', 90);

SELECT * FROM Student_Marks;


--1. Find total number of students. 
SELECT COUNT(*) AS TotalStudent FROM Student_Marks


--2. Find total of marks scored by all students. 
SELECT SUM(Marks) AS TotalMarks FROM Student_Marks


--3. Find average marks of all students. 
SELECT AVG(Marks) AvgMarks FROM Student_Marks


--4. Find minimum marks scored from all students. 
SELECT MIN(Marks) AS MinimumMarks FROM Student_Marks;


--5. Find maximum marks scored from all students.
SELECT MAX(Marks) AS MaximumMarks FROM Student_Marks;
