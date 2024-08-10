-- Get the current date and time.
SELECT GETDATE();

-- Add 4 days to the current date and time.
SELECT GETDATE() + 4;

-- Subtract 4 days from the current date and time.
SELECT GETDATE() - 4;

-- Convert the current date and time to a VARCHAR(50).
-- The first part shows the default conversion, while the second part converts it using style 100 (mon dd yyyy hh:miAM (or PM)).
SELECT CONVERT(VARCHAR(50), GETDATE()), CONVERT(VARCHAR(50), GETDATE(), 100);

-- Convert the current date and time using style 101 (mm/dd/yyyy).
SELECT CONVERT(VARCHAR(50), GETDATE()), CONVERT(VARCHAR(50), GETDATE(), 101);

-- Convert the current date and time using style 102 (yyyy.mm.dd).
SELECT CONVERT(VARCHAR(50), GETDATE()), CONVERT(VARCHAR(50), GETDATE(), 102);

-- Convert the current date and time using style 103 (dd/mm/yyyy).
SELECT CONVERT(VARCHAR(50), GETDATE()), CONVERT(VARCHAR(50), GETDATE(), 103);

-- Convert the current date and time using style 104 (dd.mm.yyyy).
SELECT CONVERT(VARCHAR(50), GETDATE()), CONVERT(VARCHAR(50), GETDATE(), 104);

-- Convert the current date and time using style 105 (dd-mm-yyyy).
SELECT CONVERT(VARCHAR(50), GETDATE()), CONVERT(VARCHAR(50), GETDATE(), 105);

-- Convert the current date and time using style 106 (dd mon yyyy).
SELECT CONVERT(VARCHAR(50), GETDATE()), CONVERT(VARCHAR(50), GETDATE(), 106);

-- Get the last day of the current month.
SELECT EOMONTH(GETDATE());

-- Calculate the difference in years between '2022-07-02' and '2023-10-01'.
SELECT DATEDIFF(YEAR, '2022-07-02', '2023-10-01');

-- Calculate the difference in months between '2022-07-02' and '2023-10-01'.
SELECT DATEDIFF(MONTH, '2022-07-02', '2023-10-01');

-- Calculate the difference in days between '2022-07-02' and '2023-10-01'.
SELECT DATEDIFF(DAY, '2022-07-02', '2023-10-01');

-- Calculate the difference in hours between '2022-07-02' and '2023-10-01'.
SELECT DATEDIFF(HOUR, '2022-07-02', '2023-10-01');

-- Add 5 years to the current date and time.
SELECT DATEADD(YEAR, 5, GETDATE());

-- Add 5 months to the current date and time.
SELECT DATEADD(MONTH, 5, GETDATE());

-- Add 5 days to the current date and time.
SELECT DATEADD(DAY, 5, GETDATE());

-- Extract the day, month, and year from the current date.
SELECT DAY(GETDATE()), MONTH(GETDATE()), YEAR(GETDATE());
