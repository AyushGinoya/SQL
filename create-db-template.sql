-- Active: 1716873684310@@127.0.0.1@3306
CREATE DATABASE QUER
    DEFAULT CHARACTER SET = 'utf8mb4';

USE QUERY;

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2),
    JoiningDate DATETIME,
    Department VARCHAR(50),
    Gender VARCHAR(10)
);

INSERT INTO Employee (EmployeeID, FirstName, LastName, Salary, JoiningDate, Department, Gender) VALUES
(1, 'Vikas', 'Ahlawat', 600000.00, '2013-02-15 11:16:28.290', 'IT', 'Male'),
(2, 'nikita', 'Jain', 530000.00, '2014-01-09 17:31:07.993', 'HR', 'Female'),
(3, 'Ashish', 'Kumar', 1000000.00, '2014-01-09 10:05:07.793', 'IT', 'Male'),
(4, 'Nikhil', 'Sharma', 480000.00, '2014-01-09 09:00:07.793', 'HR', 'Male'),
(5, 'anish', 'kadian', 500000.00, '2014-01-09 09:31:07.793', 'Payroll', 'Male');

INSERT INTO Employee (EmployeeID, FirstName, LastName, Salary, JoiningDate, Department, Gender) VALUES
(6, 'Pooja', 'Singh', 450000.00, '2014-02-15 08:15:27.123', 'Finance', 'Female'),
(7, 'Rajesh', 'Mehra', 650000.00, '2015-03-15 09:22:19.456', 'IT', 'Male'),
(8, 'Sneha', 'Verma', 550000.00, '2016-04-20 10:30:25.789', 'HR', 'Female'),
(9, 'Rohit', 'Gupta', 700000.00, '2017-05-18 11:40:30.000', 'IT', 'Male'),
(10, 'Ritu', 'Sharma', 480000.00, '2018-06-22 12:50:35.111', 'Finance', 'Female'),
(11, 'Amit', 'Yadav', 520000.00, '2019-07-15 13:00:40.222', 'Payroll', 'Male'),
(12, 'Ankita', 'Kohli', 600000.00, '2020-08-10 14:10:45.333', 'IT', 'Female'),
(13, 'Vivek', 'Bansal', 530000.00, '2021-09-05 15:20:50.444', 'HR', 'Male'),
(14, 'Kavita', 'Rao', 470000.00, '2022-10-01 16:30:55.555', 'Finance', 'Female'),
(15, 'Ajay', 'Malik', 750000.00, '2023-11-25 17:40:59.666', 'IT', 'Male');


#Write a query to get all employee detail from "EmployeeDetail" table
SELECT * FROM Employee;


#Write a query to get only "FirstName" column from "EmployeeDetail" table
SELECT FirstName FROM Employee;



# Write a query to get FirstName in upper case as "First Name"
SELECT UPPER(FirstName) FROM Employee;


# Write a query to get FirstName in lower case as "First Name".
SELECT LOWER(FirstName) FROM Employee;


# Write a query for combine FirstName and LastName and display it as "Name" (also include white space between first name & last name)
SELECT CONCAT(FirstName, ' ', LastName) AS FullName FROM Employee;


#Select employee detail whose name is "Vikas"
SELECT * FROM Employee WHERE FirstName = 'Vikas';


#Get all employee detail from EmployeeDetail table whose "FirstName" start with latter 'a'.
SELECT * FROM Employee WHERE FirstName LIKE 'a%'


#. Get all employee detail from EmployeeDetail table whose "FirstName" start with latter 'a'.
SELECT * FROM Employee WHERE FirstName LIKE '%a%';


#Get all employee details from EmployeeDetail table whose "FirstName" end with 'h'
SELECT * FROM Employee WHERE FirstName LIKE '%h';


#Get all employee detail from EmployeeDetail table whose "FirstName" start with any single character between 'a-p'
SELECT * FROM Employee WHERE LOWER(FirstName) LIKE '[a-p]%';

SELECT * FROM Employee WHERE LOWER(FirstName) LIKE '[^a-p]%';


#. Get all employee detail from EmployeeDetail table whose "Gender" end with 'le' and contain 4 letters. The Underscore(_) Wildcard Character represents any single character.
SELECT * FROM Employee WHERE Gender LIKE '__le';


#Get all employee detail from EmployeeDetail table whose "FirstName" start with 'A' and contain 5 letters
SELECT * FROM Employee WHERE FirstName LIKE 'A____';

#Get all employee detail from EmployeeDetail table whose "FirstName" containing '%'. ex:-"Vik%as"
SELECT * FROM Employee WHERE FirstName LIKE 'Vik%as';


#Get all unique "Department" from EmployeeDetail table
SELECT Department,COUNT(Department) FROM Employee GROUP BY Department;
# OR
SELECT DISTINCT Department FROM Employee;


# Get the highest "Salary" from EmployeeDetail table.
SELECT MAX(Salary) AS HighestSalary FROM Employee;


#. Show "JoiningDate" in "dd mmm yyyy" format, ex- "15 Feb 2013"
SELECT DATE_FORMAT(JoiningDate, '%d %b %Y') AS JoiningDate FROM Employee;


#Show "JoiningDate" in "yyyy/mm/dd" format, ex- "2013/02/15"
SELECT DATE_FORMAT(JoiningDate, '%Y/%m/%d') AS JoiningDate FROM Employee;

SELECT NOW();


#Get the first name, current date, joining date and diff between current date and joining date in months from EmployeeDetail table.

SELECT FirstName, NOW(), JoiningDate, TIMESTAMPDIFF(MONTH, JoiningDate, CURRENT_TIMESTAMP())
AS Months FROM Employee;


#Display first name and Gender as M/F.(if male then M, if Female then F)
SELECT FirstName,CASE 
    WHEN Gender="Male" THEN  'M'
    ELSE "F"
END AS Gender FROM Employee;


# Select first name from "EmployeeDetail" table prifixed with "Hello " 
SELECT CONCAT('Hello',' ',FirstName) AS FirstName FROM Employee;


# Get employee details from "EmployeeDetail" table whose Salary between 500000 and 600000
SELECT * FROM Employee WHERE Salary BETWEEN 500000 AND 600000;



# Select second highest salary from "EmployeeDetail" table. 
SELECT Salary FROM (
    SELECT Salary FROM Employee ORDER BY Salary DESC LIMIT 2
) AS SubQuery ORDER BY Salary ASC LIMIT 1;