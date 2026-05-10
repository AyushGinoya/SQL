# SQL JOINs & SET Operators — Combining Data
> 📘 Complete theory + interview prep based on *Data With Baraa* SQL Course

---

## Table of Contents
1. [Two Methods to Combine Data](#1-two-methods-to-combine-data)
2. [What is a SQL JOIN?](#2-what-is-a-sql-join)
3. [Why We JOIN Tables](#3-why-we-join-tables)
4. [JOIN Possibilities](#4-join-possibilities)
5. [Basic JOIN Types](#5-basic-join-types)
   - [No Join](#no-join)
   - [INNER JOIN](#inner-join)
   - [LEFT JOIN](#left-join)
   - [RIGHT JOIN](#right-join)
   - [FULL JOIN](#full-join)
6. [Advanced JOIN Types](#6-advanced-join-types)
   - [LEFT ANTI JOIN](#left-anti-join)
   - [RIGHT ANTI JOIN](#right-anti-join)
   - [FULL ANTI JOIN](#full-anti-join)
   - [CROSS JOIN](#cross-join)
7. [Joining Multiple Tables](#7-joining-multiple-tables)
8. [SET Operators](#8-set-operators)
   - [UNION](#union)
   - [UNION ALL](#union-all)
   - [EXCEPT (MINUS)](#except-minus)
   - [INTERSECT](#intersect)
9. [SET Operator Rules](#9-set-operator-rules)
10. [SET Operator Use Cases](#10-set-operator-use-cases)
11. [UNION vs UNION ALL](#11-union-vs-union-all)
12. [JOINs vs SET Operators](#12-joins-vs-set-operators)
13. [Interview Questions & Answers](#13-interview-questions--answers)
14. [Quick Reference Cheat Sheet](#14-quick-reference-cheat-sheet)

---

## 1. Two Methods to Combine Data

When you have two tables (A and B), there are **two ways** to combine them:

| Method | Direction | How | Operators |
|---|---|---|---|
| **SET Operators** | Vertical (rows) | Stack rows on top of each other — same columns required | UNION, UNION ALL, EXCEPT, INTERSECT |
| **JOINs** | Horizontal (columns) | Merge columns side by side — connected via a key column | INNER, LEFT, RIGHT, FULL |

```
SET Operators → combine ROWS (vertical)
JOINs        → combine COLUMNS (horizontal)
```

---

## 2. What is a SQL JOIN?

A SQL JOIN **combines columns from two or more tables** into a single result set, based on a related **key column** that connects them.

```sql
-- Basic JOIN syntax
SELECT *
FROM TableA A
JOIN TableB B ON A.id = B.id;
```

**How it works:**
- SQL looks at the key column (e.g., `id`) in both tables
- It matches rows where the key values are equal
- Matched rows are **combined horizontally** into one result row

**Example:**

| Players Table | | Countries Table | |
|---|---|---|---|
| Name | id | id | Country |
| Maria | 1 | 1 | Germany |
| John | 2 | 2 | USA |
| Georg | 3 | 4 | Germany |
| Martin | 4 | 5 | USA |

After JOIN on id:

| id | Name | Country |
|---|---|---|
| 1 | Maria | Germany |
| 2 | John | USA |
| 4 | Martin | Germany |

> Georg (id=3) has no match in the Countries table → excluded in INNER JOIN.

---

## 3. Why We JOIN Tables

There are 3 main reasons to join tables:

### Reason 1 — Recombine Data ("Big Picture")
Databases store data in **normalized** separate tables to avoid redundancy. JOINs bring them back together for querying.

```
Customers + Addresses + Orders + Reviews → All Customer Details in One View
```

**Best JOIN types:** INNER JOIN, LEFT JOIN, FULL JOIN

### Reason 2 — Data Enrichment ("Getting Extra Data")
Enrich a master table with additional information from a reference table.

```
Customers (Master Table) + ZipCodes (Reference Table) → Enhanced Customers with City/State
```

**Best JOIN type:** LEFT JOIN (keep all master rows, add extra info where available)

### Reason 3 — Check for Existence ("Filtering")
Use one table as a **filter/lookup** to include or exclude rows from another table. Not about adding columns — just filtering.

```
Customers + Orders (Lookup) → Only Customers who have placed an Order
```

**Best JOIN types:** INNER JOIN, LEFT JOIN + WHERE IS NULL, FULL JOIN + WHERE

---

## 4. JOIN Possibilities

Every JOIN falls into one of three categories based on what data you want:

| Category | What it Returns | JOIN to Use |
|---|---|---|
| **Matching Data** | Only rows that exist in BOTH tables | INNER JOIN |
| **All Data** | Everything from one or both tables | LEFT / RIGHT / FULL JOIN |
| **UnMatching Data** | Rows that do NOT have a match | Anti JOINs (LEFT/RIGHT/FULL + WHERE IS NULL) |

---

## 5. Basic JOIN Types

### No Join

Returns data from tables **independently** — two separate queries, no combining.

```sql
SELECT * FROM A;
SELECT * FROM B;
```

Use when: you need data from each table separately and don't need to combine them.

---

### INNER JOIN

**Definition:** Returns **only rows that have a match in BOTH tables**.

```
Venn Diagram: Only the overlapping middle section
```

```sql
SELECT *
FROM A
INNER JOIN B ON A.Key = B.Key;
```

**Key Points:**
- The order of tables **does NOT matter** (A INNER JOIN B = B INNER JOIN A)
- Rows with no match in either table are **excluded**
- Most commonly used JOIN

**Example:**
```sql
-- Get all orders with their customer names
SELECT C.CustomerName, O.OrderDate, O.Amount
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID;
```

---

### LEFT JOIN

**Definition:** Returns **ALL rows from the Left table** (primary) and **only matching rows from the Right table** (secondary). Non-matching right rows get NULL.

```
Venn Diagram: Full left circle + overlapping section of right
```

```sql
SELECT *
FROM A          -- LEFT (Primary - all rows kept)
LEFT JOIN B     -- RIGHT (Secondary - only matching)
ON A.Key = B.Key;
```

**Key Points:**
- The order of tables **IS IMPORTANT** (A is always primary/left)
- Left table = **Primary / Main Source of Data**
- Right table = **Secondary / For Additional Data**
- Non-matching right rows → NULL values in result

**Example:**
```sql
-- All customers, with their orders (if any)
SELECT C.CustomerName, O.OrderDate
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID;
-- Customers with no orders: CustomerName shows, OrderDate = NULL
```

---

### RIGHT JOIN

**Definition:** Returns **ALL rows from the Right table** (primary) and **only matching rows from the Left table** (secondary).

```
Venn Diagram: Full right circle + overlapping section of left
```

```sql
SELECT *
FROM A          -- LEFT (Secondary - only matching)
RIGHT JOIN B    -- RIGHT (Primary - all rows kept)
ON A.Key = B.Key;
```

**Key Points:**
- The order of tables **IS IMPORTANT**
- Right table = Primary / Main Source of Data
- Left table = Secondary / For Additional Data
- Rarely used — can always be rewritten as a LEFT JOIN by swapping tables

**Alternative (preferred):**
```sql
-- RIGHT JOIN: A → B
SELECT * FROM A RIGHT JOIN B ON A.Key = B.Key

-- Same result using LEFT JOIN (just swap tables):
SELECT * FROM B LEFT JOIN A ON A.Key = B.Key
```

> ✅ **Best Practice:** Always prefer LEFT JOIN over RIGHT JOIN. Swap your table order instead.

---

### FULL JOIN

**Definition:** Returns **ALL rows from BOTH tables**. Matching rows are combined, non-matching rows from either side get NULL.

```
Venn Diagram: Both full circles — Everything!
```

```sql
SELECT *
FROM A
FULL JOIN B ON A.Key = B.Key;
-- Also written as: FULL OUTER JOIN
```

**Key Points:**
- The order of tables **does NOT matter**
- Returns matching AND non-matching rows from both sides
- Non-matching rows get NULL for the opposite table's columns

**Example:**
```sql
-- All customers AND all orders, whether they match or not
SELECT C.CustomerName, O.OrderDate
FROM Customers C
FULL JOIN Orders O ON C.CustomerID = O.CustomerID;
```

---

## 6. Advanced JOIN Types

### LEFT ANTI JOIN

**Definition:** Returns rows from the **Left table that have NO match** in the Right table. The right table is used as a **filter only** (no columns from it in the result).

```
Venn Diagram: Only the left circle part that does NOT overlap
```
```
Left table is always complete
To find records with NO matches, start from the table that may have missing references.
```

```sql
SELECT *
FROM A
LEFT JOIN B ON A.Key = B.Key
WHERE B.Key IS NULL;   -- Only unmatched rows from A
```

**Real Use Case:** Find customers who have **never placed an order**.
```sql
SELECT C.CustomerName
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.CustomerID IS NULL;
```

---

### RIGHT ANTI JOIN

**Definition:** Returns rows from the **Right table that have NO match** in the Left table.

```sql
SELECT *
FROM A
RIGHT JOIN B ON A.Key = B.Key
WHERE A.Key IS NULL;
```

**Alternative (preferred LEFT JOIN version):**
```sql
SELECT *
FROM B
LEFT JOIN A ON A.Key = B.Key
WHERE A.Key IS NULL;
```

---

### FULL ANTI JOIN

**Definition:** Returns **only rows that DON'T match in either table** — the unmatching rows from both sides.

```
Venn Diagram: Both circles, but EXCLUDING the overlapping middle
```

```sql
SELECT *
FROM A
FULL JOIN B ON A.Key = B.Key
WHERE B.Key IS NULL
   OR A.Key IS NULL;
```

**Real Use Case:** Find records that exist in one system but not the other (data reconciliation).

---

### CROSS JOIN

**Definition:** Combines **every row from Left with every row from Right** — all possible combinations. Also called a **Cartesian Join**.

```
Diagram: Each row in A connects to every row in B (lines crossing)
```

```sql
SELECT *
FROM A
CROSS JOIN B;
-- No ON condition needed!
```

**Row count formula:** `Rows in A × Rows in B = Total result rows`

```
2 rows in A × 3 rows in B = 6 total rows
```

**Key Points:**
- The order of tables does NOT matter
- **No condition (ON) needed** — it combines everything
- Can produce huge result sets — use carefully!

**Real Use Cases:**
- Generate all combinations (e.g., all Size × Color combinations for a product)
- Create a date dimension table
- Test data generation

```sql
-- All possible product-color combinations
SELECT P.ProductName, C.Color
FROM Products P
CROSS JOIN Colors C;
```

---

## 7. Joining Multiple Tables

You can chain multiple JOINs together. The pattern is: **start with the Master table, then JOIN each additional table one by one**.

```sql
SELECT *
FROM A               -- 1. Master table (starting point)
LEFT JOIN B ON ...   -- 2. Join table B
LEFT JOIN C ON ...   -- 3. Join table C
LEFT JOIN D ON ...   -- 4. Join table D
WHERE ...            -- Control what to keep
```

**Visual:** A is the hub; B, C, D are spokes connected to it.

### Multiple INNER JOINs
```sql
-- Only rows that exist in ALL three tables
SELECT *
FROM A
INNER JOIN B ON A.Key = B.Key
INNER JOIN C ON A.Key = C.Key;
```
Result: Only the intersection of A ∩ B ∩ C

### Mixed JOINs (INNER + LEFT)
```sql
-- All rows from A, match from B required, C optional
SELECT *
FROM A
INNER JOIN B ON A.Key = B.Key   -- B must match
LEFT JOIN C ON A.Key = C.Key;   -- C is optional
```

### Real Example — 3 Tables
```sql
SELECT
    C.CustomerName,
    O.OrderDate,
    P.ProductName
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
LEFT JOIN Products P ON O.ProductID = P.ProductID;
```

---

## 8. SET Operators

SET operators **combine the results of multiple SELECT queries into one result set** by stacking rows vertically. Both queries must have the same number of columns and compatible data types.

### Syntax Structure
```sql
SELECT FirstName, LastName
FROM Customers
    [JOIN ...]
    [WHERE ...]
    [GROUP BY ...]

UNION   -- SET Operator goes here

SELECT FirstName, LastName
FROM Employees
    [JOIN ...]
    [WHERE ...]
    [GROUP BY ...]

ORDER BY FirstName;  -- ORDER BY only at the very end
```

---

### UNION

**Definition:** Combines all rows from both queries and **removes duplicates**.

```
Venn Diagram: Both overlapping circles — but Kevin & Mary appear only ONCE
```

```sql
SELECT FirstName, LastName FROM Customers
UNION
SELECT FirstName, LastName FROM Employees;
```

**Result:** All distinct names from both tables. If Kevin & Mary appear in both, they show up only once.

**Use Case:** Get a unique list of all people (customers + employees) in the system.

---

### UNION ALL

**Definition:** Combines all rows from both queries and **keeps duplicates**.

```
Venn Diagram: Two separate circles with no overlap removed — Kevin & Mary appear TWICE
```

```sql
SELECT FirstName, LastName FROM Customers
UNION ALL
SELECT FirstName, LastName FROM Employees;
```

**Result:** All rows including duplicates. Kevin & Mary appear twice.

**Use Case:** Combine yearly order tables (Orders_2022 + Orders_2023 + ...) where duplicates are not expected.

---

### EXCEPT (MINUS)

**Definition:** Returns rows that are **unique to the first query and NOT in the second query**.

```
Venn Diagram: Only the left circle part that does NOT overlap
```

```sql
SELECT FirstName, LastName FROM Customers
EXCEPT
SELECT FirstName, LastName FROM Employees;
```

**Result:** Names that are in Customers but NOT in Employees.

> In Oracle/MySQL, this is called `MINUS` instead of `EXCEPT`.

**Important:** Order matters! `A EXCEPT B` ≠ `B EXCEPT A`

**Use Case:** Find customers who are not employees, or detect new records added since yesterday.

---

### INTERSECT

**Definition:** Returns only the rows that are **common to both queries**.

```
Venn Diagram: Only the overlapping middle section
```

```sql
SELECT FirstName, LastName FROM Customers
INTERSECT
SELECT FirstName, LastName FROM Employees;
```

**Result:** Names that appear in BOTH tables (e.g., Kevin & Mary).

**Use Case:** Find people who are both customers AND employees.

---

## 9. SET Operator Rules

These rules apply to **all** SET operators (UNION, UNION ALL, EXCEPT, INTERSECT):

| Rule | Detail |
|---|---|
| **1. Same number of columns** | Both SELECT statements must select the same count of columns |
| **2. Compatible data types** | Column data types must be compatible across both queries |
| **3. ORDER BY at the end only** | ORDER BY can appear once, at the very end of the full query |
| **4. Column names from first query** | The result set uses column names from the first SELECT |
| **5. Can be used in any clause** | SET operators can be used in subqueries, CTEs, etc. |

```sql
-- ✅ CORRECT
SELECT FirstName, LastName FROM Customers   -- 2 columns
UNION
SELECT FirstName, LastName FROM Employees   -- 2 columns
ORDER BY FirstName;                         -- ORDER BY at end only

-- ❌ WRONG — different column count
SELECT FirstName, LastName, Email FROM Customers
UNION
SELECT FirstName, LastName FROM Employees

-- ❌ WRONG — ORDER BY inside individual SELECT
SELECT FirstName FROM Customers ORDER BY FirstName
UNION
SELECT FirstName FROM Employees
```

---

## 10. SET Operator Use Cases

### Use Case 1 — Combine Information (UNION / UNION ALL)

Combine data from multiple separate tables into one unified view for reporting.

```sql
-- Combine orders from multiple yearly tables
SELECT OrderID, CustomerID, OrderDate, Amount FROM Orders_2022
UNION ALL
SELECT OrderID, CustomerID, OrderDate, Amount FROM Orders_2023
UNION ALL
SELECT OrderID, CustomerID, OrderDate, Amount FROM Orders_2024
UNION ALL
SELECT OrderID, CustomerID, OrderDate, Amount FROM Orders_2025;
```

### Use Case 2 — Delta Detection (EXCEPT)

Detect what changed between two snapshots of data (new, updated, or deleted records).

```sql
-- Find records in Day 2 that were NOT in Day 1 (new records)
SELECT CustomerID, Name, Email FROM Snapshot_Day2
EXCEPT
SELECT CustomerID, Name, Email FROM Snapshot_Day1;
```

### Use Case 3 — Data Completeness Check (EXCEPT)

Verify that data was fully copied/migrated from one database to another.

```sql
-- If both return empty, migration was 100% complete
SELECT CustomerID FROM DatabaseA.Customers
EXCEPT
SELECT CustomerID FROM DatabaseB.Customers;

SELECT CustomerID FROM DatabaseB.Customers
EXCEPT
SELECT CustomerID FROM DatabaseA.Customers;
```

---

## 11. UNION vs UNION ALL

| Feature | UNION | UNION ALL |
|---|---|---|
| **Duplicates** | Removed (distinct only) | Kept (all rows) |
| **Performance** | Slower (extra dedup step) | **Faster** |
| **Use when** | You need unique results | You know no duplicates exist, or want them |

**When to use UNION ALL (preferred when possible):**
- Combining yearly/monthly tables (no cross-table duplicates expected)
- To identify duplicates and data quality issues
- For better performance at scale

---

## 12. JOINs vs SET Operators

| Feature | JOINs | SET Operators |
|---|---|---|
| **Direction** | Horizontal (adds columns) | Vertical (adds rows) |
| **Tables required** | Need a key column to connect | Need same columns / compatible types |
| **Result shape** | Wider table | Taller table |
| **Use case** | Combine related data across tables | Stack similar data from multiple queries |
| **Column names** | From both tables | From first query only |

```
JOIN result:
[A columns] + [B columns] → wider

SET result:
[A rows]
[B rows]    → taller
```

---

## 13. Interview Questions & Answers

### Q1: What is the difference between INNER JOIN and LEFT JOIN?

**Answer:**
- `INNER JOIN` returns only rows that have a match in BOTH tables.
- `LEFT JOIN` returns ALL rows from the left table and only matching rows from the right. Non-matching right rows show NULL.

```sql
-- INNER JOIN: only matching customers with orders
SELECT C.Name, O.OrderDate
FROM Customers C
INNER JOIN Orders O ON C.ID = O.CustomerID;

-- LEFT JOIN: ALL customers, orders if they exist
SELECT C.Name, O.OrderDate
FROM Customers C
LEFT JOIN Orders O ON C.ID = O.CustomerID;
-- Customers with no orders: OrderDate = NULL
```

---

### Q2: How do you find customers who have NEVER placed an order?

**Answer:** Use LEFT ANTI JOIN — LEFT JOIN + WHERE right key IS NULL.

```sql
SELECT C.CustomerName
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.CustomerID IS NULL;
```

---

### Q3: What is the difference between UNION and UNION ALL?

**Answer:**
- `UNION` removes duplicates (slower — performs deduplication).
- `UNION ALL` keeps all rows including duplicates (faster — no dedup).

Use `UNION ALL` when you know there are no duplicates, or when you want to identify duplicates for data quality checks.

---

### Q4: What is a CROSS JOIN and when would you use it?

**Answer:** A CROSS JOIN returns every possible combination of rows from two tables (Cartesian product). `Rows = A × B`.

```sql
SELECT * FROM Products CROSS JOIN Colors;
-- 5 products × 3 colors = 15 rows
```

Used for: generating all combinations (product variants, date grids, test data).

---

### Q5: Can you replace a RIGHT JOIN with a LEFT JOIN?

**Answer:** Yes, always. Just swap the table order.

```sql
-- RIGHT JOIN
SELECT * FROM A RIGHT JOIN B ON A.Key = B.Key

-- Equivalent LEFT JOIN
SELECT * FROM B LEFT JOIN A ON A.Key = B.Key
```

Best practice is to always use LEFT JOIN for consistency and readability.

---

### Q6: What is the difference between EXCEPT and NOT IN?

**Answer:**
- `EXCEPT` works on full rows (compares all selected columns).
- `NOT IN` works on a single column value.
- `EXCEPT` handles NULLs automatically (treats NULL = NULL); `NOT IN` with NULLs returns no rows.

```sql
-- EXCEPT: safe with NULLs, compares all columns
SELECT Name FROM Customers
EXCEPT
SELECT Name FROM Employees;

-- NOT IN: dangerous if list has NULLs
SELECT Name FROM Customers
WHERE Name NOT IN (SELECT Name FROM Employees WHERE Name IS NOT NULL);
```

---

### Q7: What are the rules for using SET operators?

**Answer:** Both queries must have:
1. The same number of columns
2. Compatible data types in the same column positions
3. `ORDER BY` only once at the very end
4. Column names come from the first query

---

### Q8: What is the difference between INTERSECT and INNER JOIN?

**Answer:**
- `INNER JOIN` combines **columns horizontally** using a key column — result is wider.
- `INTERSECT` combines **rows vertically** returning only common rows — result is taller/same width.

```sql
-- INNER JOIN: adds columns from both tables
SELECT C.Name, O.Amount
FROM Customers C INNER JOIN Orders O ON C.ID = O.CustomerID;

-- INTERSECT: finds rows that exist in both queries (same columns)
SELECT FirstName FROM Customers
INTERSECT
SELECT FirstName FROM Employees;
```

---

### Q9: Does table order matter in JOINs?

**Answer:**
- `INNER JOIN` → Order does **NOT** matter
- `LEFT JOIN` → Order **DOES** matter (left = primary)
- `RIGHT JOIN` → Order **DOES** matter (right = primary)
- `FULL JOIN` → Order does **NOT** matter
- `CROSS JOIN` → Order does **NOT** matter

---

### Q10: What is a FULL ANTI JOIN and how do you write it?

**Answer:** Returns rows that have NO match in either table — unmatching rows from both sides.

```sql
SELECT *
FROM A
FULL JOIN B ON A.Key = B.Key
WHERE B.Key IS NULL
   OR A.Key IS NULL;
```

Use case: Data reconciliation — find records in A not in B AND records in B not in A.

---

## 14. Quick Reference Cheat Sheet

### JOINs

```sql
-- INNER JOIN: Only matching rows from both tables
SELECT * FROM A INNER JOIN B ON A.Key = B.Key

-- LEFT JOIN: All rows from A + matching from B (NULL if no match)
SELECT * FROM A LEFT JOIN B ON A.Key = B.Key

-- RIGHT JOIN: All rows from B + matching from A (prefer LEFT JOIN instead)
SELECT * FROM A RIGHT JOIN B ON A.Key = B.Key

-- FULL JOIN: All rows from both A and B
SELECT * FROM A FULL JOIN B ON A.Key = B.Key

-- LEFT ANTI JOIN: Rows in A with NO match in B
SELECT * FROM A LEFT JOIN B ON A.Key = B.Key
WHERE B.Key IS NULL

-- RIGHT ANTI JOIN: Rows in B with NO match in A
SELECT * FROM A RIGHT JOIN B ON A.Key = B.Key
WHERE A.Key IS NULL

-- FULL ANTI JOIN: Unmatching rows from both A and B
SELECT * FROM A FULL JOIN B ON A.Key = B.Key
WHERE B.Key IS NULL OR A.Key IS NULL

-- CROSS JOIN: Every row in A × Every row in B (no condition)
SELECT * FROM A CROSS JOIN B
```

### SET Operators

```sql
-- UNION: All distinct rows from both queries
SELECT col1, col2 FROM A
UNION
SELECT col1, col2 FROM B;

-- UNION ALL: All rows including duplicates (faster)
SELECT col1, col2 FROM A
UNION ALL
SELECT col1, col2 FROM B;

-- EXCEPT: Rows in first query NOT in second
SELECT col1, col2 FROM A
EXCEPT
SELECT col1, col2 FROM B;

-- INTERSECT: Common rows in both queries
SELECT col1, col2 FROM A
INTERSECT
SELECT col1, col2 FROM B;
```

---

## Summary

### JOIN Types at a Glance

| JOIN | Returns | Order Matters? |
|---|---|---|
| INNER JOIN | Matching rows from both | No |
| LEFT JOIN | All from A + matching from B | Yes |
| RIGHT JOIN | All from B + matching from A | Yes |
| FULL JOIN | All from both | No |
| LEFT ANTI JOIN | Unmatching rows from A only | Yes |
| RIGHT ANTI JOIN | Unmatching rows from B only | Yes |
| FULL ANTI JOIN | Unmatching from both | No |
| CROSS JOIN | All combinations (A × B) | No |

### SET Operators at a Glance

| Operator | Returns | Duplicates |
|---|---|---|
| UNION | All rows from both queries | Removed |
| UNION ALL | All rows from both queries | Kept |
| EXCEPT | Rows in 1st query NOT in 2nd | Removed |
| INTERSECT | Common rows in both queries | Removed |

---

> 📌 **Source:** Data With Baraa — SQL Course | JOINS & SET Operators
>
> 🔗 YouTube: [Data With Baraa](https://youtube.com)
