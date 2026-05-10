# SQL Row-Level Functions — Complete Notes
> 📘 Complete theory + interview prep based on *Data With Baraa* SQL Course

---

## Table of Contents
1. [What are SQL Functions?](#1-what-are-sql-functions)
2. [Types of SQL Functions](#2-types-of-sql-functions)
3. [Nested Functions](#3-nested-functions)
4. [String Functions](#4-string-functions)
   - [CONCAT](#concat)
   - [UPPER & LOWER](#upper--lower)
   - [TRIM](#trim)
   - [REPLACE](#replace)
   - [LEN](#len)
   - [LEFT & RIGHT](#left--right)
   - [SUBSTRING](#substring)
5. [Numeric Functions](#5-numeric-functions)
   - [ROUND](#round)
6. [Date & Time Functions](#6-date--time-functions)
   - [Date & Time Data Types](#date--time-data-types)
   - [Part Extraction Functions](#part-extraction-functions)
   - [Format & Casting Functions](#format--casting-functions)
   - [Date Calculation Functions](#date-calculation-functions)
   - [Date Validation — ISDATE](#date-validation--isdate)
   - [Date Parts Reference Table](#date-parts-reference-table)
   - [Date & Time Format Specifiers](#date--time-format-specifiers)
   - [Number Format Specifiers](#number-format-specifiers)
   - [CONVERT Date Styles Reference](#convert-date-styles-reference)
7. [NULL Functions](#7-null-functions)
   - [What are NULLs?](#what-are-nulls)
   - [ISNULL](#isnull)
   - [COALESCE](#coalesce)
   - [NULLIF](#nullif)
   - [IS NULL / IS NOT NULL](#is-null--is-not-null)
   - [NULL vs Empty String vs Blank Space](#null-vs-empty-string-vs-blank-space)
   - [JOINs and IS NULL — Anti Joins](#joins-and-is-null--anti-joins)
8. [CASE Statement](#8-case-statement)
   - [Syntax](#case-syntax)
   - [Full Form vs Quick Form](#full-form-vs-quick-form)
   - [How CASE Evaluates — Flow](#how-case-evaluates--flow)
   - [Use Cases](#case-use-cases)
9. [Interview Questions & Answers](#9-interview-questions--answers)
10. [Quick Reference Cheat Sheet](#10-quick-reference-cheat-sheet)

---

## 1. What are SQL Functions?

SQL **functions** are built-in tools that accept input values, process them, and return output values. They are used to **transform**, **clean**, **manipulate**, and **analyze** data directly within your SQL queries.

```
Input Value(s)  →  [ FUNCTION ]  →  Output Value(s)
```

**Examples:**
```sql
-- Single-Row: 'MARIA' → LOWER() → 'maria'
SELECT LOWER('MARIA');   -- Result: maria

-- Multi-Row: 30, 10, 20, 40 → SUM() → 100
SELECT SUM(Sales) FROM Orders;
```

---

## 2. Types of SQL Functions

SQL functions are divided into **two main categories**:

| Type | Also Called | Works On | Example |
|---|---|---|---|
| **Single-Row Functions** | Row-Level Calculations | One row at a time | `LOWER('Maria')` → `'maria'` |
| **Multi-Row Functions** | Aggregations | Multiple rows together | `SUM(30, 10, 20, 40)` → `100` |

### Single-Row Functions (Sub-categories)

```
Single-Row Functions
│
├── String Functions      → CONCAT, UPPER, LOWER, TRIM, REPLACE, LEN, LEFT, RIGHT, SUBSTRING
├── Numeric Functions     → ROUND, ABS, CEILING, FLOOR, etc.
├── Date & Time Functions → DAY, MONTH, YEAR, DATEPART, DATENAME, DATETRUNC, EOMONTH,
│                          FORMAT, CONVERT, CAST, DATEADD, DATEDIFF, ISDATE
└── NULL Functions        → ISNULL, COALESCE, NULLIF, IS NULL, IS NOT NULL
```

### Multi-Row Functions (Sub-categories)

```
Multi-Row Functions
│
├── Aggregate Functions (Basics)  → SUM, COUNT, AVG, MIN, MAX
└── Window Functions (Advanced)   → ROW_NUMBER, RANK, LEAD, LAG, etc.
```

---

## 3. Nested Functions

Functions can be **nested** — where the **output of one function becomes the input of another**. SQL evaluates nested functions from the **innermost** to the **outermost**.

```
'Maria'  →  [LEFT(2)]  →  'Ma'  →  [LOWER()]  →  'ma'
```

**Nested syntax:**
```sql
-- Step 1: LEFT('Maria', 2) → 'Ma'
-- Step 2: LOWER('Ma')      → 'ma'
-- Step 3: LEN('ma')        → 2
SELECT LEN(LOWER(LEFT('Maria', 2)));
```

**Evaluation order:**
```
LEN ( LOWER ( LEFT('Maria', 2) ) )
              └──── ① ─────┘
         └────────── ② ──────────┘
└─────────────────── ③ ─────────────┘
```

> ⚠️ Always read nested functions **inside-out** — the innermost function runs first.

---

## 4. String Functions

String functions allow you to **manipulate**, **calculate**, and **extract** parts of text values.

| Category | Functions |
|---|---|
| **Manipulation** | CONCAT, UPPER, LOWER, TRIM, REPLACE |
| **Calculation** | LEN |
| **String Extraction** | LEFT, RIGHT, SUBSTRING |

---

### CONCAT

**Definition:** Combines (concatenates) multiple strings into a single string.

```sql
-- Syntax
CONCAT(value1, value2, value3, ...)

-- Example: Combine first and last name
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employees;
-- 'Michael' + ' ' + 'Scott' → 'Michael Scott'
```

**Behavior with NULL:**
```sql
SELECT CONCAT('Hello', NULL, ' World');
-- Result: 'Hello World'
-- CONCAT ignores NULLs (treats them as empty string)
```

**Alternative — + operator (SQL Server):**
```sql
-- Using + concatenation (does NOT ignore NULL)
SELECT FirstName + ' ' + LastName FROM Employees;
-- If LastName is NULL → result is NULL (entire expression becomes NULL)
```

> ✅ Use `CONCAT()` instead of `+` to safely handle NULL values in string joining.

---

### UPPER & LOWER

**Definition:**
- `UPPER()` — Converts all characters to **UPPERCASE**
- `LOWER()` — Converts all characters to **lowercase**

```sql
-- Syntax
UPPER(value)
LOWER(value)

-- Examples
SELECT UPPER('Maria');   -- Result: MARIA
SELECT UPPER('maria');   -- Result: MARIA
SELECT UPPER('MARIA');   -- Result: MARIA (no change)

SELECT LOWER('Maria');   -- Result: maria
SELECT LOWER('MARIA');   -- Result: maria
SELECT LOWER('maria');   -- Result: maria (no change)
```

**Practical use — case-insensitive search:**
```sql
-- Find players named 'john' regardless of how it was stored
SELECT * FROM Players
WHERE LOWER(Name) = 'john';
-- Matches: John, JOHN, john, jOHN
```

---

### TRIM

**Definition:** Removes **leading** (front) and **trailing** (end) spaces from a string. Does NOT remove spaces in the middle.

```sql
-- Syntax
TRIM(value)

-- Examples
SELECT TRIM('John');          -- 'John'   → 'John'
SELECT TRIM('   John');       -- '   John' → 'John'
SELECT TRIM('John   ');       -- 'John   ' → 'John'
SELECT TRIM('   John   ');    -- '   John   ' → 'John'
SELECT TRIM('   John   ');    -- Multiple spaces → 'John'
```

**Variants (SQL Server / other databases):**
```sql
LTRIM(value)   -- Remove leading (left) spaces only
RTRIM(value)   -- Remove trailing (right) spaces only
TRIM(value)    -- Remove both leading and trailing
```

**Common use case — cleaning dirty data:**
```sql
-- Fix names that were entered with extra spaces
SELECT TRIM(CustomerName) AS CleanName FROM Customers;
```

> ⚠️ `TRIM()` does NOT remove spaces between words: `'John   Smith'` → `'John   Smith'` (middle spaces stay)

---

### REPLACE

**Definition:** Replaces every occurrence of a specific substring with a new value. Can also be used to **remove** characters by replacing with an empty string `''`.

```sql
-- Syntax
REPLACE(value, old_value, new_value)

-- Example 1: Replace dashes with nothing (remove dashes)
SELECT REPLACE('123-456-7890', '-', '');
-- Result: '1234567890'

-- Example 2: Replace a word
SELECT REPLACE('I love SQL Server', 'SQL Server', 'PostgreSQL');
-- Result: 'I love PostgreSQL'

-- Example 3: Remove spaces
SELECT REPLACE('John Smith', ' ', '');
-- Result: 'JohnSmith'
```

**Key point — REPLACE can REMOVE:**
```sql
-- Setting new_value = '' effectively deletes old_value
REPLACE(PhoneNumber, '-', '')   -- '123-456-7890' → '1234567890'
REPLACE(ProductCode, 'PRD', '') -- 'PRD001' → '001'
```

---

### LEN

**Definition:** Returns the **number of characters** in a string (including spaces, excluding trailing spaces in SQL Server).

```sql
-- Syntax
LEN(value)

-- Examples
SELECT LEN('Maria');        -- Result: 5 (M-a-r-i-a)
SELECT LEN(350);            -- Result: 3 (3-5-0 as string)
SELECT LEN('2026-01-23');   -- Result: 10 (2-0-2-6---0-1---2-3)
SELECT LEN('');             -- Result: 0
SELECT LEN(NULL);           -- Result: NULL
```

**Use with SUBSTRING for dynamic extraction:**
```sql
-- Extract everything after the first 2 characters dynamically
SELECT SUBSTRING(Name, 3, LEN(Name))
FROM Players;
```

---

### LEFT & RIGHT

**Definition:**
- `LEFT()` — Extracts a specified number of characters from the **start** (left side)
- `RIGHT()` — Extracts a specified number of characters from the **end** (right side)

```sql
-- Syntax
LEFT(value, number_of_characters)
RIGHT(value, number_of_characters)

-- Example with 'Maria' (5 characters: M-a-r-i-a)
SELECT LEFT('Maria', 2);    -- Result: 'Ma'   (first 2 chars)
SELECT RIGHT('Maria', 2);   -- Result: 'ia'   (last 2 chars)
SELECT LEFT('Maria', 1);    -- Result: 'M'
SELECT RIGHT('Maria', 3);   -- Result: 'ria'
```

**Practical examples:**
```sql
-- Get country code (first 2 characters of phone number)
SELECT LEFT(PhoneNumber, 2) AS CountryCode FROM Customers;

-- Get file extension (last 3 characters)
SELECT RIGHT(FileName, 3) AS Extension FROM Files;

-- Get year from a date string 'YYYY-MM-DD'
SELECT LEFT(OrderDate, 4) AS OrderYear FROM Orders;
```

**Comparison: LEFT vs RIGHT on 'Maria':**

| Function | Extract | Result |
|---|---|---|
| `LEFT('Maria', 1)` | First 1 char | `M` |
| `LEFT('Maria', 2)` | First 2 chars | `Ma` |
| `RIGHT('Maria', 1)` | Last 1 char | `a` |
| `RIGHT('Maria', 2)` | Last 2 chars | `ia` |

---

### SUBSTRING

**Definition:** Extracts a portion of a string starting at a **specific position**, for a **specified length**.

```sql
-- Syntax
SUBSTRING(value, start_position, length)
```

> **Important:** Position counting starts at **1** (not 0) in SQL.

```sql
-- 'Maria' → M(1) a(2) r(3) i(4) a(5)

SELECT SUBSTRING('Maria', 1, 3);   -- Result: 'Mar'  (start at 1, take 3)
SELECT SUBSTRING('Maria', 3, 3);   -- Result: 'ria'  (start at 3, take 3)
SELECT SUBSTRING('Maria', 2, 2);   -- Result: 'ar'   (start at 2, take 2)

-- 'Martin' → M(1) a(2) r(3) t(4) i(5) n(6)
SELECT SUBSTRING('Martin', 3, 4);  -- Result: 'rtin' (start at 3, take 4)
```

**Dynamic extraction (use LEN for the length):**
```sql
-- Extract everything from position 3 to the end (dynamic length)
SELECT SUBSTRING(Name, 3, LEN(Name)) FROM Players;
-- 'Maria'  → starts at 3 → 'ria'
-- 'Martin' → starts at 3 → 'rtin'
```

**LEFT vs RIGHT vs SUBSTRING comparison:**

| Goal | Function | Example | Result |
|---|---|---|---|
| First N chars | `LEFT` | `LEFT('Maria', 3)` | `Mar` |
| Last N chars | `RIGHT` | `RIGHT('Maria', 3)` | `ria` |
| Middle section | `SUBSTRING` | `SUBSTRING('Maria', 2, 3)` | `ari` |
| From position to end | `SUBSTRING` + `LEN` | `SUBSTRING('Maria', 3, LEN('Maria'))` | `ria` |

---

## 5. Numeric Functions

### ROUND

**Definition:** Rounds a numeric value to a specified number of decimal places.

```sql
-- Syntax
ROUND(value, decimal_places)
```

**How rounding works:**
- If the digit after the rounding position is **≥ 5** → **round up**
- If the digit after the rounding position is **< 5** → **keep** (round down)

```sql
-- Example: 3.516

SELECT ROUND(3.516, 2);   -- Result: 3.52  (3rd decimal is 6 ≥ 5 → round up 2nd decimal)
SELECT ROUND(3.516, 1);   -- Result: 3.5   (2nd decimal is 1 < 5 → keep 1st decimal)
SELECT ROUND(3.516, 0);   -- Result: 4.0   (1st decimal is 5 ≥ 5 → round up integer)
```

**Rounding to negative positions (round left of decimal):**
```sql
SELECT ROUND(1234.56, -1);  -- Result: 1230  (round to nearest 10)
SELECT ROUND(1234.56, -2);  -- Result: 1200  (round to nearest 100)
```

**Visual breakdown for 3.516:**

| Function | Looks At | Decision | Result |
|---|---|---|---|
| `ROUND(3.516, 2)` | 3rd decimal = 6 | 6 ≥ 5 → round up 2nd | `3.52` |
| `ROUND(3.516, 1)` | 2nd decimal = 1 | 1 < 5 → keep 1st | `3.5` |
| `ROUND(3.516, 0)` | 1st decimal = 5 | 5 ≥ 5 → round up integer | `4` |

**Other numeric functions:**
```sql
SELECT ABS(-45);          -- Result: 45    (absolute value, removes negative sign)
SELECT CEILING(4.1);      -- Result: 5     (always rounds UP to next integer)
SELECT FLOOR(4.9);        -- Result: 4     (always rounds DOWN to previous integer)
SELECT POWER(2, 10);      -- Result: 1024  (2 to the power of 10)
SELECT SQRT(144);         -- Result: 12    (square root)
SELECT MOD(10, 3);        -- Result: 1     (remainder after division)
```

---

## 6. Date & Time Functions

Date & Time functions are split into **four categories**:

| Category | Functions | Purpose |
|---|---|---|
| **Part Extraction** | DAY, MONTH, YEAR, DATEPART, DATENAME, DATETRUNC, EOMONTH | Pull specific parts out of a date |
| **Format & Casting** | FORMAT, CONVERT, CAST | Change how a date looks or its data type |
| **Calculations** | DATEADD, DATEDIFF | Add/subtract time or measure difference |
| **Validation** | ISDATE | Check if a value is a valid date |

---

### Date & Time Data Types

Dates in SQL are stored in standardized formats:

```
Date:      YYYY-MM-DD          e.g. 2025-08-20
Time:      HH:MM:SS            e.g. 18:55:45
Datetime:  YYYY-MM-DD HH:MM:SS e.g. 2025-08-20 18:55:45
```

| Data Type | Used In | Description |
|---|---|---|
| `DATE` | All databases | Date only (year, month, day) |
| `TIME` | All databases | Time only (hours, minutes, seconds) |
| `DATETIME2` | SQL Server | Combined date and time |
| `TIMESTAMP` | Oracle, PostgreSQL, MySQL | Combined date and time |

---

### Part Extraction Functions

#### YEAR, MONTH, DAY (Quick Functions)

These are shorthand functions that extract the most common date parts as **integers**.

```sql
-- Syntax
YEAR(date)
MONTH(date)
DAY(date)

-- Example with '2025-08-20'
SELECT YEAR('2025-08-20');    -- Result: 2025
SELECT MONTH('2025-08-20');   -- Result: 8
SELECT DAY('2025-08-20');     -- Result: 20

-- Practical use
SELECT YEAR(OrderDate) AS OrderYear FROM Orders;
SELECT MONTH(OrderDate) AS OrderMonth FROM Orders;
```

#### DATEPART

**Definition:** Extracts any part of a date as an **integer (INT)**. More flexible than YEAR/MONTH/DAY — supports week, quarter, hour, minute, second, etc.

```sql
-- Syntax
DATEPART(part, date)

-- Examples with '2025-08-20 09:38:54'
SELECT DATEPART(year, '2025-08-20');      -- Result: 2025
SELECT DATEPART(month, '2025-08-20');     -- Result: 8
SELECT DATEPART(day, '2025-08-20');       -- Result: 20
SELECT DATEPART(quarter, '2025-08-20');   -- Result: 3  (Q3 = July-September)
SELECT DATEPART(week, '2025-08-20');      -- Result: 34 (34th week of the year)
SELECT DATEPART(weekday, '2025-08-20');   -- Result: 4  (Wednesday = 4)
SELECT DATEPART(hour, '2025-08-20 09:38:54');   -- Result: 9
SELECT DATEPART(minute, '2025-08-20 09:38:54'); -- Result: 38
SELECT DATEPART(second, '2025-08-20 09:38:54'); -- Result: 54
```

#### DATENAME

**Definition:** Extracts a date part as a **string (VARCHAR)**. Useful for getting full month names or day names.

```sql
-- Syntax
DATENAME(part, date)

-- Examples with '2025-08-20'
SELECT DATENAME(month, '2025-08-20');    -- Result: 'August'    (string!)
SELECT DATENAME(weekday, '2025-08-20'); -- Result: 'Wednesday'
SELECT DATENAME(year, '2025-08-20');    -- Result: '2025'       (still a string)
SELECT DATENAME(quarter, '2025-08-20'); -- Result: '3'          (string '3', not int 3)
```

**DATEPART vs DATENAME:**

| Function | Output Type | month example | weekday example |
|---|---|---|---|
| `DATEPART(month, date)` | INT | `8` | `4` |
| `DATENAME(month, date)` | STRING | `'August'` | `'Wednesday'` |

#### DATETRUNC

**Definition:** Truncates a date to a specific precision — **keeps** everything up to the specified part, and **resets** everything below it to its minimum value.

```sql
-- Syntax
DATETRUNC(part, date)

-- Example with '2025-08-20 18:55:45'
SELECT DATETRUNC(minute, '2025-08-20 18:55:45');
-- Result: 2025-08-20 18:55:00  (seconds reset to 00)

SELECT DATETRUNC(hour, '2025-08-20 18:55:45');
-- Result: 2025-08-20 18:00:00  (minutes & seconds reset to 00)

SELECT DATETRUNC(day, '2025-08-20 18:55:45');
-- Result: 2025-08-20 00:00:00  (time part fully reset)

SELECT DATETRUNC(month, '2025-08-20 18:55:45');
-- Result: 2025-08-01 00:00:00  (day resets to 01, time resets to 00)

SELECT DATETRUNC(year, '2025-08-20 18:55:45');
-- Result: 2025-01-01 00:00:00  (month→01, day→01, time→00)
```

**DATETRUNC reset rules:**
- Date part resets to **01** (month, day)
- Time part resets to **00** (hours, minutes, seconds)

**Common use — group data by month:**
```sql
-- Sales report grouped by month start
SELECT DATETRUNC(month, OrderDate) AS MonthStart,
       SUM(Sales) AS TotalSales
FROM Orders
GROUP BY DATETRUNC(month, OrderDate);
```

#### EOMONTH

**Definition:** Returns the **last day** of the month for a given date. Automatically handles months with different lengths (28, 29, 30, 31 days).

```sql
-- Syntax
EOMONTH(date)
EOMONTH(date, months_to_add)   -- optional: offset by N months

-- Examples
SELECT EOMONTH('2025-08-20');   -- Result: 2025-08-31 (August has 31 days)
SELECT EOMONTH('2025-02-10');   -- Result: 2025-02-28 (Feb 2025 has 28 days)
SELECT EOMONTH('2024-02-10');   -- Result: 2024-02-29 (Feb 2024 is a leap year!)
SELECT EOMONTH('2025-03-01');   -- Result: 2025-03-31

-- Get last day of next month
SELECT EOMONTH('2025-08-20', 1);  -- Result: 2025-09-30
-- Get last day of previous month
SELECT EOMONTH('2025-08-20', -1); -- Result: 2025-07-31
```

**Part Extraction — Syntax Summary:**

| Function | Syntax | Returns |
|---|---|---|
| `DAY` | `DAY(date)` | INT |
| `MONTH` | `MONTH(date)` | INT |
| `YEAR` | `YEAR(date)` | INT |
| `EOMONTH` | `EOMONTH(date)` | DATE |
| `DATEPART` | `DATEPART(part, date)` | INT |
| `DATENAME` | `DATENAME(part, date)` | STRING |
| `DATETRUNC` | `DATETRUNC(part, date)` | DATETIME |

**Return data types:**

| Functions | Returns |
|---|---|
| DAY, MONTH, YEAR, DATEPART | INT |
| DATENAME | STRING |
| DATETRUNC | DATETIME |
| EOMONTH | DATE |

---

### How to Choose the Right Extraction Function?

```
Which part do you need?
│
├── Day or Month (as number)?     → DAY() / MONTH()
├── Day or Month (as full name)?  → DATENAME()
├── Year?                         → YEAR()
└── Other parts (week, quarter, hour...)? → DATEPART()
```

---

### Format & Casting Functions

#### Date Formats & Standards

SQL Server's default date format follows the **ISO 8601 International Standard**:

| Standard | Format | Example |
|---|---|---|
| **International (ISO 8601)** | `YYYY-MM-DD` | `2025-08-20` |
| **USA Standard** | `MM-DD-YYYY` | `08-20-2025` |
| **European Standard** | `DD-MM-YYYY` | `20-08-2025` |

#### FORMAT

**Definition:** Converts a date or number to a **string** using a format pattern you specify.

```sql
-- Syntax
FORMAT(value, format [, culture])
-- culture is OPTIONAL; default is 'en-US'

-- Date examples
SELECT FORMAT(OrderDate, 'MM/dd/yyyy');         -- '08/20/2025'
SELECT FORMAT(OrderDate, 'dd/MM/yyyy');         -- '20/08/2025'
SELECT FORMAT(OrderDate, 'MMM yyyy');           -- 'Aug 2025'
SELECT FORMAT(OrderDate, 'MMMM dd, yyyy');      -- 'August 20, 2025'
SELECT FORMAT(OrderDate, 'yyyy-MM-dd');         -- '2025-08-20'

-- With culture (locale)
SELECT FORMAT(OrderDate, 'dd/MM/yyyy', 'ja-JP');  -- Japanese locale

-- Number examples
SELECT FORMAT(1234567.89, 'N');    -- '1,234,567.89'  (numeric with commas)
SELECT FORMAT(1234567.89, 'C');    -- '$1,234,567.89' (currency)
SELECT FORMAT(1234567.89, 'P');    -- '123,456,789.00 %' (percentage)
```

#### CONVERT

**Definition:** Converts a value from one data type to another, with an optional **style number** for date formatting.

```sql
-- Syntax
CONVERT(data_type, value [, style])
-- style is OPTIONAL; default style = 0

-- Type conversion examples
SELECT CONVERT(INT, '124');                     -- '124' (string) → 124 (int)
SELECT CONVERT(VARCHAR, 42);                    -- 42 (int) → '42' (string)

-- Date formatting with style number
SELECT CONVERT(VARCHAR, OrderDate, 6);          -- '20 Aug 25'
SELECT CONVERT(VARCHAR, OrderDate, 112);        -- '20250820'
SELECT CONVERT(VARCHAR, OrderDate, 101);        -- '08/20/2025' (USA)
SELECT CONVERT(VARCHAR, OrderDate, 103);        -- '20/08/2025' (British/French)
SELECT CONVERT(VARCHAR, OrderDate, 120);        -- '2025-08-20 00:38:54'
```

#### CAST

**Definition:** Converts a value from one data type to another. Similar to CONVERT but **no formatting options** — strictly for type conversion.

```sql
-- Syntax
CAST(value AS data_type)

-- Examples
SELECT CAST('123' AS INT);               -- '123' (string) → 123 (int)
SELECT CAST('2025-08-20' AS DATE);       -- string → date
SELECT CAST(OrderDate AS VARCHAR);       -- date → string (default format)
SELECT CAST(3.14 AS INT);               -- 3.14 → 3 (truncates decimal)
SELECT CAST('3.14' AS DECIMAL(5,2));    -- '3.14' → 3.14
```

**CAST vs CONVERT vs FORMAT comparison:**

| Function | Casting | Formatting | Output | Use When |
|---|---|---|---|---|
| `CAST` | ✅ Any type to any type | ❌ No formatting | Any type | Simple type conversion |
| `CONVERT` | ✅ Any type to any type | ✅ Date & Time only | Any type | Date formatting with style codes |
| `FORMAT` | ✅ Any type to string only | ✅ Date & Time + Numbers | String only | Custom readable formatting |

---

### Date Calculation Functions

#### DATEADD

**Definition:** Adds (or subtracts with negative values) a specified interval to a date.

```sql
-- Syntax
DATEADD(part, interval, date)

-- Add 2 years
SELECT DATEADD(year, 2, '2025-08-20');     -- Result: 2027-08-20
-- Subtract 3 years
SELECT DATEADD(year, -3, '2025-08-20');    -- Result: 2022-08-20

-- Add 2 months
SELECT DATEADD(month, 2, '2025-08-20');    -- Result: 2025-10-20
-- Subtract 2 months
SELECT DATEADD(month, -2, '2025-08-20');   -- Result: 2025-06-20

-- Add 5 days
SELECT DATEADD(day, 5, '2025-08-20');      -- Result: 2025-08-25
-- Subtract 5 days
SELECT DATEADD(day, -5, '2025-08-20');     -- Result: 2025-08-15

-- Practical: Find orders from the last 30 days
SELECT * FROM Orders
WHERE OrderDate >= DATEADD(day, -30, GETDATE());
```

#### DATEDIFF

**Definition:** Returns the **difference** between two dates in the specified unit. Formula: `end_date - start_date`.

```sql
-- Syntax
DATEDIFF(part, start_date, end_date)

-- Examples: from '2025-08-20' to '2026-02-01'
SELECT DATEDIFF(year, '2025-08-20', '2026-02-01');    -- Result: 1  (1 year boundary crossed)
SELECT DATEDIFF(month, '2025-08-20', '2026-02-01');   -- Result: 6  (6 months)
SELECT DATEDIFF(day, '2025-08-20', '2026-02-01');     -- Result: 165 (165 days)

-- Practical examples
-- How many days since order was placed?
SELECT DATEDIFF(day, OrderDate, GETDATE()) AS DaysSinceOrder FROM Orders;

-- Customer age in years
SELECT DATEDIFF(year, BirthDate, GETDATE()) AS Age FROM Customers;

-- Shipping time in days
SELECT DATEDIFF(day, OrderDate, ShipDate) AS ShippingDays FROM Orders;
```

> ⚠️ `DATEDIFF` counts the number of **boundaries crossed**, not the exact time elapsed. For example, `DATEDIFF(year, '2025-12-31', '2026-01-01')` = 1, even though only 1 day apart.

---

### Date Validation — ISDATE

**Definition:** Returns `1` (TRUE) if the value is a valid date, `0` (FALSE) otherwise.

```sql
-- Syntax
ISDATE(value)

-- Examples
SELECT ISDATE('2025-08-20');   -- Result: 1 (valid date)
SELECT ISDATE('2025-13-45');   -- Result: 0 (invalid: month 13, day 45)
SELECT ISDATE(2025);           -- Result: 0 (integer, not a date)
SELECT ISDATE('hello');        -- Result: 0 (not a date)
SELECT ISDATE('08/20/2025');   -- Result: 1 (valid US date format)

-- Practical: Filter out invalid dates before processing
SELECT * FROM ImportedData
WHERE ISDATE(DateColumn) = 1;
```

---

### Date Parts Reference Table

The following table shows the same date `2025-08-20 09:38:54.840` processed by different functions:

| Part | Abbreviation | DATEPART (INT) | DATENAME (STRING) | DATETRUNC (DATETIME) |
|---|---|---|---|---|
| year | yy, yyyy | 2025 | '2025' | 2025-01-01 00:00:00 |
| quarter | qq, q | 3 | '3' | 2025-07-01 00:00:00 |
| month | mm, m | 8 | 'August' | 2025-08-01 00:00:00 |
| dayofyear | dy, y | 232 | '232' | 2025-08-20 00:00:00 |
| day | dd, d | 20 | '20' | 2025-08-20 00:00:00 |
| week | wk, ww | 34 | '34' | 2025-08-17 00:00:00 |
| weekday | dw | 4 | 'Wednesday' | Not supported |
| hour | hh | 9 | '9' | 2025-08-20 09:00:00 |
| minute | mi, n | 38 | '38' | 2025-08-20 09:38:00 |
| second | ss, s | 54 | '54' | 2025-08-20 09:38:54 |
| millisecond | ms | 840 | '840' | 2025-08-20 09:38:54 |
| iso_week | isowk, isoww | 34 | '34' | 2025-08-18 00:00:00 |

---

### Date & Time Format Specifiers

Used with `FORMAT()` function:

| Specifier | Description | Result (from 2025-08-20 18:55:45) |
|---|---|---|
| `d` | Day of the month | `8/20/2025` |
| `dd` | Day of the month (two-digit) | `20` |
| `ddd` | Abbreviated day name | `Wed` |
| `dddd` | Full day name | `Wednesday` |
| `M` | Month number | (numeric) |
| `MM` | Month number (two-digit) | `08` |
| `MMM` | Abbreviated month name | `Aug` |
| `MMMM` | Full month name | `August` |
| `yy` | Year (two-digit) | `25` |
| `yyyy` | Year (four-digit) | `2025` |
| `hh` | Hour (12-hour, two-digit) | `06` |
| `HH` | Hour (24-hour, two-digit) | `18` |
| `mm` | Minutes (two-digit) | `55` |
| `ss` | Seconds (two-digit) | `45` |
| `tt` | AM/PM designator | `PM` |

---

### Number Format Specifiers

Used with `FORMAT()` for numeric values:

| Specifier | Description | Query | Result |
|---|---|---|---|
| `N` | Numeric (with commas) | `FORMAT(1234.56, 'N')` | `1,234.56` |
| `N0` | Numeric, no decimals | `FORMAT(1234.56, 'N0')` | `1,235` |
| `N1` | Numeric, 1 decimal | `FORMAT(1234.56, 'N1')` | `1,234.6` |
| `N2` | Numeric, 2 decimals | `FORMAT(1234.56, 'N2')` | `1,234.56` |
| `C` | Currency | `FORMAT(1234.56, 'C')` | `$1,234.56` |
| `P` | Percentage | `FORMAT(1234.56, 'P')` | `123,456.00 %` |
| `E` | Scientific notation | `FORMAT(1234.56, 'E')` | `1.23E+09` |
| `F` | Fixed-point | `FORMAT(1234.56, 'F')` | `1234.56` |

**With culture/locale:**
```sql
SELECT FORMAT(1234.56, 'N', 'de-DE');    -- '1.234,56'  (German format)
SELECT FORMAT(1234.56, 'N', 'en-US');    -- '1,234.56'  (US format)
SELECT FORMAT(1234.56, 'C', 'fr-FR');    -- '1 234,56 €' (French currency)
```

---

### CONVERT Date Styles Reference

Key style codes for `CONVERT(VARCHAR, date, style)`:

| Style | Format | Example |
|---|---|---|
| `1` | `mm/dd/yy` | `12/30/25` |
| `3` | `dd/mm/yy` | `30/12/25` |
| `6` | `dd Mon yy` | `30 Dec 25` |
| `7` | `Mon dd, yy` | `Dec 30, 25` |
| `101` | `mm/dd/yyyy` | `12/30/2025` |
| `103` | `dd/mm/yyyy` | `30/12/2025` |
| `104` | `dd.mm.yyyy` | `30.12.2025` |
| `106` | `dd Mon yyyy` | `30 Dec 2025` |
| `107` | `Mon dd, yyyy` | `Dec 30, 2025` |
| `110` | `mm-dd-yyyy` | `12-30-2025` |
| `111` | `yyyy/mm/dd` | `2025/12/30` |
| `112` | `yyyymmdd` | `20251230` |
| `120` | `yyyy-mm-dd hh:mm:ss` | `2025-12-30 00:38:54` |
| `121` | `yyyy-mm-dd hh:mm:ss.nnn` | `2025-12-30 00:38:54.840` |
| `126` | `yyyy-mm-ddThh:mm:ss.nnn` | `2025-12-30T00:38:54.840` |

---

## 7. NULL Functions

### What are NULLs?

**NULL** in SQL means **unknown information** — it is NOT zero, NOT an empty string, NOT a space. It represents the absence of a value.

```
| ID | Name  | Country | Score |
|----|-------|---------|-------|
| 1  | Maria | NULL    | 300   |  ← Country unknown
| 2  | NULL  | DE      | NULL  |  ← Name and Score unknown
| 3  | John  | NULL    | 800   |  ← Country unknown
```

**Where NULLs come from:**
- Optional fields in forms (e.g., "Middle Name" left blank → stored as NULL)
- Data not yet entered
- LEFT/RIGHT JOINs (unmatched rows produce NULLs)
- Calculations involving NULL (`NULL + 5 = NULL`)

---

### ISNULL

**Definition:** Replaces NULL with a specified replacement value. Limited to **two values** (check + replacement). Faster than COALESCE. Available in SQL Server (other databases use NVL or IFNULL).

```sql
-- Syntax
ISNULL(value, replacement)

-- How it works:
-- If value IS NULL     → return replacement
-- If value IS NOT NULL → return value

-- Example 1: Replace NULL with a literal string
SELECT ISNULL(ShippingAddress, 'N/A') FROM Orders;
-- OrderID 1: ShippingAddress = 'A'    → 'A'
-- OrderID 2: ShippingAddress = NULL   → 'N/A'

-- Example 2: Replace NULL with another column's value
SELECT ISNULL(ShippingAddress, BillingAddress) FROM Orders;
-- OrderID 1: ShippingAddress = 'A'    → 'A'
-- OrderID 2: ShippingAddress = NULL   → BillingAddress value
-- OrderID 3: Both NULL               → NULL (nothing to fall back to)
```

**Database equivalents:**

| Database | Function |
|---|---|
| SQL Server | `ISNULL(value, replacement)` |
| Oracle | `NVL(value, replacement)` |
| MySQL | `IFNULL(value, replacement)` |
| All | `COALESCE(value, replacement)` |

---

### COALESCE

**Definition:** Returns the **first non-NULL value** from a list of expressions. Works across **all databases** (ANSI standard). Supports **unlimited** arguments.

```sql
-- Syntax
COALESCE(value1, value2, value3, ...)

-- Two-argument (same as ISNULL)
SELECT COALESCE(ShippingAddress, BillingAddress) FROM Orders;

-- Three-argument (fallback chain)
SELECT COALESCE(ShippingAddress, BillingAddress, 'N/A') FROM Orders;
-- OrderID 1: ShippingAddress = 'A'    → 'A'
-- OrderID 2: ShippingAddress = NULL, BillingAddress = 'C'  → 'C'
-- OrderID 3: ShippingAddress = NULL, BillingAddress = NULL → 'N/A'
```

**Flow logic for `COALESCE(v1, v2, v3)`:**
```
Is v1 NULL? → No  → return v1
             → Yes → Is v2 NULL? → No  → return v2
                                → Yes → return v3
```

**ISNULL vs COALESCE:**

| Feature | ISNULL | COALESCE |
|---|---|---|
| Number of arguments | Limited to 2 | Unlimited |
| Performance | Faster | Slightly slower |
| Portability | SQL Server / DB-specific | All databases (ANSI standard) |
| Use case | Simple single fallback | Multiple fallbacks |

---

### NULLIF

**Definition:** Returns `NULL` if both values are **equal**; otherwise returns the **first value**. Useful for preventing division-by-zero errors.

```sql
-- Syntax
NULLIF(value1, value2)

-- How it works:
-- If value1 = value2 → return NULL
-- If value1 ≠ value2 → return value1

-- Example: Flag identical prices as NULL (no discount applied)
SELECT NULLIF(Original_Price, Discount_Price) FROM Orders;
-- OrderID 1: 150 ≠ 50   → 150  (original price returned)
-- OrderID 2: 250 = 250  → NULL (same price, so NULL)

-- Classic use: Prevent division by zero
SELECT Sales / NULLIF(Units, 0) AS AvgSalePerUnit FROM Products;
-- If Units = 0 → NULLIF returns NULL → division becomes NULL (no error)
-- If Units ≠ 0 → NULLIF returns Units → normal division
```

---

### IS NULL / IS NOT NULL

**Definition:** Used in `WHERE` clauses to **check** whether a value is NULL or not NULL.

> ⚠️ You **CANNOT** use `= NULL` or `<> NULL` — these always return no results because NULL cannot be compared with `=`.

```sql
-- ❌ WRONG — never returns rows
WHERE Score = NULL
WHERE Score <> NULL

-- ✅ CORRECT
WHERE Score IS NULL       -- rows where Score has no value
WHERE Score IS NOT NULL   -- rows where Score has a value

-- Examples
SELECT * FROM Players WHERE Score IS NULL;
SELECT * FROM Players WHERE Country IS NOT NULL;

-- Combined with other conditions
SELECT * FROM Orders
WHERE ShippingAddress IS NULL AND Status = 'Pending';
```

**Proof that `= NULL` fails:**

| ID | Sales | `WHERE Sales = NULL` | `WHERE Sales IS NULL` |
|---|---|---|---|
| 1 | 100 | ❌ No match | ❌ No match |
| 2 | 200 | ❌ No match | ❌ No match |
| 3 | NULL | ❌ No match (wrong!) | ✅ Match (correct!) |

---

### NULL vs Empty String vs Blank Space

| Property | NULL | Empty String `''` | Blank Space `' '` |
|---|---|---|---|
| **Meaning** | Unknown / missing | Known, but no content | Known, has a space character |
| **Data Type** | Special marker | String (length 0) | String (length ≥ 1) |
| **Storage** | Very minimal | Occupies memory | Occupies memory (per space) |
| **Performance** | Best | Fast | Slow |
| **How to check** | `IS NULL` | `= ''` | `= ' '` |
| **LEN()** | NULL | 0 | 1+ |

```sql
-- Checking each type
WHERE Column IS NULL          -- for NULL
WHERE Column = ''             -- for empty string
WHERE Column = ' '            -- for single space
WHERE TRIM(Column) = ''       -- for blank/whitespace-only
```

---

### JOINs and IS NULL — Anti Joins

`IS NULL` combined with JOINs creates powerful **anti-join** patterns:

| Join Type | Description |
|---|---|
| **INNER JOIN** | Only matching rows from both tables |
| **LEFT JOIN** | All rows from left + matching rows from right |
| **RIGHT JOIN** | All rows from right + matching rows from left |
| **FULL JOIN** | All rows from both tables |
| **LEFT ANTI JOIN** | All rows from LEFT that have NO match on the right (LEFT JOIN + IS NULL) |
| **RIGHT ANTI JOIN** | All rows from RIGHT that have NO match on the left (RIGHT JOIN + IS NULL) |

```sql
-- LEFT ANTI JOIN: Find customers who have NEVER placed an order
SELECT c.CustomerID, c.Name
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

-- RIGHT ANTI JOIN: Find orders with no matching customer
SELECT o.OrderID
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;
```

---

## 8. CASE Statement

The `CASE` statement evaluates a **list of conditions** and returns a value when the **first matching condition** is met. It acts like an IF-ELSE chain within SQL.

---

### CASE Syntax

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ...
    ELSE result          -- Optional: default if no condition matches
END
```

**Components:**
- `CASE` → starts the logic block
- `WHEN condition THEN result` → condition to test + what to return if TRUE
- `ELSE result` → default value if none of the WHEN conditions are true (optional; returns NULL if omitted)
- `END` → closes the logic block

> ⚠️ **Rule:** All `THEN` results must have **compatible data types** (all strings or all numbers — don't mix).

---

### Full Form vs Quick Form

**Full Form** — evaluates full conditions (supports any comparison operators):

```sql
CASE
    WHEN Country = 'Germany' THEN 'DE'
    WHEN Country = 'India'   THEN 'IN'
    WHEN Country = 'France'  THEN 'FR'
    ELSE 'n/a'
END
```

**Quick Form** — evaluates equality for one column (cleaner syntax):

```sql
CASE Country
    WHEN 'Germany' THEN 'DE'
    WHEN 'India'   THEN 'IN'
    WHEN 'France'  THEN 'FR'
    ELSE 'n/a'
END
```

> ⚠️ Quick Form only supports **equality (=)** checks. For ranges, inequalities, or complex conditions → use Full Form.

---

### How CASE Evaluates — Flow

SQL evaluates WHEN conditions **top to bottom** and stops at the **first TRUE** condition:

```sql
CASE
    WHEN Sales > 50 THEN 'High'
    WHEN Sales > 20 THEN 'Medium'
    ELSE 'Low'
END
```

| Sales | Sales > 50? | Sales > 20? | Result |
|---|---|---|---|
| 60 | ✅ TRUE | — (stops here) | `'High'` |
| 30 | ❌ FALSE | ✅ TRUE | `'Medium'` |
| 15 | ❌ FALSE | ❌ FALSE | `'Low'` (ELSE) |
| NULL | ❌ FALSE | ❌ FALSE | `'Low'` (ELSE catches NULL) |

**Without ELSE:**
```sql
CASE
    WHEN Sales > 50 THEN 'High'
END
-- If Sales = 30 → no condition met, no ELSE → returns NULL
```

| Sales | Result (no ELSE) |
|---|---|
| 60 | `'High'` |
| 30 | `NULL` |
| NULL | `NULL` |

---

### CASE Use Cases

#### 1. Categorizing / Segmenting Data

```sql
SELECT
    CustomerName,
    Sales,
    CASE
        WHEN Sales >= 100 THEN 'High'
        WHEN Sales >= 50  THEN 'Medium'
        ELSE 'Low'
    END AS SalesCategory
FROM Orders;
```

#### 2. Transformation & Standardization (Mapping Values)

```sql
-- Map country names to codes
SELECT
    Country,
    CASE Country
        WHEN 'Germany'       THEN 'DE'
        WHEN 'United States' THEN 'US'
        WHEN 'France'        THEN 'FR'
        WHEN 'Italy'         THEN 'IT'
        ELSE 'n/a'
    END AS CountryCode
FROM Customers;

-- Standardize gender codes
SELECT
    CASE Gender
        WHEN 'F' THEN 'Female'
        WHEN 'M' THEN 'Male'
        ELSE 'n/a'
    END AS GenderLabel
FROM Users;
```

#### 3. Handling NULLs

```sql
SELECT
    CASE
        WHEN ShippingAddress IS NULL THEN BillingAddress
        ELSE ShippingAddress
    END AS DeliveryAddress
FROM Orders;
```

#### 4. Conditional Aggregations

```sql
-- Count how many orders are High vs Low value
SELECT
    SUM(CASE WHEN Sales >= 100 THEN 1 ELSE 0 END) AS HighValueOrders,
    SUM(CASE WHEN Sales < 100  THEN 1 ELSE 0 END) AS LowValueOrders
FROM Orders;

-- Average sales only for customers from USA
SELECT
    AVG(CASE WHEN Country = 'USA' THEN Sales ELSE NULL END) AS AvgUSASales
FROM Orders;
```

---

## 9. Interview Questions & Answers

### Q1: What is the difference between `ISNULL` and `COALESCE`?

**Answer:**
- `ISNULL(value, replacement)` accepts **only 2 arguments**, is faster, but is SQL Server-specific (Oracle uses NVL, MySQL uses IFNULL).
- `COALESCE(v1, v2, v3, ...)` accepts **unlimited arguments**, is ANSI SQL standard (works in all databases), and returns the first non-NULL value from the list.

```sql
ISNULL(ShippingAddress, 'N/A')                          -- 2 args only
COALESCE(ShippingAddress, BillingAddress, 'N/A')        -- unlimited args
```

---

### Q2: Why can't I use `= NULL` to check for NULL values?

**Answer:**
NULL represents an **unknown** value. Comparing anything to an unknown (including unknown = unknown) always results in `NULL`, not `TRUE` or `FALSE`. Since WHERE only passes rows where the condition is `TRUE`, `= NULL` never matches any row. You must use `IS NULL` or `IS NOT NULL`.

```sql
WHERE Sales = NULL    -- ❌ Always returns 0 rows
WHERE Sales IS NULL   -- ✅ Correctly returns NULL rows
```

---

### Q3: What is the difference between `CAST` and `CONVERT`?

**Answer:**
Both convert data types, but:
- `CAST(value AS type)` — ANSI standard, portable, **no formatting options**
- `CONVERT(type, value, style)` — SQL Server specific, supports optional **style codes** for date formatting

```sql
CAST('2025-08-20' AS DATE)         -- simple conversion, no format
CONVERT(VARCHAR, OrderDate, 112)   -- '20250820' (with style 112)
```

---

### Q4: What is the difference between `FORMAT` and `CONVERT` for dates?

**Answer:**
- `FORMAT(date, 'pattern')` — uses .NET-style format strings (like `'MMM yyyy'`), always outputs a **string**, supports locale/culture
- `CONVERT(VARCHAR, date, style_number)` — uses numeric style codes (like `112`), outputs string or other types

```sql
FORMAT(OrderDate, 'MMM yyyy')          -- 'Aug 2025'
CONVERT(VARCHAR, OrderDate, 112)       -- '20250820'
```

---

### Q5: What does `DATETRUNC` do, and how is it different from `DATEPART`?

**Answer:**
- `DATEPART(part, date)` → **extracts** one integer number from a date (e.g., returns `8` for month)
- `DATETRUNC(part, date)` → **truncates** the entire date, keeping everything up to the specified part and resetting the rest to its minimum (returns a full datetime value)

```sql
DATEPART(month, '2025-08-20')    -- Returns: 8
DATETRUNC(month, '2025-08-20')   -- Returns: 2025-08-01 00:00:00
```

---

### Q6: What is `NULLIF` used for, and give a practical example?

**Answer:**
`NULLIF(v1, v2)` returns NULL when `v1 = v2`, otherwise returns `v1`. Its most common use is **preventing division-by-zero errors**.

```sql
-- Without NULLIF → error if Quantity = 0
SELECT Revenue / Quantity FROM Sales;

-- With NULLIF → safely returns NULL instead of error
SELECT Revenue / NULLIF(Quantity, 0) FROM Sales;
```

---

### Q7: What is the difference between `DATENAME` and `DATEPART`?

**Answer:**
Both extract a date part, but they return different types:
- `DATEPART(part, date)` → returns an **integer (INT)** (e.g., `8` for August)
- `DATENAME(part, date)` → returns a **string (VARCHAR)** (e.g., `'August'` for month, `'Wednesday'` for weekday)

```sql
DATEPART(month, '2025-08-20')    -- 8
DATENAME(month, '2025-08-20')    -- 'August'
DATEPART(weekday, '2025-08-20')  -- 4
DATENAME(weekday, '2025-08-20')  -- 'Wednesday'
```

---

### Q8: What happens if `ELSE` is omitted from a `CASE` statement?

**Answer:**
If no `WHEN` condition matches and there is no `ELSE`, the `CASE` statement returns **NULL** (not an error). Always include `ELSE` to handle unexpected or missing values.

```sql
CASE
    WHEN Sales > 100 THEN 'High'
END
-- If Sales = 50 → returns NULL (no ELSE defined)
```

---

### Q9: What is the difference between `CONCAT` and the `+` operator for string concatenation?

**Answer:**
- `CONCAT()` automatically treats NULL as an empty string, so the result is never NULL because of a single NULL input.
- The `+` operator propagates NULL — if any operand is NULL, the entire result is NULL.

```sql
SELECT CONCAT('Hello', NULL, ' World');    -- 'Hello World'  (NULL ignored)
SELECT 'Hello' + NULL + ' World';          -- NULL           (NULL spreads)
```

---

### Q10: How does `EOMONTH` handle leap years?

**Answer:**
`EOMONTH` automatically accounts for the actual number of days in each month, including leap years.

```sql
SELECT EOMONTH('2024-02-10');   -- 2024-02-29  (2024 is a leap year → 29 days)
SELECT EOMONTH('2025-02-10');   -- 2025-02-28  (2025 is not a leap year → 28 days)
```

---

### Q11: What is a LEFT ANTI JOIN and how do you write it?

**Answer:**
A LEFT ANTI JOIN returns all rows from the left table that have **no matching row** in the right table. It's written as a LEFT JOIN combined with `IS NULL` on the right table's key.

```sql
-- Find customers who have NEVER placed an order
SELECT c.CustomerID, c.Name
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;
```

---

### Q12: What is a nested function? Give an example.

**Answer:**
A nested function is when the output of one function is used as the input to another. SQL evaluates from innermost to outermost.

```sql
-- Extract first 2 chars, make lowercase, then count length
SELECT LEN(LOWER(LEFT('Maria', 2)));
-- Step 1: LEFT('Maria', 2) → 'Ma'
-- Step 2: LOWER('Ma')      → 'ma'
-- Step 3: LEN('ma')        → 2
```

---

## 10. Quick Reference Cheat Sheet

```sql
-- ✅ STRING FUNCTIONS
CONCAT(v1, v2, v3)           -- Join strings together
UPPER(value)                 -- 'maria' → 'MARIA'
LOWER(value)                 -- 'MARIA' → 'maria'
TRIM(value)                  -- '  John  ' → 'John'
LTRIM(value)                 -- Remove left spaces only
RTRIM(value)                 -- Remove right spaces only
LEN(value)                   -- Count characters
LEFT(value, n)               -- First n characters
RIGHT(value, n)              -- Last n characters
SUBSTRING(value, start, len) -- From position start, take len chars
REPLACE(value, old, new)     -- Replace or remove substrings

-- ✅ NUMERIC FUNCTIONS
ROUND(value, decimals)       -- Round to n decimal places
ABS(value)                   -- Absolute value (remove negative)
CEILING(value)               -- Always round up
FLOOR(value)                 -- Always round down

-- ✅ DATE EXTRACTION
YEAR(date)                           -- Extract year as INT
MONTH(date)                          -- Extract month as INT
DAY(date)                            -- Extract day as INT
EOMONTH(date)                        -- Last day of the month
DATEPART(part, date)                 -- Any part as INT
DATENAME(part, date)                 -- Any part as STRING
DATETRUNC(part, date)                -- Truncate to precision (DATETIME)

-- ✅ DATE FORMATTING / CASTING
FORMAT(value, 'pattern')             -- Custom string format
FORMAT(value, 'pattern', 'culture') -- With locale
CAST(value AS data_type)             -- Convert type, no format
CONVERT(data_type, value)            -- Convert type
CONVERT(VARCHAR, date, style)        -- Convert with format style

-- ✅ DATE CALCULATIONS
DATEADD(part, n, date)               -- Add n units to date
DATEADD(part, -n, date)              -- Subtract n units from date
DATEDIFF(part, start_date, end_date) -- Difference between dates

-- ✅ DATE VALIDATION
ISDATE(value)                        -- 1 if valid date, 0 if not

-- ✅ NULL FUNCTIONS
ISNULL(value, replacement)           -- Replace NULL (SQL Server)
COALESCE(v1, v2, v3, ...)            -- First non-NULL value (all DBs)
NULLIF(v1, v2)                       -- NULL if v1 = v2, else v1
col IS NULL                          -- Check for NULL (WHERE)
col IS NOT NULL                      -- Check for non-NULL (WHERE)

-- ✅ CASE STATEMENT
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END

-- Quick form (equality only)
CASE column
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ELSE default_result
END

-- ✅ NESTED FUNCTIONS
SELECT LEN(LOWER(LEFT(Name, 2))) FROM Players;
```

---

### Summary Table — All Functions at a Glance

| Function | Category | Purpose | Returns |
|---|---|---|---|
| `CONCAT` | String | Join strings | String |
| `UPPER` / `LOWER` | String | Change case | String |
| `TRIM` / `LTRIM` / `RTRIM` | String | Remove spaces | String |
| `REPLACE` | String | Replace/remove chars | String |
| `LEN` | String | Count characters | INT |
| `LEFT` / `RIGHT` | String | Extract from ends | String |
| `SUBSTRING` | String | Extract from any position | String |
| `ROUND` | Numeric | Round decimals | Numeric |
| `YEAR` / `MONTH` / `DAY` | Date | Quick date part | INT |
| `EOMONTH` | Date | Last day of month | DATE |
| `DATEPART` | Date | Any date part | INT |
| `DATENAME` | Date | Any date part as name | STRING |
| `DATETRUNC` | Date | Truncate date | DATETIME |
| `FORMAT` | Date/Numeric | Custom string format | STRING |
| `CAST` | Casting | Type conversion | Any |
| `CONVERT` | Casting | Type conversion + style | Any |
| `DATEADD` | Date Calc | Add/subtract time | DATETIME |
| `DATEDIFF` | Date Calc | Time difference | INT |
| `ISDATE` | Validation | Is it a valid date? | 0 or 1 |
| `ISNULL` | NULL | Replace NULL (2 args) | Any |
| `COALESCE` | NULL | First non-NULL (n args) | Any |
| `NULLIF` | NULL | NULL if equal | Any or NULL |
| `IS NULL` | NULL | Check for NULL | Boolean |
| `CASE WHEN` | Logic | Conditional expression | Any |

---

> 📌 Based on [Data With Baraa — SQL Course](https://www.youtube.com/@DataWithBaraa) | SQL Row-Level Functions
