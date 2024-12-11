--4. String Functions 




--1. Find the length of following. (I) NULL    (II) ‘   hello     ’   (III)  Blank 
SELECT 
LEN(NULL) AS Length1, 
LEN('   hello     ') AS Length2, 
LEN('') AS Length3;


--2. Display your name In lower & upper case. 
SELECT 
LOWER('Darshan') AS LowerCaseName,
UPPER('Darshan') AS UpperCaseName;


--3. Display first three characters of your name. 
SELECT LEFT('DDU', 3) AS FirstThreeChars;


--4. Display 3rd to 10th character of your name. 
SELECT SUBSTRING('DDU FACULTY OF TECHNOLOGY', 3, 8) AS MidChars;


--5. Write a query to convert ‘abc123efg’ to ‘abcXYZefg’ & ‘abcabcabc’ to ‘ab5ab5ab5’ using REPLACE. 
SELECT 
REPLACE('abc123efg', '123', 'XYZ') AS Replace1,
REPLACE('abcabcabc', 'C', '5') AS Replace2;


--6. Write a query to display ASCII code for ‘a’,’A’,’z’,’Z’, 0, 9. 
SELECT 
    ASCII('a') AS AsciiA, 
    ASCII('A') AS AsciiUpperA, 
    ASCII('z') AS AsciiZ, 
    ASCII('Z') AS AsciiUpperZ, 
    ASCII('0') AS Ascii0, 
    ASCII('9') AS Ascii9;


--7. Write a query to display character based on number 97, 65,122,90,48,57. 
SELECT 
    CHAR(97) AS Char1, 
    CHAR(65) AS Char2, 
    CHAR(122) AS Char3, 
    CHAR(90) AS Char4, 
    CHAR(48) AS Char5, 
    CHAR(57) AS Char6;


--8. Write a query to remove spaces from left of a given string ‘ hello world' 
SELECT LTRIM('	hello world			') AS TrimmedLeft;


--9. Write a query to remove spaces from right of a given string ‘ 
SELECT RTRIM('		hello world	 ') AS TrimmedRight;


--10. Write a query to display first 4 & Last 5 characters of ‘SQL Server’. 
SELECT 
    LEFT('SQL Server', 4) AS First4Chars, 
    RIGHT('SQL Server', 5) AS Last5Chars;


--11. Write a query to convert a string ‘1234.56’ to number (Use CAST()). 
SELECT CAST('1234.56' AS DECIMAL(10, 2)) AS ConvertedNumber;


--12. Write a query to convert a float 10.58 to integer (Use CONVERT()). 
SELECT CONVERT(INT, 10.58) AS ConvertedInt;


--13. Put 10 space before your name using function. 
SELECT REPLICATE(' ', 10) + 'DDU' AS PaddedName;


--14. Combine two strings (Your name & Surname) using + sign as well as CONCAT (). 
SELECT 
    'Ayush' + ' ' + 'Patel' AS CombinedUsingPlus,
    CONCAT('Ayush', ' ', 'Patel') AS CombinedUsingConcat;


--15. Find reverse of “Darshan”. 
SELECT REVERSE('Darshan') AS ReversedName;


--16. Repeat your name 3 times. 
SELECT REPLICATE('Ayush',3) RepeatedName;


--17. Delete 3 characters from a string, starting in position 1, and then insert "HTML" in position 1. (Use STUFF()) 
SELECT STUFF('WELCOME',1,3,'HTML');


--18. From Data, returns the first non-null value in a list. (Use COALESCE()) 
SELECT COALESCE(NULL, NULL, 'FirstNonNull', 'ThisIsNotNull') AS FirstNonNullValue;


--19. Tests whether the expression is numeric. (Use ISNUMERIC()) 
SELECT 
    ISNUMERIC('1234') AS IsNumeric1, 
    ISNUMERIC('ABC123') AS IsNumeric2,
    ISNUMERIC('123.45') AS IsNumeric3,
    ISNUMERIC('abc') AS IsNumeric4;


--20. Search for "t" in string "Customer", and return its position. (Use CHARINDEX())
SELECT CHARINDEX('t', 'Customer') AS PositionOfT;
