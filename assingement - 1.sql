CREATE TABLE STUDENT_2
(
	STUDENTID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FIRSTNAME VARCHAR(100) NOT NULL,
	LASTNAME VARCHAR(100) NOT NULL,
	AGE INT,
	GENDER VARCHAR(50) NOT NULL,
	BRANCH VARCHAR(50) NOT NULL,
	CGPA DECIMAL(4,2) NOT NULL,
	ENROLLMENTYEAR VARCHAR(100) NOT NULL 
)


INSERT INTO STUDENT_2 (FIRSTNAME, LASTNAME, AGE, GENDER, BRANCH, CGPA, ENROLLMENTYEAR)
VALUES 
('AYUSH', 'GINOYA', 20, 'MALE', 'IT', 8.08, '2021'),
('MONIL', 'GHORI', 20, 'MALE', 'IT', 8.7, '2021'),
('NETRI', 'GHORI', 21, 'FEMALE', 'CE', 3.9, '2020'),
('PRIYANS', 'DOBARIYA', 23, 'MALE', 'MH', 8.0, '2021'),
('ANANYA', 'MEHTA', 20, 'FEMALE', 'CHE', 8.6, '2019'),
('KEVIN', 'SANGANI', NULL, 'MALE', 'IT', 8.1, '2020'),
('ISHIKA', 'TALA', 22, 'FEMALE', 'CE', 7.9, '2019'),
('ARJUN', 'SINGH', 20, 'MALE', 'EC', 8.3, '2020'),
('PRIYA', 'JOSHI', 21, 'FEMALE', 'MH', 8.4, '2021'),
('KAVYA', 'DAVE', 23, 'FEMALE', 'CHE', 8.7, '2019'),
('RAJAT', 'VERMA', NULL, 'MALE', 'IT', 7.7, '2020'),
('MIHIR', 'YARA', 22, 'MALE', 'CE', 7.6, '2019'),
('SNEHA', 'MARAKNA', 20, 'FEMALE', 'EC', 8.8, '2020'),
('SIDDHARTH', 'TALA', 21, 'MALE', 'MH', 2.4, '2021'),
('RIYA', 'JAH', 23, 'FEMALE', 'CHE', 3.5, '2019'),
('NAMAN', 'GINOYA', 20, 'MALE', 'IT', 7.8, '2020'),
('ISHANI', 'SORATHIYA', 21, 'FEMALE', 'CE', 3.2, '2019'),
('YASH', 'VEKARIYA', 22, 'MALE', 'EC', 8.3, '2020'),
('AYUSHI', 'DONGA', 23, 'FEMALE', 'MH', 8.5, '2021'),
('ADITI', 'PATEL', 21, 'FEMALE', 'CHE', 4.0, '2019');



--1 Retrieve all the students with all details.
SELECT * FROM STUDENT_2

--2 Retrieve first and last names of all students.
SELECT FIRSTNAME,LASTNAME 
FROM STUDENT_2

--3 Retrieve students with a CGPA greater than 5.5.
SELECT * FROM STUDENT_2 
WHERE CGPA>5.5

--4 Retrieve students who enrolled in year 2020.
SELECT * FROM STUDENT_2
WHERE ENROLLMENTYEAR=2020

--5 Retrieve students having branch as 'Computer Science'.
SELECT * FROM STUDENT_2 
WHERE BRANCH='CE'

--6 Retrieve students whose first name is ‘Nilesh’ and Age is not mentioned.
SELECT * FROM STUDENT_2 WHERE 
FIRSTNAME='Nilesh' AND AGE IS NULL

SELECT * FROM STUDENT_2 WHERE 
FIRSTNAME='KEVIN' AND AGE IS NULL

--7 Retrieve students who are either male or have a CGPA less than 2.5.
SELECT * FROM STUDENT_2 
WHERE GENDER='MALE' AND CGPA < 2.5

--8 Retrieve students with their branch name in ascending order.
SELECT * FROM STUDENT_2 
ORDER BY BRANCH ASC

--9 Retrieve unique branches from the given table.
SELECT DISTINCT(BRANCH) AS DISTINCT_BRANCH FROM STUDENT_2

--10 Retrieve students with CGPA between 3.0 and 4.0.
SELECT * FROM STUDENT_2 
WHERE CGPA BETWEEN 3.0 AND 4.0

--11 Retrieve the first 5 students with the highest CGPA.
SELECT TOP 5 * FROM STUDENT_2 
ORDER BY CGPA DESC

--12 Retrieve students who are enrolled in the current year.
SELECT * FROM STUDENT_2 
WHERE ENROLLMENTYEAR=YEAR(GETDATE())

--13 Retrieve students who are not enrolled in 2021 with all Female as Gender.
SELECT * FROM STUDENT_2 
WHERE ENROLLMENTYEAR<>2021 AND GENDER = 'FEMALE'

--14 Retrieve the total number of branch wise students.
SELECT BRANCH,COUNT(*) AS TOTAL_STUDENT FROM STUDENT_2 
GROUP BY BRANCH

--15 Retrieve students with a CGPA higher than the average CGPA.
SELECT * FROM STUDENT_2 
WHERE CGPA>(SELECT AVG(CGPA) FROM STUDENT_2)

SELECT STUDENT_2.* 
FROM STUDENT_2
GROUP BY STUDENTID, FIRSTNAME, LASTNAME, AGE, GENDER, BRANCH, CGPA, ENROLLMENTYEAR
HAVING CGPA > (SELECT AVG(CGPA) FROM STUDENT_2);

--16 Retrieve students whose last name starts with 'S'.
SELECT * FROM STUDENT_2 
WHERE LASTNAME LIKE 'S%'

--17 Retrieve students with their first name ordering with ascending order & Last name with 
--descending order. 
SELECT FIRSTNAME,LASTNAME FROM STUDENT_2
ORDER BY FIRSTNAME ASC,LASTNAME DESC

--18 Give the enrolment year wise student count.
SELECT ENROLLMENTYEAR, COUNT(*) 
FROM STUDENT_2
GROUP BY ENROLLMENTYEAR;

--19 Retrieve students whose age is greater than 18 and belongs to CE, MH, OR IT branch.
SELECT * FROM STUDENT_2 
WHERE AGE > 18 AND BRANCH IN('CE','IT','MH')

--20 Retrieve Branch wise Minimum, Maximum & Average CGPA in their ascending order of 
--Maximum CGPA. 
SELECT BRANCH,MAX(CGPA) AS MAX_CGPA,MIN(CGPA) AS MIN_CGPA,AVG(CGPA) AS AVG_CGPA FROM STUDENT_2
GROUP BY BRANCH
ORDER BY MAX_CGPA

--21 Count unique enrolment years from the given table.
SELECT DISTINCT ENROLLMENTYEAR FROM STUDENT_2
SELECT COUNT(DISTINCT ENROLLMENTYEAR) AS UniqueEnrollmentYears FROM STUDENT_2

--22 Retrieve first names of students with the second-highest CGPA
SELECT FIRSTNAME, CGPA FROM STUDENT_2
WHERE CGPA = (
    SELECT MAX(CGPA) FROM STUDENT_2
    WHERE CGPA < (
        SELECT MAX(CGPA) FROM STUDENT_2
    )
);

--23 Retrieve the average CGPA for each branch, and only show branch with an average CGPA 
--above 3.2. 
SELECT BRANCH, AVG(CGPA) AS AverageCGPA FROM STUDENT_2
GROUP BY BRANCH
HAVING AVG(CGPA) > 3.2;

--24 Retrieve the first 3 students with the lowest CGPA, showing only their ID, name, and CGPA.
SELECT TOP 3 STUDENTID, FIRSTNAME, CGPA
FROM STUDENT_2
ORDER BY CGPA ASC;


--25 Retrieve the total number of male and female students.SELECT GENDER, COUNT(*) AS TotalCount
FROM STUDENT_2
GROUP BY GENDER;
