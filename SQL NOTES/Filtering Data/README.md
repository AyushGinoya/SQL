# SQL Filtering Data — WHERE Conditions
> 📘 Complete theory + interview prep based on *Data With Baraa* SQL Course

---

## Table of Contents
1. [What is WHERE?](#1-what-is-where)
2. [WHERE Operators Overview](#2-where-operators-overview)
3. [Comparison Operators](#3-comparison-operators)
4. [Logical Operators](#4-logical-operators)
   - [AND](#and)
   - [OR](#or)
   - [NOT](#not)
5. [Range Operator — BETWEEN](#5-range-operator--between)
6. [Membership Operators — IN & NOT IN](#6-membership-operators--in--not-in)
7. [Search Operator — LIKE](#7-search-operator--like)
8. [NULL Handling in WHERE](#8-null-handling-in-where)
9. [Operator Precedence](#9-operator-precedence)
10. [Interview Questions & Answers](#10-interview-questions--answers)
11. [Quick Reference Cheat Sheet](#11-quick-reference-cheat-sheet)

---

## 1. What is WHERE?

The `WHERE` clause is used to **filter rows** from a table based on one or more conditions. Only rows that satisfy the condition(s) are returned in the result set.

```sql
SELECT column1, column2
FROM table_name
WHERE condition;
```

**How it works internally:**
- SQL evaluates the `WHERE` condition for **each row** one by one.
- If the condition is `TRUE` → row is **included**.
- If the condition is `FALSE` or `NULL` → row is **excluded**.

**Example:**
```sql
-- Returns only rows where Country is 'USA'
SELECT Name, Country, Score
FROM Players
WHERE Country = 'USA';
```

| Name  | Country | Score |
|-------|---------|-------|
| John  | USA     | 900   |
| Peter | USA     | 0     |

---

## 2. WHERE Operators Overview

The `WHERE` clause supports 5 categories of operators:

| Category | Operators | Purpose |
|---|---|---|
| **Comparison** | `=`, `<>`, `!=`, `>`, `>=`, `<`, `<=` | Compare two values |
| **Logical** | `AND`, `OR`, `NOT` | Combine multiple conditions |
| **Range** | `BETWEEN` | Check if a value is within a range |
| **Membership** | `IN`, `NOT IN` | Check if a value exists in a list |
| **Search** | `LIKE` | Search for a pattern in text |

---

## 3. Comparison Operators

Comparison operators compare **two expressions** (column vs column, column vs value, function vs value, expression vs value, or even subquery vs value).

### Syntax
```
Condition = Expression  Operator  Expression
```

### All Comparison Operators

| Operator | Meaning | Example |
|---|---|---|
| `=` | Equal to | `Country = 'USA'` |
| `<>` or `!=` | Not equal to | `Country <> 'USA'` |
| `>` | Greater than | `Score > 500` |
| `>=` | Greater than or equal to | `Score >= 500` |
| `<` | Less than | `Score < 500` |
| `<=` | Less than or equal to | `Score <= 500` |

### Expression Types You Can Compare

```sql
-- Column vs Column
WHERE first_name = last_name

-- Column vs Value (most common)
WHERE first_name = 'John'

-- Function vs Value
WHERE UPPER(first_name) = 'JOHN'

-- Expression vs Value
WHERE Price * Quantity = 1000

-- Subquery vs Value (Advanced)
WHERE (SELECT AVG(sales) FROM orders) = 1000
```

### Examples

```sql
-- Find all players from Germany
SELECT * FROM Players WHERE Country = 'Germany';

-- Find players with score greater than 500
SELECT * FROM Players WHERE Score > 500;

-- Find players NOT from USA
SELECT * FROM Players WHERE Country <> 'USA';

-- Find players with score of exactly 900
SELECT * FROM Players WHERE Score = 900;
```

---

## 4. Logical Operators

Logical operators allow you to **combine multiple conditions** in a single WHERE clause.

### AND

**Definition:** ALL conditions must be TRUE for a row to be included.

```sql
WHERE condition1 AND condition2
```

**Truth Table:**

| Condition 1 | Condition 2 | AND Result |
|---|---|---|
| TRUE | TRUE | ✅ TRUE |
| TRUE | FALSE | ❌ FALSE |
| FALSE | TRUE | ❌ FALSE |
| FALSE | FALSE | ❌ FALSE |

**Example:**
```sql
-- Players from USA with score > 500
SELECT * FROM Players
WHERE Country = 'USA' AND Score > 500;
```

| Name | Country | Score | Country='USA' | Score>500 | AND |
|------|---------|-------|---------------|-----------|-----|
| Maria | Germany | 350 | ❌ | ❌ | ❌ |
| John | USA | 900 | ✅ | ✅ | ✅ |
| Georg | UK | 750 | ❌ | ✅ | ❌ |
| Martin | Germany | 500 | ❌ | ❌ | ❌ |
| Peter | USA | 0 | ✅ | ❌ | ❌ |

> Only **John** passes — he is from USA AND has score > 500.

---

### OR

**Definition:** AT LEAST ONE condition must be TRUE for a row to be included.

```sql
WHERE condition1 OR condition2
```

**Truth Table:**

| Condition 1 | Condition 2 | OR Result |
|---|---|---|
| TRUE | TRUE | ✅ TRUE |
| TRUE | FALSE | ✅ TRUE |
| FALSE | TRUE | ✅ TRUE |
| FALSE | FALSE | ❌ FALSE |

**Example:**
```sql
-- Players from USA OR with score > 500
SELECT * FROM Players
WHERE Country = 'USA' OR Score > 500;
```

| Name | Country | Score | Country='USA' | Score>500 | OR |
|------|---------|-------|---------------|-----------|-----|
| Maria | Germany | 350 | ❌ | ❌ | ❌ |
| John | USA | 900 | ✅ | ✅ | ✅ |
| Georg | UK | 750 | ❌ | ✅ | ✅ |
| Martin | Germany | 500 | ❌ | ❌ | ❌ |
| Peter | USA | 0 | ✅ | ❌ | ✅ |

> **John, Georg, and Peter** pass — at least one condition is TRUE for each.

---

### NOT

**Definition:** REVERSES/NEGATES a condition. Excludes matching rows.

```sql
WHERE NOT condition
```

**Example:**
```sql
-- Players NOT from USA
SELECT * FROM Players
WHERE NOT Country = 'USA';

-- Equivalent to:
WHERE Country <> 'USA'
```

| Name | Country | Score | Country='USA' | NOT Result |
|------|---------|-------|---------------|-----------|
| Maria | Germany | 350 | ❌ | ✅ |
| John | USA | 900 | ✅ | ❌ |
| Georg | UK | 750 | ❌ | ✅ |
| Martin | Germany | 500 | ❌ | ✅ |
| Peter | USA | 0 | ✅ | ❌ |

> **Maria, Georg, Martin** pass — they are NOT from USA.

---

### Combining AND, OR, NOT

```sql
-- Players from USA OR Germany, but with score > 400
SELECT * FROM Players
WHERE (Country = 'USA' OR Country = 'Germany')
  AND Score > 400;

-- Players not from UK with score between 300 and 800
SELECT * FROM Players
WHERE NOT Country = 'UK'
  AND Score >= 300
  AND Score <= 800;
```

> ⚠️ **Important:** Use parentheses `()` to control evaluation order when mixing AND and OR. AND has higher precedence than OR.

---

## 5. Range Operator — BETWEEN

**Definition:** Checks if a value falls **within a range** (inclusive of both boundaries).

```sql
WHERE column BETWEEN lower_boundary AND upper_boundary
```

> `BETWEEN` is **inclusive** — both the lower and upper boundary values are included.

### Equivalent to:
```sql
WHERE column >= lower_boundary AND column <= upper_boundary
```

### Example with Numbers:
```sql
-- Players with score between 100 and 500 (inclusive)
SELECT * FROM Players
WHERE Score BETWEEN 100 AND 500;
```

| Name | Score | BETWEEN 100 AND 500 |
|------|-------|---------------------|
| Maria | 350 | ✅ (100 ≤ 350 ≤ 500) |
| John | 900 | ❌ (900 > 500) |
| Georg | 750 | ❌ (750 > 500) |
| Martin | 500 | ✅ (exactly 500, inclusive) |
| Peter | 0 | ❌ (0 < 100) |

### Example with Dates:
```sql
-- Orders placed in January 2024
SELECT * FROM Orders
WHERE OrderDate BETWEEN '2024-01-01' AND '2024-01-31';
```

### Example with Text:
```sql
-- Names starting between 'A' and 'M' alphabetically
SELECT * FROM Players
WHERE Name BETWEEN 'A' AND 'M';
```

### NOT BETWEEN:
```sql
-- Players with score outside the 100–500 range
SELECT * FROM Players
WHERE Score NOT BETWEEN 100 AND 500;
```

---

## 6. Membership Operators — IN & NOT IN

### IN

**Definition:** Checks if a value **exists in a specified list**. Short and clean alternative to multiple OR conditions.

```sql
WHERE column IN (value1, value2, value3, ...)
```

### Equivalent to:
```sql
WHERE column = value1 OR column = value2 OR column = value3
```

**Example:**
```sql
-- Players from Germany or USA
SELECT * FROM Players
WHERE Country IN ('Germany', 'USA');

-- Same as:
WHERE Country = 'Germany' OR Country = 'USA'
```

| Name | Country | IN ('Germany','USA') |
|------|---------|----------------------|
| Maria | Germany | ✅ |
| John | USA | ✅ |
| Georg | UK | ❌ |
| Martin | Germany | ✅ |
| Peter | USA | ✅ |

---

### NOT IN

**Definition:** Checks if a value **does NOT exist** in the specified list.

```sql
WHERE column NOT IN (value1, value2, value3, ...)
```

**Example:**
```sql
-- Players NOT from Germany or USA
SELECT * FROM Players
WHERE Country NOT IN ('Germany', 'USA');
```

| Name | Country | NOT IN ('Germany','USA') |
|------|---------|--------------------------|
| Maria | Germany | ❌ |
| John | USA | ❌ |
| Georg | UK | ✅ |
| Martin | Germany | ❌ |
| Peter | USA | ❌ |

> ⚠️ **Warning with NULL:** `NOT IN` can behave unexpectedly if the list contains NULL. If any value in the list is NULL, `NOT IN` returns no rows. Always use `IS NOT NULL` checks when needed.

```sql
-- Safe NOT IN when source is a subquery
SELECT * FROM Players
WHERE Country NOT IN (
    SELECT Country FROM Blacklist WHERE Country IS NOT NULL
);
```

---

## 7. Search Operator — LIKE

**Definition:** Used to **search for a pattern** in text/string columns.

```sql
WHERE column LIKE 'pattern'
```

### Wildcard Characters

| Wildcard | Meaning | Example |
|---|---|---|
| `%` | Zero, one, or many characters (anything) | `'M%'` → starts with M |
| `_` | Exactly one character | `'__b%'` → 3rd char is b |

### Pattern Examples

```sql
-- Starts with 'M' (M followed by anything)
WHERE Name LIKE 'M%'
-- ✅ Maria, Ma, M   ❌ Emma

-- Ends with 'in' (anything before 'in')
WHERE Name LIKE '%in'
-- ✅ Martin, Vin, in   ❌ Jasmine

-- Contains 'r' anywhere
WHERE Name LIKE '%r%'
-- ✅ Maria, Peter, Rayn, R   ❌ Alice

-- 3rd character is 'b', can have any characters before and after
WHERE Name LIKE '__b%'
-- ✅ Albert, Rob, Abel   ❌ An_
```

### More Practical Examples

```sql
-- Emails from Gmail
WHERE Email LIKE '%@gmail.com'

-- Phone numbers starting with +91
WHERE Phone LIKE '+91%'

-- Product codes starting with 'PRD' followed by exactly 3 digits
WHERE ProductCode LIKE 'PRD___'

-- Names containing 'an' anywhere
WHERE Name LIKE '%an%'
-- ✅ Martin, Anna, Santana
```

### NOT LIKE

```sql
-- Names NOT starting with 'M'
WHERE Name NOT LIKE 'M%'
```

### Case Sensitivity

- In **SQL Server**: `LIKE` is case-insensitive by default (depends on collation).
- In **MySQL**: Case-insensitive by default.
- Use `UPPER()` or `LOWER()` for guaranteed case-insensitive matching:

```sql
WHERE UPPER(Name) LIKE 'M%'
```

---

## 8. NULL Handling in WHERE

NULL in SQL means **unknown**. It behaves differently from regular values.

### ❌ Wrong Way to Check NULL:
```sql
-- This will NEVER return rows (NULL = NULL is not TRUE)
WHERE column = NULL       -- WRONG
WHERE column <> NULL      -- WRONG
```

### ✅ Correct Way:
```sql
-- Check for NULL
WHERE column IS NULL

-- Check for NOT NULL
WHERE column IS NOT NULL
```

**Example:**
```sql
-- Players with no score recorded
SELECT * FROM Players WHERE Score IS NULL;

-- Players with a score recorded
SELECT * FROM Players WHERE Score IS NOT NULL;
```

### NULL with AND/OR/NOT — Three-Valued Logic

| Expression | Result |
|---|---|
| `TRUE AND NULL` | NULL (unknown) |
| `FALSE AND NULL` | FALSE |
| `TRUE OR NULL` | TRUE |
| `FALSE OR NULL` | NULL (unknown) |
| `NOT NULL` | NULL |

> In WHERE, only `TRUE` passes. `NULL` and `FALSE` both exclude the row.

---

## 9. Operator Precedence

When multiple operators are used, SQL evaluates them in this order:

| Priority | Operator |
|---|---|
| 1 (Highest) | `NOT` |
| 2 | `AND` |
| 3 (Lowest) | `OR` |

**Example — Tricky precedence:**
```sql
-- What does this return?
WHERE Country = 'USA' OR Country = 'Germany' AND Score > 500

-- SQL reads it as:
WHERE Country = 'USA' OR (Country = 'Germany' AND Score > 500)
-- NOT as: (Country = 'USA' OR Country = 'Germany') AND Score > 500
```

**Always use parentheses to be explicit:**
```sql
-- Intended: both countries, both must have score > 500
WHERE (Country = 'USA' OR Country = 'Germany') AND Score > 500
```

---

## 10. Interview Questions & Answers

### Q1: What is the difference between `=` and `LIKE`?
**Answer:**
- `=` checks for an **exact match**. Used for numbers, dates, and exact strings.
- `LIKE` is used for **pattern matching** in strings using `%` and `_` wildcards.

```sql
WHERE Name = 'John'      -- Exact match only
WHERE Name LIKE 'J%'     -- Any name starting with J
```

---

### Q2: What is the difference between `WHERE` and `HAVING`?
**Answer:**
- `WHERE` filters **rows before** aggregation (cannot use aggregate functions).
- `HAVING` filters **groups after** aggregation (used with GROUP BY).

```sql
-- WHERE filters individual rows
SELECT Country, AVG(Score)
FROM Players
WHERE Score > 100           -- Filters rows first
GROUP BY Country
HAVING AVG(Score) > 400;    -- Then filters groups
```

---

### Q3: What is the difference between `IN` and `BETWEEN`?
**Answer:**
- `IN` checks **membership in a specific list** of values.
- `BETWEEN` checks if a value is **within a continuous range** (inclusive).

```sql
WHERE Score IN (100, 200, 500)     -- Only these exact values
WHERE Score BETWEEN 100 AND 500    -- Any value from 100 to 500
```

---

### Q4: What is the difference between `<>` and `NOT IN`?
**Answer:**
- `<>` compares against **one single value**.
- `NOT IN` compares against **multiple values**.

```sql
WHERE Country <> 'USA'                        -- Not USA only
WHERE Country NOT IN ('USA', 'Germany', 'UK') -- Not any of these
```

---

### Q5: Can you use `WHERE` with `NULL`? How?
**Answer:**
You cannot use `= NULL` or `<> NULL`. You must use `IS NULL` or `IS NOT NULL`.

```sql
-- WRONG
WHERE Score = NULL

-- CORRECT
WHERE Score IS NULL
WHERE Score IS NOT NULL
```

---

### Q6: What happens with `NOT IN` when the list contains NULL?
**Answer:**
If the subquery or list contains a NULL value, `NOT IN` returns **zero rows** because SQL cannot confirm that the value is "not equal" to an unknown (NULL).

```sql
-- This returns no rows if Blacklist has any NULL Country
WHERE Country NOT IN (SELECT Country FROM Blacklist)

-- Safe version
WHERE Country NOT IN (SELECT Country FROM Blacklist WHERE Country IS NOT NULL)
```

---

### Q7: What is the difference between `AND` and `OR`?
**Answer:**
- `AND`: **All conditions** must be TRUE → stricter, fewer rows.
- `OR`: **At least one condition** must be TRUE → less strict, more rows.

```sql
-- AND: must be USA AND score > 500 (few rows)
WHERE Country = 'USA' AND Score > 500

-- OR: USA or score > 500 (more rows)
WHERE Country = 'USA' OR Score > 500
```

---

### Q8: What does `LIKE '%'` return?
**Answer:**
`LIKE '%'` matches **everything** (including empty string `''`) but **not NULL**. It returns all rows where the column is not NULL.

```sql
WHERE Name LIKE '%'   -- Returns all rows where Name IS NOT NULL
```

---

### Q9: Can `BETWEEN` be used with dates?
**Answer:** Yes! `BETWEEN` works with numbers, dates, and strings.

```sql
WHERE OrderDate BETWEEN '2024-01-01' AND '2024-12-31'
```

---

### Q10: What is the difference between `NOT` and `<>`?
**Answer:**
- `<>` or `!=` is a **comparison operator** for direct not-equal checks.
- `NOT` is a **logical operator** that negates any condition.

```sql
WHERE Country <> 'USA'          -- Direct comparison
WHERE NOT Country = 'USA'       -- Logical negation (same result)
WHERE NOT Score BETWEEN 100 AND 500  -- NOT works with BETWEEN too
WHERE NOT Country IN ('USA', 'UK')   -- NOT works with IN too
```

---

## 11. Quick Reference Cheat Sheet

```sql
-- ✅ COMPARISON
WHERE col = 'value'         -- Equal
WHERE col <> 'value'        -- Not equal (also !=)
WHERE col > 100             -- Greater than
WHERE col >= 100            -- Greater than or equal
WHERE col < 100             -- Less than
WHERE col <= 100            -- Less than or equal

-- ✅ LOGICAL
WHERE cond1 AND cond2       -- Both must be TRUE
WHERE cond1 OR cond2        -- At least one TRUE
WHERE NOT cond1             -- Reverse the condition

-- ✅ RANGE
WHERE col BETWEEN 100 AND 500       -- Inclusive range
WHERE col NOT BETWEEN 100 AND 500   -- Outside range

-- ✅ MEMBERSHIP
WHERE col IN ('A', 'B', 'C')        -- Matches any in list
WHERE col NOT IN ('A', 'B', 'C')    -- Matches none in list

-- ✅ PATTERN SEARCH
WHERE col LIKE 'M%'         -- Starts with M
WHERE col LIKE '%in'        -- Ends with in
WHERE col LIKE '%r%'        -- Contains r
WHERE col LIKE 'M_ria'      -- M + any 1 char + ria
WHERE col NOT LIKE 'M%'     -- Does NOT start with M

-- ✅ NULL HANDLING
WHERE col IS NULL           -- Column is NULL
WHERE col IS NOT NULL       -- Column is NOT NULL
```

---

## Summary

| Operator | Use When | Example |
|---|---|---|
| `=` | Exact match | `Country = 'USA'` |
| `<>` / `!=` | Not equal | `Score <> 0` |
| `>`, `>=`, `<`, `<=` | Numeric/date comparison | `Score >= 500` |
| `AND` | All conditions must match | `Country = 'USA' AND Score > 500` |
| `OR` | Any condition can match | `Country = 'USA' OR Score > 500` |
| `NOT` | Negate any condition | `NOT Country = 'USA'` |
| `BETWEEN` | Continuous range (inclusive) | `Score BETWEEN 100 AND 500` |
| `IN` | Match from a list | `Country IN ('USA', 'UK')` |
| `NOT IN` | Exclude a list | `Country NOT IN ('USA', 'UK')` |
| `LIKE` | Pattern search in strings | `Name LIKE 'M%'` |
| `IS NULL` | Check for NULL | `Score IS NULL` |
| `IS NOT NULL` | Check for non-NULL | `Score IS NOT NULL` |

---

> 📌 Based on [Data With Baraa — SQL Course](https://youtube.com) | WHERE Conditions
