--1. Display the result of 5 multiply by 30. 
SELECT 5 * 30 AS Result;


--2. Find out the absolute value of -25, 25, -50 and 50. 
SELECT ABS(-25) AS Abs1, ABS(25) AS Abs2, ABS(-50) AS Abs3, ABS(50) AS Abs4;

--3. Find smallest integer value that is greater than or equal to 25.2, 25.7 and -25.2. 
SELECT CEILING(25.2) AS Ceiling1, CEILING(25.7) AS Ceiling2, CEILING(-25.2) AS Ceiling3;

--4. Find largest integer value that is smaller than or equal to 25.2, 25.7 and -25.2. 
SELECT FLOOR(25.2) AS Floor1, FLOOR(25.7) AS Floor2, FLOOR(-25.2) AS Floor3;

--5. Find out remainder of 5 divided 2 and 5 divided by 3. 
SELECT 5 % 2 AS Remainder1, 5 % 3 AS Remainder2;

--6. Find out value of 3 raised to 2nd power and 4 raised 3rd power. 
SELECT POWER(3, 2) AS Power1, POWER(4, 3) AS Power2;

--7. Find out the square root of 25, 30 and 50. 
SELECT SQRT(25) AS Sqrt1, SQRT(30) AS Sqrt2, SQRT(50) AS Sqrt3;

--8. Find out the square of 5, 15, and 25. 
SELECT POWER(5, 2) AS Square1, POWER(15, 2) AS Square2, POWER(25, 2) AS Square3;

--9. Find out the value of PI. 
SELECT PI() AS PiValue;

--10. Find out round value of 157.732 for 2, 0 and -2 decimal points. 
SELECT ROUND(157.732, 2) AS Round2, ROUND(157.732, 0) AS Round0, ROUND(157.732, -2) AS RoundNeg2;

--11. Find out exponential value of 2 and 3. 
SELECT EXP(2) AS Exp2, EXP(3) AS Exp3;

--12. Find out logarithm having base b having value 10 of 5 and 100. 
SELECT LOG(5) AS Log5, LOG(100) AS Log100;

--13. Find sine, cosine and tangent of 3.1415. 
SELECT SIN(3.1415) AS Sine, COS(3.1415) AS Cosine, TAN(3.1415) AS Tangent;

--14. Find sign of -25, 0 and 25. 
SELECT SIGN(-25) AS SignNeg, SIGN(0) AS SignZero, SIGN(25) AS SignPos;

--15. Generate random number using function. 
SELECT RAND()*10 AS RandomNumber;