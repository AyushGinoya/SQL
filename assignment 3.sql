CREATE TABLE MST_Agent (
    AGENT_CODE VARCHAR(10) PRIMARY KEY,
    AGENT_NAME VARCHAR(50),
    WORKING_AREA VARCHAR(50),
    JOINING_DT DATE,
    SALARY_AMT DECIMAL(10, 2),
    PHONE_NO VARCHAR(15),
    COMMISSION DECIMAL(5, 2)
);

INSERT INTO MST_Agent (AGENT_CODE, AGENT_NAME, WORKING_AREA, JOINING_DT, SALARY_AMT, PHONE_NO, COMMISSION) VALUES
('A001', 'Chandresh', 'Kolkata', '2012-09-01', 10000.00, '7984163844', 12.50),
('A002', 'Chintan', 'Goa', '2015-12-15', 12500.00, '7464335432', 13.25),
('A003', 'Deep', 'Kolkata', '2014-06-22', 17000.00, '8987413133', 12.00),
('A004', 'Mahesh', 'Haryana', '2013-05-12', 27000.00, '7384131111', 10.00),
('A005', 'Chandrakant', 'New Delhi', '2017-11-01', 69000.00, '6894313132', 14.00),
('A006', 'Sanjay', 'Hyderabad', '2018-02-05', 44000.00, '9842343123', 12.25),
('A007', 'Dharmesh', 'Haryana', '2019-04-14', 37000.00, '8413843131', 15.00),
('A008', 'Dinesh', 'Punjab', '2018-07-17', 48000.00, '9531313156', 11.50),
('A009', 'Mahesh', 'Bangalore', '2016-05-24', 56000.00, '7849135138', 13.25),
('A010', 'Chandresh', 'Kota', '2018-12-27', 32000.00, '9138431054', 12.75),
('A011', 'Hiren', 'Punjab', '2020-01-09', 61000.00, '8780485620', 14.50),
('A012', 'Sahil', 'Hyderabad', '2013-08-21', 39000.00, '8998431305', 10.50);



CREATE TABLE MST_Customer (
    CUST_CODE VARCHAR(10) PRIMARY KEY,
    CUST_NAME VARCHAR(50),
    CUST_CITY VARCHAR(50),
    WORKING_AREA VARCHAR(50),
    PHONE_NO VARCHAR(15),
    AGENT_CODE VARCHAR(10),
    BIRTH_DATE DATE,
    FOREIGN KEY (AGENT_CODE) REFERENCES MST_Agent(AGENT_CODE)
);


INSERT INTO MST_Customer (CUST_CODE, CUST_NAME, CUST_CITY, WORKING_AREA, PHONE_NO, AGENT_CODE, BIRTH_DATE) VALUES
('C00001', 'Ram', 'Bangalore', 'Goa', '8460821584', 'A002', '1998-03-10'),
('C00002', 'Sasikant', 'Haryana', 'Haryana', '6554123201', 'A007', '1995-06-15'),
('C00003', 'Mahesh', 'Kota', 'New Delhi', '5651232045', 'A005', '1995-05-22'),
('C00004', 'Ravindran', 'Haryana', 'Kolkata', '7112313564', 'A001', '1996-08-29'),
('C00005', 'Ramesh', 'Mumbai', 'Chennai', '9234843211', 'A009', '1998-11-01'),
('C00006', 'Suresh', 'Bangalore', 'Goa', '8542313218', 'A002', '1997-01-14'),
('C00007', 'Mahesh', 'New Delhi', 'Punjab', '6542318431', 'A006', '1992-02-21'),
('C00008', 'Prabodh', 'Kolkata', 'Haryana', '7216384313', 'A004', '1994-03-05'),
('C00009', 'Vinod', 'Haryana', 'Haryana', '9351313133', 'A007', '1993-04-16'),
('C00010', 'Pramod', 'Punjab', 'Punjab', '7354567486', NULL, '1994-07-23'),
('C00011', 'Prabodh', 'Hyderabad', 'Gujarat', '7674643131', 'A001', '1991-09-19'),
('C00012', 'Bhavesh', 'Goa', 'Kota', '9432138454', 'A010', '1992-06-25');



CREATE TABLE MST_Order (
    ORD_NUM INT PRIMARY KEY,
    ORD_AMOUNT DECIMAL(10, 2),
    ORD_DATE DATE,
    CUST_CODE VARCHAR(10),
    AGENT_CODE VARCHAR(10),
    CUST_FEEDBACK VARCHAR(255),
    FOREIGN KEY (CUST_CODE) REFERENCES MST_Customer(CUST_CODE),
    FOREIGN KEY (AGENT_CODE) REFERENCES MST_Agent(AGENT_CODE)
);


INSERT INTO MST_Order (ORD_NUM, ORD_AMOUNT, ORD_DATE, CUST_CODE, AGENT_CODE, CUST_FEEDBACK) VALUES
(200114, 3500.00, '2018-08-15', 'C00002', 'A007', 'Good Product for every one'),
(200122, 2500.00, '2018-09-16', 'C00003', 'A005', 'Nice Product giving 80% rating'),
(200118, 500.00, '2017-07-20', 'C00005', 'A009', 'Best Product [Very Genuine]'),
(200119, 1500.00, '2019-07-16', 'C00007', 'A006', 'Bad Product, Rating 0%'),
(200121, 4000.00, '2021-05-25', 'C00006', 'A004', 'Too much Costly'),
(200130, 600.00, '2016-08-26', 'C00004', 'A001', 'Good_Experience'),
(200134, 4200.00, '2018-06-15', 'C00001', 'A002', '100% genuine recommended'),
(200103, 1000.00, '2019-03-13', 'C00005', 'A009', NULL),
(200109, 2700.00, '2020-05-30', 'C00012', 'A010', NULL),
(200111, 4400.00, '2020-03-13', 'C00009', 'A007', NULL),
(200112, 1600.00, '2019-02-15', 'C00009', 'A007', NULL),
(200123, 2300.00, '2017-10-20', 'C00006', 'A008', 'Good Product');


SELECT * FROM MST_Customer
SELECT * FROM MST_Agent
SELECT * FROM MST_Order



--1. Display the last 5 records from the customer table.
SELECT TOP 5 * FROM MST_Customer 
ORDER BY CUST_CODE DESC;


--2. Find customers whose agent is Chandresh.
SELECT C.*  FROM MST_Customer C
JOIN MST_Agent A
ON A.AGENT_CODE = C.AGENT_CODE
WHERE A.AGENT_NAME='Chandresh'


--3. Find customers whose working area and city are the same.
SELECT * 
FROM MST_Customer 
WHERE WORKING_AREA = CUST_CITY;

SELECT DISTINCT C.*
FROM MST_Customer C
JOIN MST_Customer C2 ON C2.AGENT_CODE = C.AGENT_CODE
WHERE C2.WORKING_AREA = C.CUST_CITY;
--This query retrieves customers (C) where another customer (C2), 
--who shares the same AGENT_CODE, has a WORKING_AREA that matches 
--the CUST_CITY of the first customer.


--4. Find customers whose agent has commission between 12.00 to 14.00 percent.
SELECT C.*  FROM MST_Customer C
JOIN MST_Agent A
ON A.AGENT_CODE = C.AGENT_CODE
WHERE A.COMMISSION BETWEEN 12.00 AND 14.00;


--5. Find the second highest salary of an agent.
SELECT MAX(SALARY_AMT) AS SecondHighestSalary
FROM MST_Agent M
WHERE SALARY_AMT NOT IN (SELECT MAX(SALARY_AMT) FROM MST_Agent);

--6. Display order details of customers whose agent has a salary more than 40000.
SELECT O.* FROM MST_Order O
JOIN MST_Customer C 
ON O.CUST_CODE = C.CUST_CODE
JOIN MST_Agent A 
ON C.AGENT_CODE = A.AGENT_CODE
WHERE A.SALARY_AMT > 40000;


--7. Display agent details who does not have any customers.
SELECT A.* FROM MST_Agent A
LEFT JOIN MST_Customer C
ON A.AGENT_CODE = C.AGENT_CODE
WHERE C.AGENT_CODE IS NULL

--8. Display customer names who have placed orders.
SELECT C.CUST_NAME FROM MST_Customer C
JOIN MST_Order O
ON O.CUST_CODE = C.CUST_CODE

SELECT DISTINCT C.CUST_NAME FROM MST_Customer C
JOIN MST_Order O ON C.CUST_CODE = O.CUST_CODE;


--9. Display orders details whose feedback contains ‘%’.
SELECT * FROM MST_Order
WHERE CUST_FEEDBACK LIKE '%[%]%';


--10. Display agent names starting and ending with vowels.
SELECT AGENT_NAME FROM MST_Agent
WHERE AGENT_NAME LIKE '[AEIOUaeiou]%' AND AGENT_NAME LIKE '%[AEIOUaeiou]';

--11. Display year wise total amount of order.
SELECT YEAR(ORD_DATE),SUM(ORD_AMOUNT) AS TotalAmount FROM MST_Order 
GROUP BY YEAR(ORD_DATE)


--12. Display agent wise total amount of order.
SELECT A.AGENT_NAME, SUM(O.ORD_AMOUNT) AS TotalAmount FROM MST_Order O
JOIN MST_Agent A ON O.AGENT_CODE = A.AGENT_CODE
GROUP BY A.AGENT_NAME;


--13. Display customers with total orders who ordered more than 1 time.
SELECT C.CUST_NAME, COUNT(O.ORD_NUM) AS TotalOrders FROM MST_Customer C
JOIN MST_Order O
ON O.CUST_CODE = C.CUST_CODE
GROUP BY C.CUST_NAME
HAVING COUNT(O.ORD_NUM)>1


--14. Display agent wise total customer count who has more than one customer.
SELECT A.AGENT_NAME, COUNT(C.CUST_CODE) AS TotalCustomer FROM MST_Agent A
JOIN MST_Customer C
ON A.AGENT_CODE = C.AGENT_CODE
GROUP BY A.AGENT_NAME
HAVING COUNT(C.CUST_CODE)>1

--15. Display customers and agents who have the same working city
SELECT C.CUST_NAME, A.AGENT_NAME, C.CUST_CITY FROM MST_Customer C
JOIN MST_Agent A 
ON C.AGENT_CODE = A.AGENT_CODE
WHERE C.CUST_CITY = A.WORKING_AREA;
