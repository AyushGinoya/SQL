CREATE TABLE STUDENTS2 (
    StuID INT,
    FirstName VARCHAR(25),
    LastName VARCHAR(25),
    Website VARCHAR(50),
    City VARCHAR(25),
    Division VARCHAR(20)
);


INSERT INTO STUDENTS2 (StuID, FirstName, LastName, Website, City, Division)
VALUES
(1011, 'KEYUR', 'PATEL', 'techonthenet.com', 'RAJKOT', 'II-BCX'),
(1022, 'HARDIK', 'SHAH', 'digminecraft.com', 'AHMEDABAD', 'I-BCY'),
(1033, 'KAJAL', 'TRIVEDI', 'bigactivities.com', 'BARODA', 'IV-DCX'),
(1044, 'BHOOMI', 'GAJERA', 'checkyourmath.com', 'AHMEDABAD','II-BCY' ),
(1055, 'HARMIT', 'MITEL', NULL, 'RAJKOT', 'II-BCZ' ),
(1066, 'ASHOK', 'JANI', NULL, 'BARODA','II-BCZ');

SELECT * FROM STUDENTS2


--Display the name of students whose name starts with ‘k’. 
SELECT FirstName FROM STUDENTS2
WHERE FirstName LIKE 'K%';


--Display the name of students whose name consists of five characters.
SELECT FirstName FROM STUDENTS2 
WHERE FirstName LIKE '_____';

SELECT FirstName, LastName 
FROM STUDENTS2 
WHERE LEN(FirstName) = 5;


--Retrieve the first name & last name of students whose city name ends with a & contains six characters. 
SELECT FirstName,LastName FROM STUDENTS2 
WHERE City LIKE '_____A';

SELECT FirstName, LastName 
FROM STUDENTS2 
WHERE City LIKE '%a' AND LEN(City) = 6;


--Display all the students whose last name ends with ‘tel’. 
SELECT * FROM STUDENTS2 
WHERE LastName LIKE '%TEL';


--Display all the students whose first name starts with ‘ha’ & ends with ‘t’. 
SELECT * FROM STUDENTS2 
WHERE FirstName LIKE 'HA%T';


--Display all the students whose first name starts with ‘k’ and third character is ‘y’.
SELECT FirstName, LastName 
FROM STUDENTS2 
WHERE FirstName LIKE 'K_Y%';


--Display the name of students having no website and name consists of five characters. 
SELECT FirstName, LastName 
FROM STUDENTS2 
WHERE Website IS NULL AND LEN(FirstName) = 5;


--Display all the students whose last name consist of ‘jer’.   
SELECT FirstName, LastName 
FROM STUDENTS2 
WHERE LastName LIKE '%JER%';


--Display all the students whose city name starts with either ‘r’ or ‘b’.
SELECT FirstName, LastName, City 
FROM STUDENTS2 
WHERE City LIKE 'R%' OR City LIKE 'B%';


--Display all the name students having websites. 
SELECT FirstName, LastName 
FROM STUDENTS2 
WHERE Website IS NOT NULL;


-- Display all the students whose name starts from alphabet A to H.
SELECT FirstName, LastName 
FROM STUDENTS2 
WHERE FirstName LIKE '[A-H]%' ;


-- Display all the students whose name’s second character is vowel.
SELECT FirstName, LastName 
FROM STUDENTS2 
WHERE FirstName LIKE '_[AEIOUaeiou]%';


-- Display student’s name whose city name consist of ‘rod’. 
SELECT FirstName, LastName 
FROM STUDENTS2 
WHERE City LIKE '%ROD%';


--Retrieve the First & Last Name of students whose website name starts with ‘bi’. 
SELECT FirstName, LastName 
FROM STUDENTS2 
WHERE Website LIKE '%BI%';


--Display student’s city whose last name consists of six characters. 
SELECT FirstName,LastName 
FROM STUDENTS2 
WHERE LastName LIKE '______';


--Display all the students whose city name consist of five characters & not starts with ‘ba’.
SELECT FirstName,LastName 
FROM STUDENTS2 
WHERE City LIKE '______' AND City NOT LIKE 'BA%';


--Show all the student’s whose division starts with ‘II’. 
SELECT FirstName, LastName, Division 
FROM STUDENTS2 
WHERE Division LIKE 'II%';


-- Find out student’s first name whose division contains ‘bc’ anywhere in division name.
SELECT FirstName 
FROM STUDENTS2 
WHERE Division LIKE '%BC%';


--Show student id and city name in which division consist of six characters and having website name.
SELECT StuID, City 
FROM STUDENTS2 
WHERE LEN(Division) = 6 AND Website IS NOT NULL;


--Display all the students whose name’s third character is consonant. 
SELECT FirstName, LastName 
FROM STUDENTS2 
WHERE FirstName LIKE '__[BCDFGHJKLMNPQRSTVWXYZbcdfghjklmnpqrstvwxyz]%' ;
