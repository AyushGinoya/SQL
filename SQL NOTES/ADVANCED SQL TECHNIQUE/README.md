# 🚀 Advanced SQL Techniques — Complete Notes

> **Course:** SQL — Advanced SQL Techniques
> **Source:** Data With Baraa SQL Course (Slide Deck)
> **Scope:** Every concept from the slides — Subqueries, CTE (incl. Recursive), Views, CTAS, Temporary Tables, Stored Procedures, and Triggers — with syntax, comparisons, row-by-row examples, edge cases, interview questions, and a cheat sheet.

---

## 📑 Table of Contents

1. [Challenges & Solutions of Complex SQL Projects](#1-challenges--solutions-of-complex-sql-projects)
2. [Database Architecture (Server vs Client)](#2-database-architecture-server-vs-client)
3. [Subqueries](#3-subqueries)
   - [3.1 What is a Subquery?](#31-what-is-a-subquery)
   - [3.2 How Subqueries Work](#32-how-subqueries-work)
   - [3.3 Subquery Classification](#33-subquery-classification)
   - [3.4 Result Types: Scalar / Row / Table](#34-result-types-scalar--row--table)
   - [3.5 Subquery in FROM Clause](#35-subquery-in-from-clause)
   - [3.6 Subquery in SELECT Clause](#36-subquery-in-select-clause)
   - [3.7 Subquery in WHERE — Comparison Operators](#37-subquery-in-where--comparison-operators)
   - [3.8 Subquery in WHERE — Logical Operators (IN, ANY, ALL, EXISTS)](#38-subquery-in-where--logical-operators-in-any-all-exists)
   - [3.9 Correlated vs Non-Correlated Subqueries](#39-correlated-vs-non-correlated-subqueries)
   - [3.10 How EXISTS Works](#310-how-exists-works)
   - [3.11 Subqueries vs JOINs](#311-subqueries-vs-joins)
4. [CTE — Common Table Expression](#4-cte--common-table-expression)
   - [4.1 What is a CTE?](#41-what-is-a-cte)
   - [4.2 CTE vs Subquery](#42-cte-vs-subquery)
   - [4.3 Benefits of CTEs](#43-benefits-of-ctes)
   - [4.4 How DB Executes a CTE](#44-how-db-executes-a-cte)
   - [4.5 CTE Types Overview](#45-cte-types-overview)
   - [4.6 Standalone CTE](#46-standalone-cte)
   - [4.7 Multiple CTEs](#47-multiple-ctes)
   - [4.8 Nested CTEs](#48-nested-ctes)
   - [4.9 Recursive CTE](#49-recursive-cte)
5. [Views](#5-views)
   - [5.1 Database Structure (DDL Hierarchy)](#51-database-structure-ddl-hierarchy)
   - [5.2 3-Layer Architecture of a Database](#52-3-layer-architecture-of-a-database)
   - [5.3 What is a View?](#53-what-is-a-view)
   - [5.4 Views vs Tables](#54-views-vs-tables)
   - [5.5 Views as Central Logic](#55-views-as-central-logic)
   - [5.6 Views vs CTE](#56-views-vs-cte)
   - [5.7 Views Syntax (CREATE / ALTER / DROP)](#57-views-syntax-create--alter--drop)
   - [5.8 Use Cases for Views](#58-use-cases-for-views)
6. [CTAS — Create Table As SELECT](#6-ctas--create-table-as-select)
   - [6.1 What is a Table?](#61-what-is-a-table)
   - [6.2 Table Types](#62-table-types)
   - [6.3 CREATE / INSERT vs CTAS](#63-create--insert-vs-ctas)
   - [6.4 CTAS Syntax (Dialect Differences)](#64-ctas-syntax-dialect-differences)
   - [6.5 Tables vs Views (Fresh vs Snapshot Data)](#65-tables-vs-views-fresh-vs-snapshot-data)
   - [6.6 CTAS Use Cases](#66-ctas-use-cases)
7. [Temporary Tables](#7-temporary-tables)
8. [The Big-Picture Comparison](#8-the-big-picture-comparison)
9. [Stored Procedures](#9-stored-procedures)
   - [9.1 What is a Stored Procedure?](#91-what-is-a-stored-procedure)
   - [9.2 Stored Procedure vs Query](#92-stored-procedure-vs-query)
   - [9.3 Stored Procedure vs Python](#93-stored-procedure-vs-python)
   - [9.4 Syntax — CREATE PROCEDURE / EXEC](#94-syntax--create-procedure--exec)
   - [9.5 Error Handling (TRY / CATCH)](#95-error-handling-try--catch)
   - [9.6 Flow Control](#96-flow-control)
10. [Triggers](#10-triggers)
    - [10.1 What is a Trigger?](#101-what-is-a-trigger)
    - [10.2 Trigger Types](#102-trigger-types)
    - [10.3 Use Case: Maintaining Logs](#103-use-case-maintaining-logs)
    - [10.4 Trigger Syntax](#104-trigger-syntax)
11. [Common Edge Cases & Tricky Behaviors](#11-common-edge-cases--tricky-behaviors)
12. [Interview Questions & Answers](#12-interview-questions--answers)
13. [Quick Reference Cheat Sheet](#13-quick-reference-cheat-sheet)

---

## 1. Challenges & Solutions of Complex SQL Projects

Real-world SQL projects suffer from these **7 challenges**:

| # | Challenge | What it means |
|---|-----------|----------------|
| 1 | **Redundancy** | Same logic copied across many queries |
| 2 | **Performance Issues** | Slow queries and heavy load on the database |
| 3 | **Complexity** | Queries become tangled and hard to understand |
| 4 | **Hard To Maintain** | Changing one calculation forces edits in many places |
| 5 | **DB Stress** | Same heavy aggregation runs again and again |
| 6 | **Security** | Users can see columns/rows they shouldn't |
| 7 | **(Lack of) Reusability** | Logic can't easily be reused by multiple consumers |

### The 5 Solutions (this whole module)

| Solution | Type | Lives in |
|----------|------|----------|
| **Subquery** | Inline temporary result | Memory (single query) |
| **CTE** (Common Table Expression) | Named inline temporary result | Memory (single query) |
| **Views** | Persisted SQL query (virtual table) | DB Catalog |
| **Temp Tables** | Materialized temp data | Disk (session) |
| **CTAS** (Create Table As Select) | Materialized permanent table from a query | Disk (permanent) |

---

## 2. Database Architecture (Server vs Client)

Understanding _where_ each technique stores data starts here.

```
            ┌──────────────────  SERVER  ──────────────────┐    │    ┌──── CLIENT ────┐
            │                                              │    │    │                │
            │  ┌────────── CACHE (RAM) ───────────┐        │    │    │   QUERY        │
            │  │   Frequently accessed results    │        │    │    │   SELECT       │
            │  └──────────────────────────────────┘        │    │    │   FROM ORDERS  │
            │                                              │    │    │                │
            │  ┌────────── DISK ─────────────────┐         │ ◄──┤    │   Data Engineer│
            │  │  TEMP  │ CATALOG │  USER tables │         │    │    │                │
            │  │        │ (meta)  │  (real data) │         │    │    └────────────────┘
            │  └─────────────────────────────────┘         │    │
            │                                              │    │
            │   ┌──────── DATABASE ENGINE ────────┐        │    │
            │   │  Parses, optimizes, executes    │        │    │
            │   └─────────────────────────────────┘        │    │
            └──────────────────────────────────────────────┘
```

| Layer | Purpose |
|-------|---------|
| **Database Engine** | Receives queries, makes plans, runs them |
| **Cache (RAM)** | Stores recent query results in memory for fast reuse |
| **Disk** | Long-term storage: TEMP area, CATALOG (metadata), USER tables (real data) |

> Where each technique lives:
> - **Subquery / CTE** → memory only (lives during the query)
> - **Temp Table** → disk TEMP area (lives during the session)
> - **View** → catalog as a persisted query definition (no data stored)
> - **CTAS** → disk USER area as a permanent table (real stored data)

---

## 3. Subqueries

### 3.1 What is a Subquery?

> **A subquery is a query inside another query.** The inner query runs first, produces a result, and the outer query then uses that result.

Synonyms used in slides:
- The outer query is also called the **Main Query** or **Outer Query**.
- The inner query is called the **Subquery** or **Inner Query**.

Subqueries can also be **nested** — a subquery inside another subquery inside another subquery.

### 3.2 How Subqueries Work

```
┌─────────────────────────────────────────────────────┐
│                      QUERY                          │
│                                                     │
│   MAIN QUERY                                        │
│   SELECT …                                          │
│   FROM …                                            │
│   JOIN …  ──┐                                       │
│             │                                       │
│             ▼                                       │
│           Result                                    │
│             ▲                                       │
│             │                                       │
│   SUB QUERY │                                       │
│   SELECT …                                          │
│   FROM …                                            │
│   WHERE …                                           │
└─────────────────────────────────────────────────────┘
```

**Execution order:**
1. The **deepest subquery** runs first, produces a result set.
2. That result is passed up to the next outer query.
3. This repeats until the outermost (main) query runs and produces the final result.

**Multi-step thinking with subqueries:**

| Step | Operation |
|------|-----------|
| Step 1 | Join tables |
| Step 2 | Filtering |
| Step 3 | Transformations |
| Step 4 | Aggregations |

### 3.3 Subquery Classification

Subqueries are categorized along **three independent axes**:

```
                    ┌── Result Types ──┐    ┌── Dependency ──┐    ┌── Location ──────┐
                    │ • Scalar         │    │ • Non-Correlated│   │ • SELECT          │
   SUBQUERY ────────┤ • Row            │    │ • Correlated   │    │ • FROM            │
                    │ • Table          │    │                │    │ • JOIN            │
                    └──────────────────┘    └────────────────┘    │ • WHERE           │
                                                                  │   (comparison /   │
                                                                  │    logical ops)   │
                                                                  └───────────────────┘
```

### 3.4 Result Types: Scalar / Row / Table

| Type | Returns | Example shape |
|------|---------|----------------|
| **Scalar Subquery** | A single value | `3` |
| **Row Subquery** | Multiple rows, single column | `1` / `2` / `3` |
| **Table Subquery** | Multiple rows & multiple columns | `1, A` / `2, B` / `3, C` |

```sql
-- SCALAR: returns one value
SELECT (SELECT MAX(Sales) FROM Orders) AS max_sale;

-- ROW: returns a column of values
WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE Country = 'USA')

-- TABLE: returns a result set used as a table
FROM (SELECT CustomerID, SUM(Sales) AS total FROM Orders GROUP BY CustomerID) t
```

### 3.5 Subquery in FROM Clause

> Use a subquery as if it were a **temporary table**. **Must** have an alias.

```sql
SELECT column1, column2, …
FROM ( SELECT column FROM table1 WHERE condition ) AS alias
```

**Example:**

```sql
-- Average total per customer
SELECT AVG(total_per_customer) AS avg_customer_value
FROM (
    SELECT CustomerID, SUM(Sales) AS total_per_customer
    FROM Orders
    GROUP BY CustomerID
) AS customer_totals;
```

> ✅ Any result type (Scalar, Row, Table) is allowed in `FROM`.

### 3.6 Subquery in SELECT Clause

> Use a subquery to return a value as a column. **Only Scalar Subqueries are allowed.**

```sql
SELECT
    Column1,
    ( SELECT column FROM table1 WHERE condition ) AS alias
FROM table1;
```

**Example:**

```sql
-- For each order, also show the total sales of all orders
SELECT
    OrderID,
    Sales,
    (SELECT SUM(Sales) FROM Orders) AS grand_total
FROM Orders;
```

> 🚦 **Rule:** Only **Scalar Subqueries** are allowed in the SELECT clause. If the inner query returns more than one row, SQL will error.

### 3.7 Subquery in WHERE — Comparison Operators

> Use a subquery on the right side of a comparison operator. **Only Scalar Subqueries** can be used with `=`, `!=`, `<`, `>`, `<=`, `>=`.

```sql
SELECT column1, column2, …
FROM    table1
WHERE   column = ( SELECT column FROM table2 WHERE condition )
```

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | Equal | `WHERE Sales = (SELECT AVG(Sales) FROM Orders)` |
| `!=` or `<>` | Not Equal | `WHERE Sales != (SELECT AVG(Sales) FROM Orders)` |
| `>` | Greater than | `WHERE Sales > (SELECT AVG(Sales) FROM Orders)` |
| `<` | Less than | `WHERE Sales < (SELECT AVG(Sales) FROM Orders)` |
| `>=` | Greater than or equal to | `WHERE Sales >= (SELECT AVG(Sales) FROM Orders)` |
| `<=` | Less than or equal to | `WHERE Sales <= (SELECT AVG(Sales) FROM Orders)` |

### 3.8 Subquery in WHERE — Logical Operators (IN, ANY, ALL, EXISTS)

When you need to compare against **multiple values**, use logical operators:

| Operator | Description | Example |
|----------|-------------|---------|
| `IN` | Checks if a value matches any value in a list | `WHERE Sales IN (SELECT …)` |
| `NOT IN` | Checks if a value does NOT match any value in a list | `WHERE Sales NOT IN (SELECT …)` |
| `EXISTS` | Checks if subquery returns **any rows** | `WHERE EXISTS (SELECT …)` |
| `NOT EXISTS` | Checks if subquery returns **no rows** | `WHERE NOT EXISTS (SELECT …)` |
| `ANY` | Returns true if value matches **any** value in the list | `WHERE Sales < ANY (SELECT …)` |
| `ALL` | Returns true if value matches **all** values in the list | `WHERE Sales > ALL (SELECT …)` |

#### IN Operator

```sql
SELECT column1, column2, …
FROM    table1
WHERE   column IN ( SELECT column FROM table2 WHERE condition );
```

```sql
-- All orders from customers in the USA
SELECT *
FROM Orders
WHERE CustomerID IN (
    SELECT CustomerID FROM Customers WHERE Country = 'USA'
);
```

#### ALL Operator

```sql
SELECT column1, column2, …
FROM    table1
WHERE   column < ALL ( SELECT column FROM table1 WHERE condition );
```

> Returns true only if the value matches the comparison against **every** value returned by the subquery.

```sql
-- Find products cheaper than EVERY product in 'Electronics'
SELECT *
FROM Products
WHERE Price < ALL (SELECT Price FROM Products WHERE Category = 'Electronics');
```

#### ANY Operator

```sql
SELECT column1, column2, …
FROM    table1
WHERE   column < ANY ( SELECT column FROM table1 WHERE condition );
```

> Returns true if the value matches the comparison against **at least one** value returned by the subquery.

```sql
-- Find products cheaper than AT LEAST ONE product in 'Electronics'
SELECT *
FROM Products
WHERE Price < ANY (SELECT Price FROM Products WHERE Category = 'Electronics');
```

#### IN vs ANY vs ALL — Quick Comparison

| Operator | Logic | True when… |
|----------|-------|------------|
| `= ANY` | Same as `IN` | Value matches **at least one** in the list |
| `<> ALL` | Same as `NOT IN` | Value matches **none** in the list |
| `< ANY` | Less than the **max** | Smaller than at least one value |
| `< ALL` | Less than the **min** | Smaller than every value |
| `> ANY` | Greater than the **min** | Bigger than at least one value |
| `> ALL` | Greater than the **max** | Bigger than every value |

### 3.9 Correlated vs Non-Correlated Subqueries

This is the second big classification axis:

| Aspect | Non-Correlated Subquery | Correlated Subquery |
|--------|--------------------------|----------------------|
| **Definition** | Subquery is **independent** of the main query | Subquery is **dependent** on the main query |
| **Execution** | Executed **once**; result reused by main query | Executed **for each row** processed by the main query |
| **Standalone Run** | ✅ **Can** be executed on its own | ❌ **Can't** be executed on its own |
| **Readability** | ✅ Easier to read | ❌ Harder to read, more complex |
| **Performance** | ✅ Faster (runs once) | ❌ Slower (runs many times) |
| **Typical Usage** | Static comparisons, filtering with constants | Row-by-row comparisons, dynamic filtering |

#### Non-Correlated Example

```sql
-- The inner query runs ONCE and produces a single number
SELECT *
FROM Orders
WHERE Sales > (SELECT AVG(Sales) FROM Orders);   -- independent subquery
```

#### Correlated Example (uses outer table)

```sql
-- Inner query references the outer table — it runs for EACH outer row
SELECT
    o.OrderID,
    o.CustomerID,
    (SELECT COUNT(*)
     FROM Orders o2
     WHERE o2.CustomerID = o.CustomerID) AS orders_by_same_customer
FROM Orders o;
```

### 3.10 How EXISTS Works

> **`EXISTS`** is a logical operator that returns **TRUE** if the subquery returns at least one row, otherwise **FALSE**. The actual values returned by the subquery are ignored — only existence matters.

```
                  For each row in
                    Main Query
                         │
                         ▼
                  Run Subquery
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
       Returns no rows?       Returns rows?
              │                     │
              ▼                     ▼
       Row excluded         Row included
```

#### Correlated EXISTS Example

```sql
SELECT column1, column2, …
FROM   Table2
WHERE  EXISTS (
   SELECT 1
   FROM Table1
   WHERE Table1.ID = Table2.ID
);
```

```sql
-- All customers who have at least one order
SELECT c.*
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
);
```

> 💡 The convention `SELECT 1` is used because the actual columns don't matter — `EXISTS` only checks if any row is returned.

### 3.11 Subqueries vs JOINs

| Aspect | JOINs | Subqueries |
|--------|-------|------------|
| **Syntax** | `SELECT o.* FROM Orders o JOIN Customers c ON c.CustomerID = o.CustomerID AND c.Country = 'USA'` | `SELECT * FROM Orders WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE Country = 'USA')` |
| **Readability** | Not as easy to read & maintain | Easy to read & maintain |
| **Performance** | Fast | Slower |
| **Duplicates** | May lead to duplicates | Safer — no risk of duplicates |
| **Best Practice** | Useful with large tables | Useful with small tables |

---

## 4. CTE — Common Table Expression

### 4.1 What is a CTE?

> **A Common Table Expression (CTE) is a named temporary result set defined with the `WITH` clause that exists only for the duration of a single query.**

Think of it as a "named subquery" that you can reference like a virtual table.

### 4.2 CTE vs Subquery

```
        SUBQUERY                                 CTE
   ┌──────────────────┐                ┌──────────────────────┐
   │   MAIN QUERY     │                │  CTE QUERY           │
   │   SELECT …       │                │  SELECT …            │
   │   FROM …         │                │  FROM …              │
   │   JOIN …  ──┐    │                │  WHERE …             │
   │            ▼     │                │       │              │
   │         Result   │                │       ▼              │
   │            ▲     │                │  VIRTUAL TABLE       │
   │   SUBQUERY │     │                │   ┌────────────┐     │
   │   SELECT … │     │                │   │  SALES     │     │
   │   FROM …         │                │   └─────┬──────┘     │
   │   WHERE …        │                │         │            │
   │                  │                │  MAIN QUERY (can ref │
   │                  │                │  the CTE N times)    │
   └──────────────────┘                │  SELECT …            │
   (bottom-up: subquery                │  FROM …              │
    runs, main query uses)             │  JOIN CTE            │
                                       │  JOIN CTE  ←  (N×)   │
                                       └──────────────────────┘
                                       (top-down: CTE runs once,
                                        then referenced N times)
```

| Aspect | Subquery | CTE |
|--------|----------|-----|
| **Direction of reading** | Bottom-up (subquery first) | Top-down (CTE first, main next) |
| **Named?** | ❌ No (inline) | ✅ Yes (you give it a name) |
| **Reusable in same query?** | ❌ Must be repeated | ✅ Reference many times |
| **Readability** | Harder when nested deep | Much cleaner for multi-step logic |
| **Self-reference (recursion)?** | ❌ No | ✅ Yes (Recursive CTE) |
| **Execution order** | Inner → outer | Top → bottom |

#### Step-by-Step Comparison (Same Problem, Different Style)

A problem solved with both approaches:

```
SUBQUERY (Bottom-up)             CTE (Top-down)
─────────────────────             ───────────────
Step 4: Aggregations (AVG)        Step 1: JOIN
Step 3: JOIN                      Step 2: Aggregations (SUM)
Step 2: Aggregations (SUM)        Step 3: Aggregations (AVG)
Step 1: JOIN
```

### 4.3 Benefits of CTEs

A CTE is favored for **3 reasons**:

| Benefit | What it means |
|---------|----------------|
| **Readability** | Multi-step queries become easy to follow |
| **Modularity** | Break complex logic into named building blocks |
| **Reusability** | A single CTE can be referenced multiple times in the same query |

Example shape:

```sql
WITH CTE_Top_Customers AS (SELECT … FROM Customer WHERE …),
     CTE_Top_Products  AS (SELECT … FROM Products JOIN …),
     CTE_Daily_Revenue AS (SELECT … FROM Orders   JOIN …)
SELECT …
FROM CTE_Top_Customers
JOIN CTE_Top_Products  …
JOIN CTE_Daily_Revenue …;
```

### 4.4 How DB Executes a CTE

The DB engine executes a CTE like a **temporary in-memory result** (sometimes stored briefly in the cache), then uses it in the main query.

```
MAIN QUERY:
  SELECT …
  FROM ORDERS
  JOIN Details
  JOIN Details      ← references the CTE several times
  JOIN Details

CTE QUERY:
  WITH Details AS (
     SELECT …
  )
```

The CTE result lives in **memory only**, and it disappears as soon as the outer query is done.

### 4.5 CTE Types Overview

```
                        ┌──────  CTE TYPES  ──────┐
                        │                          │
                  Non-Recursive               Recursive
                  ┌─────┴──────┐
              Standalone     Nested
```

| Type | Description |
|------|--------------|
| **Standalone CTE** | A single, self-contained CTE that doesn't depend on another CTE |
| **Nested CTE** | A CTE built **on top of** another CTE (multi-stage transformation) |
| **Recursive CTE** | A CTE that **calls itself** — used for hierarchical / iterative data |

### 4.6 Standalone CTE

#### Syntax

```sql
WITH CTE_Name AS
(
    SELECT …           -- CTE Query
    FROM …             -- (CTE Definition)
    WHERE …
)

SELECT …
FROM CTE_Name          -- Main Query (CTE Usage)
WHERE …;
```

#### Example

```sql
WITH HighValueOrders AS (
    SELECT CustomerID, SUM(Sales) AS total
    FROM Orders
    GROUP BY CustomerID
    HAVING SUM(Sales) > 1000
)
SELECT c.Name, h.total
FROM Customers c
JOIN HighValueOrders h ON c.CustomerID = h.CustomerID;
```

### 4.7 Multiple CTEs

You can chain multiple **independent** CTEs separated by commas, then use them all together in the main query.

```sql
WITH CTE_Name1 AS
(
    SELECT …
    FROM …
    WHERE …
)
, CTE_Name2 AS
(
    SELECT …
    FROM …
    WHERE …
)

SELECT …
FROM CTE_Name1
JOIN CTE_Name2
WHERE …;
```

> 📝 Only the **first** CTE uses `WITH`; subsequent CTEs are introduced with a comma. Don't write `WITH` again.

### 4.8 Nested CTEs

A **nested** CTE uses an **earlier CTE** in its own definition.

```sql
WITH CTE_Name1 AS                      -- Standalone CTE
(
    SELECT …
    FROM …
    WHERE …
)
, CTE_Name2 AS                         -- Nested CTE (uses CTE_Name1)
(
    SELECT …
    FROM CTE_Name1                      -- ← references previous CTE
    WHERE …
)

SELECT …
FROM CTE_Name2
WHERE …;
```

### 4.9 Recursive CTE

#### Definition

> **A Recursive CTE is a self-referencing CTE that repeatedly processes data until a specific condition (break condition) is met.**

Comparison:

| Type | Behavior |
|------|----------|
| **Non-Recursive CTE** | Executed **only once** without any repetition |
| **Recursive CTE** | Self-referencing query that **repeatedly processes** data until a break condition is met |

#### Recursive CTE Syntax

```sql
WITH CTE_Name AS
(
    -- ===== ANCHOR QUERY =====
    SELECT …
    FROM …
    WHERE …

    UNION ALL

    -- ===== RECURSIVE QUERY =====
    SELECT …
    FROM CTE_Name                       -- self-reference
    WHERE [Break Condition]
)

SELECT …
FROM CTE_Name
WHERE …;
```

| Part | Role |
|------|------|
| **Anchor Query** | Runs once. Returns the starting set (base case). |
| **UNION ALL** | Combines results across iterations. **Must be `UNION ALL`** (not `UNION`). |
| **Recursive Query** | References the CTE itself. Runs repeatedly, using the previous iteration's output. |
| **Break Condition** | Filters the recursive query so eventually no rows are returned, stopping the loop. |

#### Execution Flow

```
            ┌─────────────┐
            │    START    │
            └──────┬──────┘
                   ▼
            ┌─────────────────┐
            │ Run Anchor Query│
            └──────┬──────────┘
                   ▼
        ┌─────────────────────────┐
        │ Run Recursive Query     │ ◄────┐
        └──────┬──────────────────┘      │
               ▼                         │
        ┌─────────────────┐  FALSE       │
        │ Break Condition │──────────────┘
        │   met?          │
        └──────┬──────────┘
               │ TRUE
               ▼
            ┌─────────────┐
            │     END     │
            └─────────────┘
```

#### Example 1 — Generate Sequence 1 to 20

```sql
WITH Series AS (
    -- Anchor: start from 1
    SELECT 1 AS MyNumber

    UNION ALL

    -- Recursive: keep adding 1 until 20
    SELECT MyNumber + 1
    FROM Series
    WHERE MyNumber < 20
)
SELECT * FROM Series;
```

**Output:** A column `MyNumber` with values 1, 2, 3, …, 20.

#### Example 2 — Employee Hierarchy (Manager-Employee Tree)

Source data:

| EmployeeID | FirstName | ManagerID |
|------------|-----------|------------|
| 1 | Frank | NULL |
| 2 | Kevin | 1 |
| 3 | Mary | 1 |
| 4 | Michael | 2 |
| 5 | Carol | 3 |

```sql
WITH CTE_Emp_Hierarchy AS
(
    -- Anchor: top-level employees (no manager)
    SELECT
        EmployeeID,
        FirstName,
        ManagerID,
        1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive: find subordinates of already-discovered employees
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        Level + 1
    FROM Sales.Employees AS e
    INNER JOIN CTE_Emp_Hierarchy ceh
            ON e.ManagerID = ceh.EmployeeID
)
SELECT * FROM CTE_Emp_Hierarchy;
```

**Result:**

| EmployeeID | FirstName | ManagerID | Level |
|------------|-----------|-----------|-------|
| 1 | Frank | NULL | 1 |
| 2 | Kevin | 1 | 2 |
| 3 | Mary | 1 | 2 |
| 4 | Michael | 2 | 3 |
| 5 | Carol | 3 | 3 |

> 💡 **Recursive CTEs are the standard tool** for hierarchies (org charts, parent-child categories), generating number/date series, and graph traversal problems.

#### Visual Recap of CTE Types

```
   STANDALONE              NESTED                 RECURSIVE
   ───────────             ──────                 ─────────
   ┌─ CTE ─┐               ┌─ CTE 1 ─┐            ┌─ CTE ──┐
   │  …    │               │   …     │            │  CTE   │ ← self-references
   └───┬───┘               └────┬────┘            └────┬───┘
       │                        │                      │
       ▼                        ▼                      ▼
   ┌─ MAIN ─┐              ┌─ CTE 2 ─┐            ┌─ MAIN ─┐
   │ CTE    │              │  CTE 1  │            │  CTE   │
   │  …     │              └────┬────┘            │  …     │
   └────────┘                   ▼                 └────────┘
                           ┌─ MAIN ─┐
                           │ CTE 2  │
                           └────────┘
```

---

## 5. Views

### 5.1 Database Structure (DDL Hierarchy)

Views are created using **DDL** (Data Definition Language) — `CREATE`, `ALTER`, `DROP`.

The DB hierarchy:

```
                       SQL SERVER
                            │
                ┌───────────┴────────────┐
                ▼                        ▼
              SALES DB                  HR DB
                │
        ┌───────┴────────┐
        ▼                ▼
    SALES Schema    CUSTOMERS Schema
        │
   ┌────┴─────┐
   ▼          ▼
  TABLE     VIEW
   │         │
   ▼         ▼
COLUMNS   COLUMNS
   │
   ▼
 KEYS
```

> A **View** lives alongside Tables inside a Schema, inside a Database, inside the SQL Server.

### 5.2 3-Layer Architecture of a Database

Modern databases have **3 layers of abstraction**:

| Layer | Aka | Contents | Audience |
|-------|-----|----------|----------|
| **View Layer** | External | Views (Views 1, 2, …, N) | Business Analysts, Power BI, End Users |
| **Logical Layer** | Conceptual | Tables, Relationships, **Views**, Indexes, Procedures, Functions | App Developer, Data Engineer |
| **Physical Layer** | Internal | Data Files, Partitions, Logs, Catalog, Blocks, Caches → DB | DBA |

> Abstraction increases as we move from **Physical → Logical → View**.

### 5.3 What is a View?

> **A View is a virtual table based on the result set of a query, without storing the data in the database. Views are persisted SQL queries in the database.**

Visually:

```
   TABLE                          QUERY  →  VIEW                 QUERY
  (Physical                       (Virtual Table)              (USER's query)
   Table)                                                       SELECT
   ┌─────┐                        ┌──────────────┐               FROM View
   │  ▒  │  ◄────  REAL DATA ──── │ SELECT FROM  │  ◄─────────►  WHERE …
   └─────┘                        │  JOIN WHERE  │
                                  └──────────────┘
   ◄──── Real Data ────  ABSTRACTION LAYER  ────  YOU ────►
```

A view is essentially a **stored SELECT query** that anyone can query as if it were a table.

### 5.4 Views vs Tables

| Property | VIEW | TABLE |
|----------|------|-------|
| **Persistence** | ❌ No data persistence | ✅ Persisted data |
| **Maintenance** | ✅ Easy to maintain | ❌ Hard to maintain |
| **Response Time** | 🐢 Slow response | ⚡ Fast response |
| **Operations** | Read only (by default) | Read / Write |
| **Flexibility** | ✅ Flexible (just a query) | ❌ Hard to change schema |

> A View is a "live window" into table(s). Every time you query the view, the underlying SELECT runs against the current data.

### 5.5 Views as Central Logic

Without views, three analysts each rewrite the same `SUM + JOIN` logic in three separate queries → **redundancy & complexity**.

With a view, that logic lives **once** in the view, and analysts just query the view:

```
   ┌──────┐
   │ORDERS│ ────┐                                         ┌─── RANK ────► Financial Analyst
   └──────┘     ▼
              ┌─────────────────┐    ┌──────────────────┐
              │ VIEW            │ ─► │ INTERMEDIATE     │ ─► MAX/MIN ──► Budget Analyst
              │  SUM + JOIN     │    │  RESULT          │
              │ (Central Logic) │    └──────────────────┘
              └─────────────────┘                          ┌─── COMPARE ─► Risk Analyst
   ┌──────┐     ▲
   │CUST. │ ────┘
   └──────┘
```

✅ Reduce **redundancy** and **complexity**.

### 5.6 Views vs CTE

| Aspect | Views | CTE |
|--------|-------|-----|
| **Redundancy reduction** | Across **multiple queries** | Within **one query** |
| **Reusability** | Across **multiple queries** | Within **one query** |
| **Logic** | **Persisted** logic (in DB) | **Temporary** logic (on the fly) |
| **Maintenance** | Need to maintain (`CREATE` / `DROP`) | No maintenance (auto cleanup) |

> 💡 If multiple separate queries need the same intermediate result → **View**.
> If only one query needs the intermediate, multiple times → **CTE**.

### 5.7 Views Syntax (CREATE / ALTER / DROP)

#### CREATE VIEW

```sql
CREATE VIEW View_Name AS
(
    SELECT …
    FROM …
    WHERE …
);
```

#### Using the View

```sql
SELECT * FROM View_Name WHERE …;
```

#### Replace / Alter / Drop

```sql
-- Replace (SQL Server, Postgres, MySQL syntax varies)
CREATE OR ALTER VIEW View_Name AS  ... ;

ALTER VIEW View_Name AS  ... ;

DROP VIEW View_Name;
```

### 5.8 Use Cases for Views

The slides identify **5 main use cases**:

#### Use Case 1: Flexibility & Dynamic

> When underlying tables change, you can fix the view's SELECT once, and **all consumers** see the corrected data immediately.

```
TABLE (F,Z,B) + TABLE (C,D)  ──►  VIEW (A,B,C,D)  ──►  Query 1, Query 2, Query 3
                ▲
                │ CHANGES happen
```

Change the underlying tables → update the view's SELECT → consumers don't need to change their queries.

#### Use Case 2: Hide Complexity

Imagine 4 cryptic tables `tbl_wrkfrc_dtl`, `tbl_prsnl_mstr`, `tbl_hcap_mgmt`, `tbl_rsrc_rcrd` that all need to be joined together. Expose them as a single readable view called `Employee_Overview`.

```
4 tables  ──►  VIEW: Employee_Overview  ──►  SELECT FROM Employee_Overview
              (4 messy JOINs hidden)
```

End users never see the join complexity.

#### Use Case 3: Security

Different audiences see **different slices** of the same `Orders` table:

| Audience | View | Allowed Data |
|----------|------|--------------|
| Manager | `ORDERS_MANAGERS` | All data (columns A, B, C, D) |
| Data Analyst | `ORDERS_ANALYSTS` | Column-level security (D hidden) |
| Student | `ORDERS_STUDENTS` | Column **and** row-level security |

A view can restrict **which columns** and **which rows** each user sees, without changing the underlying table.

#### Use Case 4: Multiple Languages

Same `Orders` table, two views renaming columns into local languages:

| View | Audience |
|------|----------|
| `Bestellung` (German) | German users |
| `आदेश` (Hindi) | Hindi users |

Underlying table stays in English; views provide language-friendly facades.

#### Use Case 5: Virtual Data Marts

The traditional data flow:

```
Source Systems → Data Warehouse → Data Marts (Sales Mart, Finance Mart) → Reporting
   ERP/CRM/Logs   PHYSICAL Layer        VIRTUAL Layer (Views!)
```

Instead of building physical data marts (more storage, ETL effort), expose them as **views** over the warehouse — same logic, no extra storage. Sales analysts query "Sales Mart" view, Finance analysts query "Finance Mart" view.

---

## 6. CTAS — Create Table As SELECT

### 6.1 What is a Table?

> A table is a structured collection of rows and columns, stored as files on disk in the database.

```
DATABASE FILES                     COLUMNS
   ┌────────┐                    ┌───┬─────┬──────┐
   │ FILE 1 │ ◄───── stores ──── │ID │NAME │SCORE │
   │ FILE 2 │                    ├───┼─────┼──────┤
   │ FILE 3 │                    │ 1 │John │ 20   │  ◄── ROW
   └────┬───┘                    │ 2 │Mary │ 50   │  ◄── CELL highlighted
        ▼                        │ 3 │Mart.│ 30   │
       DISK                      └───┴─────┴──────┘
```

Key structural elements: **Rows**, **Columns**, **Cells**.

### 6.2 Table Types

```
                      TABLE TYPES
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
         PERMANENT                  TEMPORARY
         TABLE                       TABLE
              │
        ┌─────┴──────┐
        ▼            ▼
   CREATE/INSERT    CTAS
```

Two big families:

| Family | When deleted |
|--------|--------------|
| **Permanent Table** | Persists until you explicitly `DROP` it |
| **Temporary Table** | Auto-deleted at the end of the session |

Permanent tables can be created two ways:
1. **`CREATE TABLE` + `INSERT`** (define schema, then load rows separately)
2. **CTAS** — create the table directly from a SELECT result

### 6.3 CREATE / INSERT vs CTAS

```
    CREATE/INSERT                          CTAS
    ─────────────                          ────

    Step 1: CREATE                        Step 1: QUERY
       │                                     │
       ▼                                     ▼
     TABLE (empty)                         RESULT
       ▲                                     │
       │                                     ▼
    Step 2: INSERT                         TABLE (filled)
    from CSV / data
```

| Approach | Steps | Use Case |
|----------|-------|----------|
| **CREATE + INSERT** | (1) Define schema (2) Insert rows | When you have raw data to load (CSV, manual rows) |
| **CTAS** | (1) Run a SELECT → table created with that data | When the new table is the **result** of an existing query |

#### CREATE / INSERT Syntax

```sql
-- DDL statement: define the schema
CREATE TABLE Table_Name
(
    ID   INT,
    Name VARCHAR(50)
);

-- INSERT data
INSERT INTO Table_Name
VALUES (1, 'Frank');
```

### 6.4 CTAS Syntax (Dialect Differences)

There are **two syntactic flavors** depending on the database:

#### MySQL / Postgres / Oracle

```sql
CREATE TABLE New_Table AS
(
    SELECT …
    FROM …
    WHERE …
);
```

#### SQL Server (uses `SELECT … INTO`)

```sql
SELECT …
INTO New_Table
FROM …
WHERE …;
```

> Same result, different keyword. SQL Server is the odd one out.

### 6.5 Tables vs Views (Fresh vs Snapshot Data)

This is one of the trickiest differences:

```
UPDATE happens to underlying table  →  changes column C from 20 → 80

  VIEW                              TABLE (CTAS)
  ────                              ────────────
   ┌────────────────┐                ┌────────────────┐
   │ A   B    C     │                │ A   B    C     │
   │ 1   AA   80 ✅ │                │ 1   AA   20 ❌ │ ← OLD
   │ 2   FF   30    │                │ 2   BC   30    │
   │ 3   DD   40    │                │ 3   DD   40    │
   └────────────────┘                └────────────────┘
   USER sees FRESH                   USER sees OLD
   (View re-runs query)              (Snapshot is stale)
```

| Aspect | View | CTAS Table |
|--------|------|-------------|
| **Data freshness** | ✅ Always fresh (runs query each time) | ❌ Snapshot at creation time |
| **Storage** | No storage | Disk storage |
| **Speed** | Slower (recomputes) | Fast (already computed) |

### 6.6 CTAS Use Cases

#### Use Case 1: Optimize Performance

The expensive `SUM + JOIN` runs **once** (30 mins), saves to a CTAS table. Three analysts then run **fast** queries on that pre-computed table.

```
ORDERS+CUSTOMERS  ─CTAS (30 min)─►  SALES table  ──►  RANK, MAX/MIN, COMPARE
                                                       (all FAST)
       ◄─── ONCE ───►            ◄─── MULTIPLE TIMES ───►
```

Trade speed of consumption for one-time computation cost.

#### Use Case 2: Create Snapshot

> "I want to preserve the current state of data before performing operations that might change it."

```
ORDERS table (about to be updated)  ──CTAS──►  ORDERS snapshot
       │                                              │
       UPDATES happen                                 │
                                                      ▼
                                              Analyst analyzes
                                              the OLD state
```

Use case: audit trail, point-in-time analysis, rollback safety.

#### Use Case 3: Physical Data Marts

Same picture as the Views "Virtual Data Marts" use case, but the marts are **physical CTAS tables** instead of views:

```
ERP / CRM / Logs  →  Data Warehouse  ─CTAS (30 min each)─►  Sales Mart, Finance Mart  →  Reports
                     (Physical Layer)                       (Physical Layer)
```

✅ Fast reports.
❌ Data is a snapshot — not up-to-date until next CTAS run.

---

## 7. Temporary Tables

> **A Temporary Table is a table that exists only for the duration of a session and is automatically dropped when the session ends.**

### Syntax (SQL Server — `#` prefix and `SELECT INTO`)

```sql
SELECT …
INTO #New_Table
FROM …
WHERE …;
```

> The `#` prefix marks the table as temporary in SQL Server.

### Syntax (MySQL / Postgres / Oracle — `TEMPORARY` keyword)

```sql
CREATE TEMPORARY TABLE Table_Name AS
(
    SELECT …
    FROM …
    WHERE …
);
```

### Permanent vs Temporary Table

| | Permanent | Temporary |
|--|-----------|-----------|
| Syntax (MySQL/Postgres/Oracle) | `CREATE TABLE Name AS (SELECT …)` | `CREATE TEMPORARY TABLE Name AS (SELECT …)` |
| Syntax (SQL Server) | `SELECT … INTO New_Table FROM …` | `SELECT … INTO #New_Table FROM …` |
| Lifetime | Until you `DROP` | End of session |
| Visible to other sessions | ✅ Yes | ❌ No |

### Lifecycle Visual

```
              CREATE/INSERT                  CTAS                            TEMP
              ─────────────                  ─────                          ─────
              CREATE → TABLE                 QUERY → RESULT → TABLE         QUERY → RESULT → TEMP TABLE
                ▲                                              ✅ PERMANENT                   ❌ disappears
              INSERT (CSV)                                                                  at session end
```

### Lifecycle Comparison Table

| | View | CTAS Table | Temp Table | Empty Table |
|---|------|------------|------------|-------------|
| **Definition** | `CREATE VIEW Name AS (SELECT …)` | `SELECT … INTO New_Table FROM …` | `SELECT … INTO #New_Table FROM …` | `CREATE TABLE Name (ID INT, Name VARCHAR(50))` |
| **Stores Data** | ❌ | ✅ Persists | ✅ Session only | ✅ Empty schema |
| **Auto-deleted** | ❌ | ❌ | ✅ (session end) | ❌ |

---

## 8. The Big-Picture Comparison

This single table — the most important one in this module — compares **all 5 techniques** across **6 dimensions**:

| Dimension | Subquery | CTE | TMP (Temp Table) | CTAS | View |
|-----------|----------|-----|------------------|------|------|
| **Storage** | Memory | Memory | Disk | Disk | ❌ No storage |
| **Life Time** | Temporary | Temporary | Temporary | Permanent | Permanent |
| **When Deleted** | End of Query | End of Query | End of Session | DDL — `DROP` | DDL — `DROP` |
| **Scope** | Single-Query | Single-Query | Multi-Queries | Multi-Queries | Multi-Queries |
| **Reusability** | Limited (1 place – 1 query) | Limited (multi places – 1 query) | Medium (multi queries during session) | High (multi queries) | High (multi queries) |
| **Up-to-Date Data** | ✅ | ✅ | ❌ (snapshot) | ❌ (snapshot) | ✅ |

> 💡 **How to choose:**
> - Need it once in one query? → **Subquery** or **CTE** (CTE if multi-step or reused).
> - Need it across multiple queries in a session, but it's expensive? → **Temp Table**.
> - Need a permanent, fast-to-query snapshot? → **CTAS**.
> - Need permanent, **always fresh** access for many consumers? → **View**.

---

## 9. Stored Procedures

### 9.1 What is a Stored Procedure?

> **A Stored Procedure is a saved program (named block of SQL code) stored on the database server. It can be executed by name (`EXEC`) from any client.**

```
   SERVER                                                  CLIENT
   ──────                                                  ──────

   Stored Procedure                                         ┌─────┐
   ┌──────────────┐                                         │ APP │
   │ INSERT       │ ──┐                                     └─────┘
   │ UPDATE       │ ──┼──►  DATABASE  ◄──────  EXEC SP  ◄── User
   │ SELECT       │ ──┘                                     ┌───┐
   └──────────────┘                                         │ … │
                                                            └───┘
```

The SP **runs on the server**, hits the DB directly, and returns a result.

### 9.2 Stored Procedure vs Query

A Stored Procedure is **more than a query** — it includes programming features:

| Stored Procedure (Program) | Query (Single Request) |
|-----------------------------|------------------------|
| **Loops** 🔁 | One-shot |
| **Control Flow** (IF/ELSE/CASE) | Just one SELECT/UPDATE/etc. |
| **Parameters** (inputs) | Hard-coded values |
| **Error Handling** ⚠️ | No built-in error handling |
| Multiple SQL statements (INSERT, UPDATE, SELECT) | A single statement |

A query is a "request"; a stored procedure is a "program".

### 9.3 Stored Procedure vs Python

Stored procedures are **similar to a Python script** that talks to the DB — both can have loops, control flow, parameters, and error handling. The difference is **where the code lives**:

| Stored Procedure | Python |
|------------------|--------|
| Runs **inside** the database server | Runs **outside** the database |
| Closer to data → less network traffic | Sends queries over the network |
| Limited to SQL features | Full general-purpose language |

### 9.4 Syntax — CREATE PROCEDURE / EXEC

#### Define a Stored Procedure

```sql
CREATE PROCEDURE ProcedureName AS
BEGIN

    -- SQL STATEMENTS GO HERE

END
```

#### Execute (Call) a Stored Procedure

```sql
EXEC ProcedureName;
```

#### Example

```sql
CREATE PROCEDURE GetTopCustomers AS
BEGIN
    SELECT TOP 10 CustomerID, SUM(Sales) AS total
    FROM Orders
    GROUP BY CustomerID
    ORDER BY total DESC;
END

-- Call it
EXEC GetTopCustomers;
```

### 9.5 Error Handling (TRY / CATCH)

> Stored procedures support structured error handling — if anything in the `TRY` block fails, control jumps to the `CATCH` block.

#### Syntax

```sql
BEGIN TRY
    -- SQL statements that might cause an error
END TRY

BEGIN CATCH
    -- SQL statements to handle the error
END CATCH
```

#### Flow

```
            ┌─────────┐
            │  Start  │
            └────┬────┘
                 ▼
        ┌────────────────┐
        │  Execute TRY   │
        └────┬───────┬───┘
             │       │
        No Error   Error
             │       │
             │       ▼
             │  ┌────────────────┐
             │  │ Execute CATCH  │
             │  └────────┬───────┘
             │           │
             └─────┬─────┘
                   ▼
                ┌─────┐
                │ End │
                └─────┘
```

#### Example

```sql
CREATE PROCEDURE InsertOrder
    @CustomerID INT,
    @Sales DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Orders (CustomerID, Sales)
        VALUES (@CustomerID, @Sales);
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
        -- log the error, send a notification, etc.
    END CATCH
END
```

### 9.6 Flow Control

Stored procedures support **conditional logic** — `IF / ELSE`, `CASE`, loops.

#### Conceptual Flow

```
            ┌─────────┐
            │  Start  │
            └────┬────┘
                 ▼
        ┌────────────────┐  Yes  ┌──────────────┐
        │ Value is NULL? │ ────► │ Update to 0  │
        └────────┬───────┘       └──────┬───────┘
                 │ No                   │
                 │                      │
                 └─────┬────────────────┘
                       ▼
                    ┌─────┐
                    │ End │
                    └─────┘
```

#### IF Syntax Example

```sql
CREATE PROCEDURE CleanNulls AS
BEGIN
    IF EXISTS (SELECT 1 FROM Sales WHERE Amount IS NULL)
        UPDATE Sales SET Amount = 0 WHERE Amount IS NULL;
    ELSE
        PRINT 'No NULL values found.';
END
```

---

## 10. Triggers

### 10.1 What is a Trigger?

> **A Trigger is a special kind of stored procedure that automatically runs in response to an event (`INSERT`, `UPDATE`, `DELETE`) on a table.**

```
   EVENT: INSERT ──┐
                   │
   EVENT: UPDATE ──┼──► TABLE ──🔋──► TRIGGER ──► INSERT into log table
                   │                              CHECK conditions
   EVENT: DELETE ──┘                              WARNING / raise error
```

Triggers cannot be called manually — they fire **automatically** when an event occurs.

### 10.2 Trigger Types

```
                      TRIGGER TYPES
                            │
              ┌─────────────┼─────────────┐
              ▼             ▼             ▼
          DML Triggers   DDL Triggers    LOGON Triggers
              │             │
       (INSERT/UPDATE/   (CREATE /
        DELETE)           ALTER /
              │           DROP)
       ┌──────┴──────┐
       ▼             ▼
    AFTER       INSTEAD OF
```

| Type | Fires On | Examples |
|------|----------|----------|
| **DML Triggers** | Data changes (`INSERT`, `UPDATE`, `DELETE`) | Audit logging, validation |
| **DDL Triggers** | Schema changes (`CREATE`, `ALTER`, `DROP`) | Prevent unauthorized schema edits |
| **LOGON Triggers** | A user logs into the server | Restrict access, log sessions |

DML triggers have two timing modes:

| Timing | Behavior |
|--------|----------|
| **AFTER** | Fires **after** the event happens (most common) |
| **INSTEAD OF** | Fires **instead of** the event — replaces the original action |

### 10.3 Use Case: Maintaining Logs

The most common use of triggers — **automatically audit changes** to a table.

```
   Employees Table                              LOGS Table
   ┌──┬──────┬─────┬──────┐                    ┌──┬──────┐
   │Id│Name  │Dept │Salary│                    │1 │2025  │
   ├──┼──────┼─────┼──────┤                    │2 │2026  │
   │1 │Maria │HR   │70K   │ ─── INSERT ──🔋──► │3 │2027  │
   │2 │John  │Sales│80K   │      TRIGGER       │…  │…    │
   │3 │Max   │HR   │70K   │                    └──┴──────┘
   └──┴──────┴─────┴──────┘
```

Every time a row is inserted into `Employees`, the trigger automatically logs the change.

### 10.4 Trigger Syntax

#### Generic Pattern

```sql
CREATE TRIGGER TriggerName ON TableName
AFTER INSERT, UPDATE, DELETE    -- WHEN: the event
BEGIN
    -- WHAT: the SQL statements to run
END
```

| Part | Meaning |
|------|---------|
| **WHEN** | `AFTER INSERT, UPDATE, DELETE` → the event that fires the trigger |
| **WHAT** | The SQL block to execute when the event happens |

#### Concrete Example: Log Every New Employee

```sql
CREATE TRIGGER trg_LogNewEmployee
ON Employees
AFTER INSERT
AS
BEGIN
    INSERT INTO Employee_Logs (Action, ChangedAt)
    SELECT 'INSERT', GETDATE()
    FROM inserted;
END
```

> 💡 SQL Server gives you two special "virtual tables" inside a trigger:
> - **`inserted`** — rows that were inserted/updated (NEW values)
> - **`deleted`** — rows that were deleted/updated (OLD values)

---

## 11. Common Edge Cases & Tricky Behaviors

### ⚠️ Edge Case 1: Subquery in SELECT must return ONE value

```sql
-- ❌ ERROR if subquery returns >1 row
SELECT
    OrderID,
    (SELECT CustomerName FROM Customers) AS name   -- many rows!
FROM Orders;

-- ✅ Filter so it returns exactly one
SELECT
    OrderID,
    (SELECT CustomerName FROM Customers c WHERE c.CustomerID = o.CustomerID) AS name
FROM Orders o;
```

### ⚠️ Edge Case 2: Subquery in FROM MUST have an alias

```sql
-- ❌ ERROR
SELECT * FROM (SELECT * FROM Orders);

-- ✅ Add an alias
SELECT * FROM (SELECT * FROM Orders) AS o;
```

### ⚠️ Edge Case 3: `NOT IN` with NULLs returns no rows

```sql
-- If the subquery contains NULL, NOT IN can return zero rows!
SELECT * FROM Orders
WHERE CustomerID NOT IN (SELECT CustomerID FROM Customers);

-- Safer: use NOT EXISTS
SELECT * FROM Orders o
WHERE NOT EXISTS (
    SELECT 1 FROM Customers c WHERE c.CustomerID = o.CustomerID
);
```

This is because `x NOT IN (1, 2, NULL)` evaluates to `UNKNOWN`, which filters the row out.

### ⚠️ Edge Case 4: Recursive CTE must use `UNION ALL`

```sql
-- ❌ ERROR
WITH r AS (
    SELECT 1 AS n
    UNION                       -- must be UNION ALL
    SELECT n+1 FROM r WHERE n < 5
)
```

`UNION` removes duplicates and is not allowed in recursive CTEs.

### ⚠️ Edge Case 5: Recursive CTE infinite loop

Without a proper break condition, recursion will hit the DB's **maximum recursion limit** and error out:

```sql
-- ❌ Bad — never stops (no break condition)
WITH r AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n+1 FROM r           -- missing WHERE!
)
SELECT * FROM r;
```

Most DBs default to 100 recursion levels. Override (with caution) via `OPTION (MAXRECURSION 0)` in SQL Server.

### ⚠️ Edge Case 6: Views are not always updatable

A view that joins multiple tables, uses `GROUP BY`, `DISTINCT`, or aggregation **cannot** be updated. Single-table views with no aggregation are usually updatable.

### ⚠️ Edge Case 7: CTAS doesn't always copy constraints

A CTAS table **inherits column types and data**, but may **not** copy primary keys, foreign keys, indexes, or NOT NULL constraints — depending on the database. Always recreate constraints explicitly if needed.

### ⚠️ Edge Case 8: Temp tables disappear with session

If you connect, create `#temp`, then disconnect — `#temp` is gone. Reconnect ≠ same session.

### ⚠️ Edge Case 9: Correlated subquery performance

A correlated subquery runs **once per outer row** — for a 1M-row outer table, that's 1M subquery executions. Often a `JOIN` or `EXISTS` rewrite is dramatically faster.

### ⚠️ Edge Case 10: Triggers and infinite recursion

A trigger on table `A` that updates table `A` can fire **itself** → infinite recursion. Always check if a trigger could trigger itself, and use `IF UPDATE(column)` or row-level guards.

---

## 12. Interview Questions & Answers

### Conceptual

**Q1. What is a subquery? What are its types?**
A subquery is a query inside another query. It's classified along three axes:
- **By result type:** Scalar (single value), Row (one column, many rows), Table (many rows, many columns).
- **By dependency:** Non-Correlated (independent, runs once) or Correlated (depends on the outer query, runs per row).
- **By location:** Used in SELECT, FROM, JOIN, or WHERE clauses.

---

**Q2. What's the difference between a Correlated and Non-Correlated subquery?**

| Aspect | Non-Correlated | Correlated |
|--------|----------------|-------------|
| Depends on outer? | No | Yes |
| Runs how often? | Once | Once per outer row |
| Standalone? | Yes | No |
| Performance | Faster | Slower |

---

**Q3. What is `EXISTS` and how is it different from `IN`?**
- `EXISTS` is a logical operator that returns TRUE if the subquery returns **at least one row**. It only checks **existence**, ignoring the actual values.
- `IN` checks if a value matches **any value** in a list of values returned by the subquery.

Key difference: `IN` returns no rows if the subquery contains NULL; `EXISTS` doesn't have this problem and is often faster on large datasets.

---

**Q4. What is the difference between Subqueries and JOINs?**

| Aspect | JOINs | Subqueries |
|--------|-------|------------|
| Readability | Harder | Easier |
| Performance | Faster | Slower |
| Duplicates risk | Yes | No |
| Best for | Large tables | Small tables |

---

**Q5. What is a CTE? How is it different from a Subquery?**
A CTE is a **named** temporary result set defined with `WITH`. Differences from subqueries:
- Top-down readability (CTE first, then main query).
- Can be **referenced multiple times** in the same query.
- Supports **recursion** (subqueries cannot).
- Better readability for multi-step logic.

---

**Q6. What are the types of CTEs?**
1. **Standalone CTE** — single self-contained CTE.
2. **Nested CTE** — a CTE that references an earlier CTE.
3. **Recursive CTE** — a self-referencing CTE for hierarchical/iterative data.

---

**Q7. Explain Recursive CTE.**
A Recursive CTE has two parts joined by `UNION ALL`:
1. **Anchor query** — runs once to provide the starting row(s).
2. **Recursive query** — references the CTE itself, processes the previous iteration's output, and ends when a break condition makes the WHERE clause return no rows.

Common use cases: org charts, hierarchical categories, generating number/date series, graph traversal.

---

**Q8. What is a View?**
A View is a virtual table based on a stored SELECT query. It doesn't store data — every time you query it, the underlying SELECT runs against current data. Views are persisted in the database catalog.

---

**Q9. Views vs Tables — main differences?**

| Property | View | Table |
|----------|------|-------|
| Persistence | ❌ | ✅ |
| Maintenance | Easy | Hard |
| Speed | Slow | Fast |
| Operations | Read | Read/Write |
| Flexibility | High | Low |

---

**Q10. Views vs CTE?**
- **Views** = persisted logic across queries.
- **CTE** = temporary logic within a single query.

If multiple queries need the same intermediate result → View. If only one query needs it (perhaps used several times in it) → CTE.

---

**Q11. List 5 use cases of Views.**
1. **Flexibility & Dynamic** — change the view's SELECT once, consumers don't need to change.
2. **Hide Complexity** — wrap complex joins behind a readable view name.
3. **Security** — column-level and row-level access control.
4. **Multiple Languages** — provide localized facades over the same table.
5. **Virtual Data Marts** — expose mart-shaped data without physical storage.

---

**Q12. What is CTAS?**
**CTAS = Create Table As SELECT.** It creates a new permanent table from the result of a SELECT query, in one step:
```sql
CREATE TABLE New_Table AS (SELECT … FROM …);   -- MySQL/Postgres/Oracle
SELECT … INTO New_Table FROM …;                -- SQL Server
```

---

**Q13. CTAS vs CREATE/INSERT — when to use each?**
- **CREATE + INSERT** — when you have raw data (e.g., from CSV) and need to define a schema first.
- **CTAS** — when the new table is the **result** of an existing query (you don't need to define the schema manually).

---

**Q14. CTAS Use Cases (3 main ones)?**
1. **Optimize performance** — pre-compute heavy results once.
2. **Create snapshots** — preserve a point-in-time view of data.
3. **Physical data marts** — materialize data for fast BI reporting.

---

**Q15. View vs CTAS — fresh vs snapshot?**
- A **View** reflects the latest data every time (the SELECT re-runs).
- A **CTAS table** is a **snapshot** — once created, it doesn't update when the underlying data changes.

---

**Q16. What is a Temporary Table?**
A Temp Table stores data on disk for the **duration of a session** only. It's automatically dropped when the session ends. SQL Server uses `#` prefix; MySQL/Postgres/Oracle use `CREATE TEMPORARY TABLE`.

---

**Q17. Compare Subquery, CTE, Temp Table, CTAS, and View.**

| | Subquery | CTE | Temp Table | CTAS | View |
|---|---------|-----|------------|------|------|
| Storage | Memory | Memory | Disk | Disk | None |
| Lifetime | Query | Query | Session | Permanent | Permanent |
| Scope | Single query | Single query | Multi-query | Multi-query | Multi-query |
| Reusability | Low | Low | Medium | High | High |
| Always fresh? | ✅ | ✅ | ❌ | ❌ | ✅ |

---

**Q18. What is a Stored Procedure?**
A Stored Procedure is a saved program (named block of SQL code) stored on the database server. It can include parameters, loops, control flow, and error handling. Called via `EXEC`.

---

**Q19. Stored Procedure vs Query?**
A query is a one-shot single request. A stored procedure is a **program** — it can have multiple statements, parameters, loops, IF/ELSE, and TRY/CATCH error handling.

---

**Q20. How do you handle errors in a Stored Procedure?**
Use `BEGIN TRY … END TRY` followed by `BEGIN CATCH … END CATCH`. If anything in TRY fails, control jumps to CATCH, which can log the error, send a notification, or take recovery action.

---

**Q21. What is a Trigger?**
A Trigger is a special stored procedure that automatically fires in response to an event (INSERT, UPDATE, DELETE) on a table. Common use: audit logging.

---

**Q22. What are the types of Triggers?**
- **DML Triggers** — on `INSERT`, `UPDATE`, `DELETE`. Can be `AFTER` or `INSTEAD OF`.
- **DDL Triggers** — on `CREATE`, `ALTER`, `DROP`.
- **LOGON Triggers** — on user login.

---

**Q23. Difference between Stored Procedure and Trigger?**
- **Stored Procedure** runs when **explicitly called** (`EXEC`).
- **Trigger** runs **automatically** in response to a table event.

---

### Practical / SQL Writing

**Q24. Write a subquery to find all orders larger than the average order.**
```sql
SELECT *
FROM Orders
WHERE Sales > (SELECT AVG(Sales) FROM Orders);
```

---

**Q25. Find customers with at least one order — use `EXISTS`.**
```sql
SELECT *
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
);
```

---

**Q26. Write a CTE that finds the top 5 customers by total sales.**
```sql
WITH CustomerTotals AS (
    SELECT CustomerID, SUM(Sales) AS total
    FROM Orders
    GROUP BY CustomerID
)
SELECT TOP 5 *
FROM CustomerTotals
ORDER BY total DESC;
```

---

**Q27. Write a Recursive CTE that generates numbers 1 to 100.**
```sql
WITH Series AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM Series
    WHERE n < 100
)
SELECT * FROM Series;
```

---

**Q28. Build the employee hierarchy with levels.**
```sql
WITH EmpHierarchy AS (
    SELECT EmployeeID, FirstName, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    SELECT e.EmployeeID, e.FirstName, e.ManagerID, h.Level + 1
    FROM Employees e
    JOIN EmpHierarchy h ON e.ManagerID = h.EmployeeID
)
SELECT * FROM EmpHierarchy ORDER BY Level;
```

---

**Q29. Create a view that shows orders along with customer name.**
```sql
CREATE VIEW Orders_With_Customer AS
SELECT o.OrderID, o.OrderDate, o.Sales, c.CustomerName
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID;
```

---

**Q30. Create a snapshot of the `Orders` table using CTAS.**
```sql
-- MySQL/Postgres/Oracle
CREATE TABLE Orders_Snapshot_2026_05_14 AS
SELECT * FROM Orders;

-- SQL Server
SELECT *
INTO Orders_Snapshot_2026_05_14
FROM Orders;
```

---

**Q31. Write a Stored Procedure that takes a CustomerID and returns their orders.**
```sql
CREATE PROCEDURE GetCustomerOrders
    @CustomerID INT
AS
BEGIN
    SELECT * FROM Orders WHERE CustomerID = @CustomerID;
END

-- Call it
EXEC GetCustomerOrders @CustomerID = 42;
```

---

**Q32. Write a Trigger that logs every new row inserted into `Employees`.**
```sql
CREATE TRIGGER trg_LogNewEmployee
ON Employees
AFTER INSERT
AS
BEGIN
    INSERT INTO Employee_Logs (EmployeeID, Action, ChangedAt)
    SELECT EmployeeID, 'INSERT', GETDATE()
    FROM inserted;
END
```

---

## 13. Quick Reference Cheat Sheet

### 🟦 Subquery Quick Forms

```sql
-- In FROM (must alias)
SELECT … FROM (SELECT … FROM t WHERE …) AS alias;

-- In SELECT (scalar only)
SELECT (SELECT MAX(x) FROM t) AS max_x FROM ...;

-- In WHERE with comparison (scalar)
WHERE col = (SELECT … FROM …);

-- In WHERE with IN
WHERE col IN (SELECT … FROM …);

-- EXISTS (correlated)
WHERE EXISTS (SELECT 1 FROM t WHERE t.id = outer.id);

-- ANY / ALL
WHERE col < ANY (SELECT … FROM …);   -- < max
WHERE col < ALL (SELECT … FROM …);   -- < min
```

### 🟩 Logical Operator Quick Lookup

| Need… | Use |
|--------|-----|
| Match any in list | `IN` or `= ANY` |
| Exclude all in list | `NOT IN` or `<> ALL` |
| Less than at least one | `< ANY` (= less than max) |
| Less than every one | `< ALL` (= less than min) |
| Greater than at least one | `> ANY` (= greater than min) |
| Greater than every one | `> ALL` (= greater than max) |
| Subquery returns anything? | `EXISTS` |
| Subquery returns nothing? | `NOT EXISTS` |

### 🟨 CTE Skeletons

```sql
-- Standalone
WITH name AS (SELECT …) SELECT … FROM name;

-- Multiple
WITH a AS (…), b AS (…) SELECT … FROM a JOIN b …;

-- Nested
WITH a AS (…), b AS (SELECT … FROM a) SELECT … FROM b;

-- Recursive
WITH r AS (
    SELECT … AS x          -- anchor
    UNION ALL
    SELECT x + 1 FROM r WHERE x < N   -- recursive + break
)
SELECT * FROM r;
```

### 🟥 Views

```sql
CREATE VIEW name AS SELECT … FROM …;
CREATE OR ALTER VIEW name AS SELECT … FROM …;
DROP VIEW name;
SELECT * FROM name;
```

### 🟪 CTAS / Temp Tables

```sql
-- CTAS (MySQL / Postgres / Oracle)
CREATE TABLE new_t AS SELECT … FROM …;

-- CTAS (SQL Server)
SELECT … INTO new_t FROM …;

-- Temp (MySQL / Postgres / Oracle)
CREATE TEMPORARY TABLE t AS SELECT … FROM …;

-- Temp (SQL Server)
SELECT … INTO #t FROM …;
```

### 🟫 Stored Procedure & Trigger

```sql
-- Procedure
CREATE PROCEDURE p
    @param INT
AS
BEGIN
    BEGIN TRY
        -- SQL statements
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END

EXEC p @param = 1;

-- Trigger
CREATE TRIGGER trg ON Employees
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- audit / validation
END
```

### 🟧 The Big-Picture Table (memorize!)

| | Subquery | CTE | Temp | CTAS | View |
|---|---------|-----|------|------|------|
| Storage | Memory | Memory | Disk | Disk | ❌ |
| Lifetime | Query | Query | Session | Permanent | Permanent |
| Deleted at | End of query | End of query | End of session | DDL DROP | DDL DROP |
| Scope | 1 query | 1 query | Multi-query | Multi-query | Multi-query |
| Reusability | Low (1 spot) | Low (multi-spot, 1 query) | Medium | High | High |
| Fresh data? | ✅ | ✅ | ❌ | ❌ | ✅ |

### 🔵 Decision Tree — Which Technique Do I Use?

```
                      Need calc in ONE query?
                            │
              ┌─────────────┴────────────┐
              YES                         NO (multi-query)
              │                            │
        Used once?                   Always fresh data?
        ┌─────┴─────┐                ┌─────┴─────┐
       YES         NO                YES         NO
        │           │                 │           │
     Subquery     CTE              View      Need it fast?
                                              ┌────┴─────┐
                                            YES         NO (cheap)
                                              │           │
                                       CTAS / Temp     CTE / Subquery
                                       (within sess)
```

### 🔴 Logical Order of SQL Techniques

```
Subquery / CTE        → in-memory, in one query
Temp Table            → on disk, in one session
View                  → in catalog, persistent SELECT
CTAS                  → on disk, materialized result
Stored Procedure      → saved program (procedural SQL)
Trigger               → automatic SP fired by table events
```

---

> 🎓 **Built for learning.** Star this repo, fork it, and use these notes whenever you're stuck on advanced SQL.
> Notes adapted from *Data With Baraa* SQL Course slides — full coverage of every concept shown.
