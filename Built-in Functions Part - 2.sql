-- Calculate the square of a number.
SELECT SQUARE(5) AS SQAURE;

-- Extract a substring from the given string 'AYUSH GINOYA'.
-- The substring starts at the 7th character and extracts the next 6 characters.
SELECT SUBSTRING('AYUSH GINOYA', 7, 6);

-- Round the number 1555.545415 to 2 decimal places.
SELECT ROUND(1555.545415, 2);

-- Round the number 1555.545415 to 1 decimal place.
SELECT ROUND(1555.545415, 1);

-- Round the number 1555.545415 to the nearest whole number.
SELECT ROUND(1555.545415, 0);

-- Calculate the natural logarithm of 2 (base e).
SELECT LOG(2);

-- Calculate the logarithm of 2 with base 10.
SELECT LOG10(2);

-- Calculate the exponential of 2 and 5 (e^2 and e^5).
SELECT EXP(2), EXP(5);

-- Return the value of PI (3.141592653589793).
SELECT PI();

-- Return the smallest integer greater than or equal to 111.1222 (ceiling value).
SELECT CEILING(111.1222);

-- Return the largest integer less than or equal to 111.1222 (floor value).
SELECT FLOOR(111.1222);

-- Calculate the sine, cosine, and tangent of 1 radian.
SELECT SIN(1), COS(1), TAN(1);

-- Determine the sign of the given numbers.
-- Returns -1 for negative numbers, 1 for positive numbers, and 0 for zero.
SELECT SIGN(-22), SIGN(22), SIGN(0);

-- Return the length of the string 'AYUSH GINOYA'.
SELECT LEN('AYUSH GINOYA');

-- Return the length of the string '   ABC ' including leading spaces.
SELECT LEN('   ABC ');

-- Return the ASCII code of the character 'a' and 'A'.
SELECT ASCII('a'), ASCII('A');

-- Return the character corresponding to the ASCII code 65 (which is 'A').
SELECT CHAR(65);

-- Retrieve the CUST_CITY and its length from the CUSTOMER table.
-- Only return records where the length of CUST_CITY is greater than 5.
SELECT CUST_CITY, LEN(CUST_CITY) AS LENGTH 
FROM CUSTOMER 
WHERE LEN(CUST_CITY) > 5;

-- Concatenate spaces with the strings 'AYUSH' and 'GINOYA'.
-- SPACE(5) adds 5 spaces before 'AYUSH', and SPACE(2) adds 2 spaces after it.
SELECT SPACE(5) + 'AYUSH' + SPACE(2) + 'GINOYA';

-- Concatenate the CUST_CITY, CUST_NAME, and OPENING_AMT fields into a formatted string.
-- The CUST_CITY is cast to a VARCHAR(30) for consistency, and OPENING_AMT is converted to VARCHAR for concatenation.
SELECT CAST(CUST_CITY AS VARCHAR(30)) + ' WITH OPENING AMOUNT ' + CUST_NAME + ' AMOUNT IS ' + CONVERT(VARCHAR(30), OPENING_AMT)
FROM CUSTOMER;

-- Note: CAST is generally considered faster than CONVERT, though both are used for data type conversions.
