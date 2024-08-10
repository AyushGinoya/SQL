-- Find the position of the first occurrence of the character 'G' in the string 'AYUSH GINOYA'.
-- The search starts from the 2nd character of the string.
SELECT CHARINDEX('G', 'AYUSH GINOYA', 2);

-- Concatenate the strings 'WWW', 'DDU', 'AC', and 'IN' with a period (.) separator.
-- CONCAT_WS automatically handles NULL values and no need to convert non-string types.
SELECT CONCAT_WS('.', 'WWW', 'DDU', 'AC', 'IN');

-- Concatenate the email prefix 'ayushginoya' and domain 'gmail.com' with an '@' separator.
SELECT CONCAT_WS('@', 'ayushginoya', 'gmail.com');

-- Compare DATALENGTH and LEN functions.
-- DATALENGTH returns the number of bytes used to represent the string (including spaces).
SELECT DATALENGTH('  AYUSH     ');

-- LEN returns the number of characters in the string, excluding trailing spaces.
SELECT LEN('  AYUSH     ');

-- Format the current date in 'dd-MM-yyyy' format.
SELECT FORMAT(GETDATE(), 'dd-MM-yyyy') AS FormattedDate;

-- Format the current date in 'dd.MM.yyyy' format.
SELECT FORMAT(GETDATE(), 'dd.MM.yyyy') AS FormattedDate;

-- Format the current date in 'dd/MM/yyyy' format.
SELECT FORMAT(GETDATE(), 'dd/MM/yyyy') AS FormattedDate;

-- Format the current date in 'dd_MM_yyyy' format.
SELECT FORMAT(GETDATE(), 'dd_MM_yyyy') AS FormattedDate;

-- Format the current date and time in 'dd-MM-yyyy HH:mm:ss' format.
SELECT FORMAT(GETDATE(), 'dd-MM-yyyy HH:mm:ss') AS FormattedDate;

-- Format the current date in 'dd-MMM-yyyy' format, with the month as a three-letter abbreviation.
SELECT FORMAT(GETDATE(), 'dd-MMM-yyyy') AS FormattedDate;

-- Format the current date in 'dd-MMMM-yyyy' format, with the full month name.
SELECT FORMAT(GETDATE(), 'dd-MMMM-yyyy') AS FormattedDate;

-- Format the current date with ordinal suffix ('dd'th' MMMM yyyy').
SELECT FORMAT(GETDATE(), 'dd''th'' MMMM yyyy') AS FormattedDate;

-- Format the current date using the 'd' format pattern for the 'en-US' locale.
SELECT FORMAT(GETDATE(), 'd', 'en-US') AS FormattedDate;

-- Format the current date using the 'd' format pattern for the 'no' (Norwegian) locale.
SELECT FORMAT(GETDATE(), 'd', 'no') AS FormattedDate;

-- Repeat the string ' DDU ' five times.
SELECT REPLICATE(' DDU ', 5);

-- Replace all occurrences of 'IT' with 'U' in the string 'DDIT'.
SELECT REPLACE('DDIT', 'IT', 'U');

-- Replace all occurrences of 'IT' with 'U' in the string 'DDIT DDIT DDIT'.
SELECT REPLACE(' DDIT DDIT DDIT ', 'IT', 'U');

-- Reverse the string 'DDIT'.
SELECT REVERSE('DDIT');

-- Compare STUFF, REPLACE, and SUBSTRING functions.
-- STUFF(string, start, length, new_string)
-- STUFF removes 2 characters from the 3rd position in 'DDIT' and inserts 'U' in their place.
SELECT STUFF('DDIT', 3, 2, 'U');


--STUFF: Combines deletion and insertion in one operation. 
--It modifies a specific part of a string by replacing a specified length with a new string.

--REPLACE: Replaces all instances of a substring with another substring. 
--It doesn't work with positions; instead, it works with matching substrings.

--SUBSTRING: Extracts a portion of a string based on a specified start position and length. 
--It doesn't modify the original string but rather returns a part of it.
