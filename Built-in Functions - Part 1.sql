-- Built-in Functions

SELECT 2+3 AS ADDITION

-- SELECT SALARY + BONUS FROM EMP 

CREATE TABLE CUSTOMER (
    CUST_CODE VARCHAR(6) NOT NULL PRIMARY KEY, 
    CUST_NAME VARCHAR(40) NOT NULL, 
    CUST_CITY CHAR(35), 
    WORKING_AREA VARCHAR(35) NOT NULL, 
    CUST_COUNTRY VARCHAR(20) NOT NULL, 
    GRADE INT, 
    OPENING_AMT DECIMAL(12, 2) NOT NULL, 
    RECEIVE_AMT DECIMAL(12, 2) NOT NULL, 
    PAYMENT_AMT DECIMAL(12, 2) NOT NULL, 
    OUTSTANDING_AMT DECIMAL(12, 2) NOT NULL, 
    PHONE_NO VARCHAR(17) NOT NULL, 
);

INSERT INTO CUSTOMER (CUST_CODE, CUST_NAME, CUST_CITY, WORKING_AREA, CUST_COUNTRY, GRADE, OPENING_AMT, RECEIVE_AMT, PAYMENT_AMT, OUTSTANDING_AMT, PHONE_NO) VALUES
('C00013', 'Holmes', 'London', 'London', 'UK', 2, 6000.00, 5000.00, 7000.00, 4000.00, 'BBBBBBB'),
('C00001', 'Micheal', 'New York', 'New York', 'USA', 2, 3000.00, 5000.00, 2000.00, 6000.00, 'CCCCCCC'),
('C00020', 'Albert', 'New York', 'New York', 'USA', 3, 5000.00, 7000.00, 6000.00, 6000.00, 'BBBBSBB'),
('C00025', 'Ravindran', 'Bangalore', 'Bangalore', 'India', 2, 5000.00, 7000.00, 4000.00, 8000.00, 'AVAVAVA'),
('C00024', 'Cook', 'London', 'London', 'UK', 2, 4000.00, 9000.00, 7000.00, 6000.00, 'FSDDSDF'),
('C00015', 'Stuart', 'London', 'London', 'UK', 1, 6000.00, 8000.00, 3000.00, 11000.00, 'GFSGERS'),
('C00002', 'Bolt', 'New York', 'New York', 'USA', 3, 5000.00, 7000.00, 9000.00, 3000.00, 'DDNRDRH'),
('C00018', 'Fleming', 'Brisbane', 'Brisbane', 'Australia', 2, 7000.00, 7000.00, 9000.00, 5000.00, 'NHBGVFC'),
('C00021', 'Jacks', 'Brisbane', 'Brisbane', 'Australia', 1, 7000.00, 7000.00, 7000.00, 7000.00, 'WERTGDF'),
('C00019', 'Yearannaidu', 'Chennai', 'Chennai', 'India', 1, 8000.00, 7000.00, 7000.00, 8000.00, 'ZZZZBFV'),
('C00005', 'Sasikant', 'Mumbai', 'Mumbai', 'India', 1, 7000.00, 11000.00, 7000.00, 11000.00, '147-25896312'),
('C00007', 'Ramanathan', 'Chennai', 'Chennai', 'India', 1, 7000.00, 11000.00, 9000.00, 9000.00, 'GHRDWSD'),
('C00022', 'Avinash', 'Mumbai', 'Mumbai', 'India', 2, 7000.00, 11000.00, 9000.00, 9000.00, '113-12345678'),
('C00004', 'Winston', 'Brisbane', 'Brisbane', 'Australia', 1, 5000.00, 8000.00, 7000.00, 6000.00, 'AAAAAAA'),
('C00023', 'Karl', 'London', 'London', 'UK', 0, 4000.00, 6000.00, 7000.00, 3000.00, 'AAAABAA'),
('C00006', 'Shilton', 'Toronto', 'Toronto', 'Canada', 1, 10000.00, 7000.00, 6000.00, 11000.00, 'DDDDDDD'),
('C00010', 'Charles', 'Hampshire', 'Hampshire', 'UK', 3, 6000.00, 4000.00, 5000.00, 5000.00, 'MMMMMMM'),
('C00017', 'Srinivas', 'Bangalore', 'Bangalore', 'India', 2, 8000.00, 4000.00, 3000.00, 9000.00, 'AAAAAAB'),
('C00012', 'Steven', 'San Jose', 'San Jose', 'USA', 1, 5000.00, 7000.00, 9000.00, 3000.00, 'KRFYGJK'),
('C00008', 'Karolina', 'Toronto', 'Toronto', 'Canada', 1, 7000.00, 7000.00, 9000.00, 5000.00, 'HJKORED'),
('C00003', 'Martin', 'Toronto', 'Toronto', 'Canada', 2, 8000.00, 7000.00, 7000.00, 8000.00, 'MJYURFD'),
('C00009', 'Ramesh', 'Mumbai', 'Mumbai', 'India', 3, 8000.00, 7000.00, 3000.00, 12000.00, 'Phone No'),
('C00014', 'Rangarappa', 'Bangalore', 'Bangalore', 'India', 2, 8000.00, 11000.00, 7000.00, 12000.00, 'AAAATGF'),
('C00016', 'Venkatpati', 'Bangalore', 'Bangalore', 'India', 2, 8000.00, 11000.00, 7000.00, 12000.00, 'JRTVFDD'),
('C00011', 'Sundariya', 'Chennai', 'Chennai', 'India', 3, 7000.00, 11000.00, 7000.00, 11000.00, 'PPHGRTS');



SELECT * FROM CUSTOMER


SELECT UPPER(CUST_NAME) FROM CUSTOMER

SELECT LOWER(CUST_NAME) FROM CUSTOMER

SELECT 
    CONCAT(
        UPPER(LEFT(CUST_NAME, 1)),
        LOWER(SUBSTRING(CUST_NAME, 2, LEN(CUST_NAME)))
    ) AS ProperCaseName
FROM CUSTOMER;

--UPPER(LEFT(CUST_NAME, 1)): Converts the first character of the CUST_NAME to uppercase.
--LOWER(SUBSTRING(CUST_NAME, 2, LEN(CUST_NAME))): Converts the rest of the string to lowercase starting from the second character to the end.
--CONCAT(...): Combines the uppercase first letter with the rest of the lowercase string to form the proper case.


-- Using LTRIM to remove leading spaces from the string.
SELECT LTRIM('		AYUSH GINOYA') AS TrimmedName;

SELECT RTRIM('AYUSH GINOYA			');

-- Using the POWER function to calculate the result of raising 2 to the power of 5.
SELECT POWER(2, 5) AS PowerResult;


-- Using the SQRT function to calculate the square root of 25.
SELECT SQRT(25) AS SquareRoot;


-- Using the LEFT function to extract the first two characters of the customer name.
SELECT LEFT(CUST_NAME, 2) AS LeftPart FROM CUSTOMER;


SELECT RIGHT(CUST_NAME,2) FROM CUSTOMER 

-- Using the REPLACE function to replace 'PATEL' with 'GINOYA' in the string 'AYUSH PATEL'.
SELECT REPLACE('AYUSH PATEL', 'PATEL', 'GINOYA') AS ReplacedString;

-- Using the CONCAT function to concatenate strings 'AYUSH', ' ', and 'GINOYA'.
SELECT CONCAT('AYUSH', ' ', 'GINOYA') AS FullName;


-- Using the '+' operator to concatenate strings 'AYUSH', ' ', and 'GINOYA'.
SELECT 'AYUSH' + ' ' + 'GINOYA' AS FullName;
