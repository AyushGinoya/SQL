CREATE TABLE Employee2 (
    EID INT NOT NULL,
    EName VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(8, 2) NOT NULL,
    JoiningDate DATETIME NOT NULL,
    City VARCHAR(50) NOT NULL
);




INSERT INTO Employee2 (EID, EName, Department, Salary, JoiningDate, City)
VALUES
    (101, 'Rahul', 'Admin', 56000.00, '1990-01-01', 'Rajkot'),
    (102, 'Hardik', 'IT', 18000.00, '1990-09-25', 'Ahmedabad'),
    (103, 'Bhavin', 'HR', 25000.00, '1991-05-14', 'Baroda'),
    (104, 'Bhoomi', 'Admin', 39000.00, '1991-02-08', 'Rajkot'),
    (105, 'Rohit', 'IT', 17000.00, '1990-07-23', 'Jamnagar'),
    (106, 'Priya', 'IT', 9000.00, '1990-10-18', 'Ahmedabad'),
    (107, 'Neha', 'HR', 34000.00, '1991-12-25', 'Rajkot');

SELECT * FROM Employee2



--1. Display the Highest, Lowest, Total, and Average salary of all employees & label the columns Maximum, Minimum, Total_Sal and Average_Sal, respectively.
SELECT 
    MAX(Salary) AS Maximum,
    MIN(Salary) AS Minimum,
    SUM(Salary) AS Total_Sal,
    AVG(Salary) AS Average_Sal
FROM Employee2;


--2. Find total number of employees of EMPLOYEE table. 
SELECT COUNT(*) AS TotalEmployees
FROM Employee2;


--3. Retrieve maximum salary from IT department. 
SELECT MAX(Salary) AS MaxSalary_IT
FROM Employee2
WHERE Department = 'IT';


--4. Count total number of cities of employee without duplication. 
SELECT COUNT(DISTINCT City) AS TotalCities
FROM Employee2;


--5. Display city with the total number of employees belonging to each city. 
SELECT City,COUNT(City) AS Count 
FROM Employee2
GROUP BY City


--6. Display city having more than one employee. 
SELECT City,COUNT(EID) AS Count 
FROM Employee2
GROUP BY City
HAVING COUNT(EID)> 1


SELECT City
FROM Employee2
GROUP BY City
HAVING COUNT(*) > 1;


--7. Give total salary of each department of EMPLOYEE table. 
SELECT Department,SUM(Salary) AS TotalSalary
FROM Employee2
GROUP BY Department;


--8. Give average salary of each department of EMPLOYEE table without displaying the respective department name. 
SELECT AVG(Salary) AS AverageSalary
FROM Employee2
GROUP BY Department;


--9. Give minimum salary of employee who belongs to Ahmedabad. 
SELECT MIN(Salary) AS MinSalary_Ahmedabad
FROM Employee2
WHERE City = 'Ahmedabad';


--10. List the departments having total salaries more than 50000 and located in city Rajkot. 
SELECT Department,SUM(Salary) AS TotalSalary
FROM Employee2
WHERE City = 'Rajkot'
GROUP BY Department
Having SUM(Salary)>50000;


--11.  Count the number of employees living in Rajkot. 
SELECT COUNT(*) AS EmployeesInRajkot
FROM Employee2
WHERE City = 'Rajkot';


--12.  Display the difference between the highest and lowest salaries. Label the column name to SAL_DIFFERENCE. 
SELECT MAX(Salary) - MIN(Salary) AS SAL_DIFFERENCE
FROM Employee2;


--13. Display the total number of employees hired before 1st January, 1991. 
SELECT COUNT(*) AS EmployeesBefore1991
FROM Employee2
WHERE JoiningDate < '1991-01-01';


--14. Display total salary of each department with total salary exceeding 35000 and sort the list by total salary. 
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employee2
GROUP BY Department
HAVING SUM(Salary) > 35000
ORDER BY TotalSalary DESC;


--15. List out department names in which more than two employees. 
SELECT Department
FROM Employee2
GROUP BY Department
HAVING COUNT(*) > 2;


--16. Display Minimum salary of Rajkot City. 
SELECT MIN(Salary) AS MinSalary_Rajkot
FROM Employee2
WHERE City = 'Rajkot';


--17. Display City wise total employees count. 
SELECT City, COUNT(*) AS TotalEmployees
FROM Employee2
GROUP BY City;


--18. List all departments with minimum salaries. 
SELECT Department, MIN(Salary) AS MinSalary
FROM Employee2
GROUP BY Department;


--19. Give Total salaries of each city without displaying the respective city name. 
SELECT SUM(Salary) AS TotalSalary
FROM Employee2
GROUP BY City;


--20. Find department wise Minimum, Maximum & Total Salaries. 
SELECT Department, 
       MIN(Salary) AS MinSalary, 
       MAX(Salary) AS MaxSalary, 
       SUM(Salary) AS TotalSalary
FROM Employee2
GROUP BY Department;


--21. Finds the earliest joining date. 
SELECT MIN(JoiningDate) AS EarliestJoiningDate
FROM Employee2;


--WITH EMPLOYEE NAME
SELECT EName, JoiningDate
FROM Employee2
WHERE JoiningDate = (SELECT MIN(JoiningDate) FROM Employee2);


--22. Shows the total salary expenditure for employees by city. 
SELECT City, SUM(Salary) AS TotalSalaryExpenditure
FROM Employee2
GROUP BY City;


--23. Finds the maximum salary in each city. 
SELECT City, MAX(Salary) AS MaxSalary
FROM Employee2
GROUP BY City;


--24. Lists cities with more than 5 employees. 
SELECT City,COUNT(*) AS Count
FROM Employee2
GROUP BY City
HAVING COUNT(*)>5;


--25. Counts how many employees joined each year. 
SELECT YEAR(JoiningDate) AS JoiningYear, COUNT(*) AS TotalEmployees
FROM Employee2
GROUP BY YEAR(JoiningDate)
ORDER BY JoiningYear;


--26. Shows departments with an average salary greater than 50,000. 
SELECT Department
FROM Employee2
GROUP BY Department
HAVING AVG(Salary) > 50000;


--27. Shows the most recent joining date for each department. 
SELECT Department, MIN(JoiningDate) AS JoiningYear
FROM Employee2
GROUP BY Department
ORDER BY JoiningYear;


--28. Lists cities with more than 3 employees and their salary expenditure. 
SELECT City, COUNT(*) AS TotalEmployees, SUM(Salary) AS TotalSalaryExpenditure
FROM Employee2
GROUP BY City
HAVING COUNT(*) > 3;


--29. Orders cities by average salary, from highest to lowest. 
SELECT City, AVG(Salary) AS AverageSalary
FROM Employee2
GROUP BY City
ORDER BY AverageSalary DESC;


--30. Shows the highest and lowest salaries in each department. 
SELECT Department, 
       MAX(Salary) AS MaxSalary, 
       MIN(Salary) AS MinSalary
FROM Employee2
GROUP BY Department;


--31. Finds departments where the total salary exceeds the average total salary of all employees. 
SELECT Department
FROM Employee2
GROUP BY Department
HAVING SUM(Salary) > (SELECT AVG(Salary) FROM Employee);


--32. Finds the employee with the highest salary in the 'HR' department. 
SELECT TOP 1 EName, Salary
FROM Employee2
WHERE Department = 'HR'
ORDER BY Salary DESC;


--33. Counts how many unique cities each department has employees in. 
SELECT Department, COUNT(DISTINCT City) AS UniqueCities
FROM Employee2
GROUP BY Department;


--34. Finds employees in ‘Rajkot’ whose salary is above the average salary of the employees in that city.
SELECT *
FROM Employee2
WHERE City='Rajkot' AND Salary>(SELECT AVG(Salary) FROM Employee2 WHERE City='Rajkot')


--35. Shows departments where the total department salary exceeds the maximum salary of any individual employee in the company. 
SELECT Department
FROM Employee2
GROUP BY Department
HAVING SUM(Salary) > (SELECT MAX(Salary) FROM Employee);


--36. Displays cities where the average salary of employees who joined in 2022 is above the company wide average salary. 
SELECT City
FROM Employee2
WHERE YEAR(JoiningDate) = 2022
GROUP BY City
HAVING AVG(Salary) > (SELECT AVG(Salary) FROM Employee);


--37. Finds departments with more employees than the number of employees who earn more than 50,000.
SELECT Department,COUNT(*) AS NumofEmp
FROM Employee2
GROUP BY Department
HAVING COUNT(*)>(SELECT COUNT(*) FROM Employee2 WHERE Salary>50000)

SELECT Department
FROM Employee2
GROUP BY Department
HAVING COUNT(*) > (SELECT COUNT(*) FROM Employee2 WHERE Salary > 50000);


--38. Finds the employee with the highest salary in the same department as the employee with EID = 101. 
SELECT TOP 1 EName, Salary
FROM Employee2
WHERE Department = (SELECT DISTINCT Department FROM Employee WHERE EID = 101)
ORDER BY Salary DESC;


SELECT TOP 1 EName, Salary
FROM Employee2
WHERE Department IN (SELECT Department FROM Employee WHERE EID = 101)
ORDER BY Salary DESC;



--39. Displays cities where the total salary exceeds that of 'Chicago'. 
SELECT City
FROM Employee2
GROUP BY City
HAVING SUM(Salary) > (SELECT SUM(Salary) FROM Employee WHERE City = 'Rajkot');


--40. Lists departments in ‘Baroda’ with more than 2 employees, along with their total salary and earliest joining date.
SELECT Department, SUM(Salary) AS TotalSalary, MIN(JoiningDate) AS EarliestJoiningDate
FROM Employee2
WHERE City = 'Baroda'
GROUP BY Department
HAVING COUNT(*) > 2;
