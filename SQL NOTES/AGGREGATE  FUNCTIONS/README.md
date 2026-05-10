# 📊 SQL Aggregation & Analytical (Window) Functions — Complete Notes


---

## 📑 Table of Contents

1. [Introduction](#-1-introduction)
2. [Aggregate Functions (Basics)](#-2-aggregate-functions-basics)
   - [COUNT](#21-count)
   - [SUM](#22-sum)
   - [AVG](#23-avg)
   - [MAX & MIN](#24-max--min)
3. [Window Functions: The Big Picture](#-3-window-functions-the-big-picture)
   - [What is a Window Function?](#31-what-is-a-window-function)
   - [GROUP BY vs Window Functions](#32-group-by-vs-window-functions)
   - [Categories of Window Functions](#33-categories-of-window-functions)
4. [Window Function Syntax (Anatomy)](#-4-window-function-syntax-anatomy)
   - [The Function (Expression)](#41-the-function-expression)
   - [The OVER() Clause](#42-the-over-clause)
   - [PARTITION BY Clause](#43-partition-by-clause)
   - [ORDER BY Clause](#44-order-by-clause)
   - [Frame Clause (ROWS/RANGE)](#45-frame-clause-rowsrange)
5. [Window Function Rules](#-5-window-function-rules)
6. [Window Aggregate Functions](#-6-window-aggregate-functions)
   - [Running Total vs Rolling Total](#61-running-total-vs-rolling-total)
   - [Cumulative Analysis Step-by-Step](#62-cumulative-analysis-step-by-step)
   - [Comparison Use Cases](#63-comparison-use-cases)
7. [Window Ranking Functions](#-7-window-ranking-functions)
   - [ROW_NUMBER()](#71-row_number)
   - [RANK()](#72-rank)
   - [DENSE_RANK()](#73-dense_rank)
   - [Which One To Use?](#74-which-one-to-use)
   - [NTILE(n)](#75-ntilen)
   - [CUME_DIST()](#76-cume_dist)
   - [PERCENT_RANK()](#77-percent_rank)
8. [Window Value (Analytics) Functions](#-8-window-value-analytics-functions)
   - [LEAD()](#81-lead)
   - [LAG()](#82-lag)
   - [FIRST_VALUE()](#83-first_value)
   - [LAST_VALUE()](#84-last_value)
9. [SQL Window Function Use Cases](#-9-sql-window-function-use-cases)
10. [NULL Handling Reference](#-10-null-handling-reference)
11. [Common Edge Cases & Tricky Behaviors](#-11-common-edge-cases--tricky-behaviors)
12. [Interview Questions & Answers](#-12-interview-questions--answers)
13. [Quick Reference Cheat Sheet](#-13-quick-reference-cheat-sheet)

---

## 🌟 1. Introduction

SQL has two main families of functions for performing **calculations across multiple rows**:

| Family | Purpose | Result |
|--------|---------|--------|
| **Aggregate Functions** | Combine many rows → one summary value | Collapses rows |
| **Window (Analytical) Functions** | Compute aggregates **without losing row details** | Keeps every row |

Think of it this way:

- **GROUP BY / Aggregates** = "Tell me the total sales per category." → You get one row per category.
- **Window Functions** = "Show me every order, AND next to it show me the category total." → You keep every order row, with extra columns.

---

## 📐 2. Aggregate Functions (Basics)

> **Definition:** Aggregate functions take a **set of rows** as input and return a **single value** as output.

### Overview Table

| Function  | What It Does                       | Works on Data Types     |
|-----------|------------------------------------|-------------------------|
| `COUNT()` | Counts the number of rows          | **Any** type            |
| `SUM()`   | Adds up all values in a column     | **Numbers only**        |
| `AVG()`   | Finds the average of values        | **Numbers only**        |
| `MAX()`   | Gets the highest value             | **Any** type (incl. dates, strings) |
| `MIN()`   | Gets the lowest value              | **Any** type (incl. dates, strings) |

### 2.1 COUNT

Counts rows.

```sql
-- Total number of orders
SELECT COUNT(*) AS total_orders FROM Orders;

-- Number of orders that have a non-NULL Sales value
SELECT COUNT(Sales) AS sales_count FROM Orders;

-- Number of distinct customers
SELECT COUNT(DISTINCT CustomerID) AS unique_customers FROM Orders;
```

> ⚠️ **NULL behavior:** `COUNT(*)` counts **every row** (including NULLs). `COUNT(column)` counts only **non-NULL values** of that column.

### 2.2 SUM

Adds numeric values.

```sql
SELECT SUM(Sales) AS total_sales FROM Orders;
```

> ⚠️ **NULL behavior:** `SUM` **ignores NULLs** automatically. `SUM(*)` is **not allowed**.

### 2.3 AVG

Calculates the arithmetic mean.

```sql
SELECT AVG(Sales) AS avg_sales FROM Orders;
```

> ⚠️ **NULL behavior:** `AVG` **ignores NULLs** in both the sum and the count. To include NULLs as zeros, use `COALESCE`:
>
> ```sql
> SELECT AVG(COALESCE(Sales, 0)) AS avg_sales FROM Orders;
> ```

### 2.4 MAX & MIN

Find the highest / lowest value. Works for numbers, dates, and even strings (alphabetical order).

```sql
SELECT MAX(Sales) AS highest_sale,
       MIN(Sales) AS lowest_sale
FROM Orders;
```

---

## 🪟 3. Window Functions: The Big Picture

### 3.1 What is a Window Function?

> **Window Functions perform calculations (e.g., aggregation) on a specific subset of data, _without losing the level of detail of rows._**

The "window" is the subset of rows the function looks at. Unlike `GROUP BY`, the original rows are **preserved** in the output.

### 3.2 GROUP BY vs Window Functions

This is the most important comparison to understand.

| Aspect                      | GROUP BY                              | Window Functions                          |
|-----------------------------|---------------------------------------|-------------------------------------------|
| **What happens to rows?**   | Collapses groups into a single row    | Does **not** collapse rows                |
| **Calculation level**       | Group-Level Calculation               | Row-Level Calculation                     |
| **Output rows**             | Fewer than input                      | Same as input                             |
| **Can keep detail columns?**| ❌ Only grouping cols + aggregates    | ✅ Yes, keep every column                 |
| **Syntax keyword**          | `GROUP BY`                            | `OVER(...)`                               |

#### Visual Example

**Source Data:**

| Product | Sales |
|---------|-------|
| Caps    | 20    |
| Caps    | 10    |
| Caps    | 5     |
| Gloves  | 30    |
| Gloves  | 70    |
| Gloves  | 40    |

**With GROUP BY** — `SELECT Product, SUM(Sales) FROM Orders GROUP BY Product`:

| Product | SUM |
|---------|-----|
| Caps    | 35  |
| Gloves  | 140 |

**With Window Function** — `SELECT Product, Sales, SUM(Sales) OVER(PARTITION BY Product) FROM Orders`:

| Product | Sales | SUM |
|---------|-------|-----|
| Caps    | 20    | 35  |
| Caps    | 10    | 35  |
| Caps    | 5     | 35  |
| Gloves  | 30    | 140 |
| Gloves  | 70    | 140 |
| Gloves  | 40    | 140 |

👀 **Notice:** Window functions keep all 6 rows; GROUP BY collapses to 2.

### 3.3 Categories of Window Functions

Window functions are split into **three families**:

| Family               | Functions                                                                  | Purpose                                                                |
|----------------------|----------------------------------------------------------------------------|------------------------------------------------------------------------|
| **Aggregate**        | `SUM()`, `AVG()`, `COUNT()`, `MAX()`, `MIN()`                             | Perform calculations on a set of rows and return a single aggregated value for each row |
| **Rank**             | `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `NTILE()`, `CUME_DIST()`, `PERCENT_RANK()` | Assign a rank/position to each row in a window                         |
| **Value (Analytics)**| `LEAD()`, `LAG()`, `FIRST_VALUE()`, `LAST_VALUE()`                        | Return a specific value in a window to be compared with the current row|

---

## 🧱 4. Window Function Syntax (Anatomy)

The full skeleton of a window function:

```sql
WindowFunction(expression) OVER (
    PARTITION BY column1, column2, ...   -- divides the dataset into windows (partitions)
    ORDER BY     column3 [ASC|DESC]      -- sorts the data inside each window
    {ROWS | RANGE} BETWEEN ... AND ...   -- defines a frame (subset) of rows in the window
)
```

### Visual Anatomy

```
AVG(Sales) OVER ( PARTITION BY Category ORDER BY OrderDate ROWS UNBOUNDED PRECEDING )
 └──┬───┘ └─┬┘   └────────┬────────────┘ └──────┬───────┘ └────────────┬───────────┘
    │      │              │                     │                       │
 Function  │         Partition Clause       Order Clause            Frame Clause
Expression OVER()    (define windows)      (sort in window)       (subset of rows)
           Clause
```

### 4.1 The Function (Expression)

The **expression** inside the function depends on the function type:

| Function Family | Function          | Expression Allowed                        |
|-----------------|-------------------|-------------------------------------------|
| Aggregate       | `COUNT(expr)`     | All Data Types                            |
| Aggregate       | `SUM/AVG/MIN/MAX` | Numeric only                              |
| Rank            | `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `CUME_DIST()`, `PERCENT_RANK()` | **Empty** — no expression |
| Rank            | `NTILE(n)`        | A **number** (number of buckets)          |
| Value           | `LEAD/LAG/FIRST_VALUE/LAST_VALUE` | All Data Types            |

#### Expression Examples

```sql
-- Empty (no expression)
RANK() OVER (ORDER BY OrderDate)

-- Column reference
AVG(Sales) OVER (ORDER BY OrderDate)

-- Number argument
NTILE(2) OVER (ORDER BY OrderDate)

-- Multiple arguments
LEAD(Sales, 2, 10) OVER (ORDER BY OrderDate)

-- Conditional logic (CASE WHEN inside)
SUM(CASE WHEN Sales > 100 THEN 1 ELSE 0 END) OVER (ORDER BY OrderDate)
```

### 4.2 The OVER() Clause

The `OVER()` clause is what **transforms a regular function into a window function**. It defines _which window of rows_ the function will operate on.

- `OVER()` empty → entire result set is the window.
- `OVER(PARTITION BY ...)` → divides the data into windows.
- `OVER(ORDER BY ...)` → sorts rows within the window.
- `OVER(... frame ...)` → narrows the window further.

### 4.3 PARTITION BY Clause

> **`PARTITION BY` divides the rows into groups (windows), based on one or more columns. The window function then runs separately on each window.**

#### Three Variations

| Form                          | Example                                            | Meaning                                              |
|-------------------------------|----------------------------------------------------|------------------------------------------------------|
| **Without PARTITION BY**      | `SUM(Sales) OVER ()`                              | Total sales across all rows (entire result set)     |
| **PARTITION BY single column**| `SUM(Sales) OVER (PARTITION BY Product)`          | Total sales for each product                         |
| **PARTITION BY combined cols**| `SUM(Sales) OVER (PARTITION BY Product, OrderStatus)` | Total sales for each (Product, OrderStatus) combo |

#### Row-by-Row Example

`SELECT Product, Sales, SUM(Sales) OVER(PARTITION BY Product) AS total FROM Orders`

| Product | Sales | total |
|---------|-------|-------|
| Caps    | 20    | 35    | ← Window 1 (Caps): 20+10+5
| Caps    | 10    | 35    |
| Caps    | 5     | 35    |
| Gloves  | 30    | 140   | ← Window 2 (Gloves): 30+70+40
| Gloves  | 70    | 140   |
| Gloves  | 40    | 140   |

**`PARTITION BY` is OPTIONAL** for all window functions.

### 4.4 ORDER BY Clause

> **`ORDER BY` (inside `OVER()`) sorts the data within each window.**

#### Required vs Optional

| Function Family | ORDER BY Required? |
|-----------------|--------------------|
| Aggregate       | Optional           |
| Rank            | **Required** ✅    |
| Value           | **Required** ✅    |

The `ORDER BY` inside `OVER()` is **completely independent** of the outer `ORDER BY` of the query.

```sql
SELECT
    Sales,
    RANK() OVER (ORDER BY Sales DESC) AS rank_in_sales
FROM Orders
ORDER BY OrderDate;   -- This sorts the final output, not the window
```

### 4.5 Frame Clause (ROWS/RANGE)

> **The Frame Clause defines a _subset of rows_ within a window — a smaller "frame" the function actually operates on.**

It's essentially "a window inside a window."

#### Frame Anatomy

```sql
AVG(Sales) OVER (
    PARTITION BY Category
    ORDER BY OrderDate
    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
)
```

| Frame Component        | Allowed Values                                     |
|------------------------|----------------------------------------------------|
| **Frame Type**         | `ROWS` , `RANGE`                                  |
| **Frame Boundary (Lower)** | `CURRENT ROW` , `N PRECEDING` , `UNBOUNDED PRECEDING` |
| **Frame Boundary (Higher)**| `CURRENT ROW` , `N FOLLOWING` , `UNBOUNDED FOLLOWING` |

#### Frame Rules

1. ✅ **Frame Clause can only be used together with `ORDER BY`.**
2. ✅ **Lower value MUST come BEFORE the higher value** (lower row position than higher).

#### Default Frame Behavior

| Condition                | Default Frame                                              |
|--------------------------|------------------------------------------------------------|
| `ORDER BY` is **NOT** used | Entire partition is used (all rows in the window)        |
| `ORDER BY` **IS** used    | `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`      |

> 💡 **Why this matters:** Adding `ORDER BY` _silently_ changes the frame. So `SUM(Sales) OVER()` is total sales for the partition, but `SUM(Sales) OVER(ORDER BY Date)` becomes a **running total** because of the default frame change.

#### Compact Frame (Short Form)

> **Rule:** When you use **only `PRECEDING`** (no `FOLLOWING` boundary), you can skip `BETWEEN ... AND CURRENT ROW`.

| Form         | Example                                |
|--------------|----------------------------------------|
| Normal Form  | `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW` |
| Short Form   | `ROWS 2 PRECEDING`                     |

> ⚠️ This shortcut works only for `PRECEDING`. For `FOLLOWING`, you must spell it out:
> `ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING`

#### ROWS vs RANGE

| Keyword | Treats Each Row | Behavior |
|---------|-----------------|----------|
| `ROWS`  | Physical row    | Counts actual rows (row #1, #2, etc.) |
| `RANGE` | Logical value   | Includes all rows with the same `ORDER BY` value as the current row (peer rows) |

---

## 📜 5. Window Function Rules

These rules are critical and frequently asked in interviews:

### 🚦 Rule #1: Window functions can be used **ONLY** in `SELECT` and `ORDER BY` clauses

✅ Allowed:
```sql
SELECT RANK() OVER (ORDER BY Sales) FROM Orders;
SELECT * FROM Orders ORDER BY RANK() OVER (ORDER BY Sales);
```

❌ Not allowed:
```sql
SELECT * FROM Orders WHERE RANK() OVER (ORDER BY Sales) = 1;  -- ERROR
SELECT * FROM Orders GROUP BY RANK() OVER (ORDER BY Sales);   -- ERROR
```

**Workaround:** Use a CTE/subquery:

```sql
WITH ranked AS (
    SELECT *, RANK() OVER (ORDER BY Sales) AS rk FROM Orders
)
SELECT * FROM ranked WHERE rk = 1;
```

### 🚦 Rule #2: Nesting Window Functions is **NOT allowed**

❌ Forbidden:
```sql
AVG( SUM(Sales) OVER () ) OVER (ORDER BY OrderDate)   -- Inner + Outer window = ERROR
```

**Workaround:** Use two-level CTE.

### 🚦 Rule #3: SQL executes WINDOW Functions **AFTER the WHERE clause**

So `WHERE` filters rows _before_ the window function sees them. This affects partitions and ranks.

**Logical Order:** `FROM` → `WHERE` → `GROUP BY` → `HAVING` → **Window functions** → `SELECT` → `ORDER BY` → `LIMIT`.

### 🚦 Rule #4: Window functions can be combined with `GROUP BY` **only if the same columns are used**

```sql
-- ✅ Works: Both reference Category
SELECT Category, SUM(Sales) AS total,
       RANK() OVER (ORDER BY SUM(Sales) DESC) AS rk
FROM Orders
GROUP BY Category;

-- ❌ Won't work: Window references Product, but GROUP BY only has Category
SELECT Category, SUM(Sales),
       RANK() OVER (PARTITION BY Product ORDER BY SUM(Sales))
FROM Orders
GROUP BY Category;
```

---

## 🧮 6. Window Aggregate Functions

> **Aggregation = combining multiple values into a single summary.**

### Syntax

```sql
AVG(Sales) OVER (PARTITION BY ProductID ORDER BY Sales)
   ↑              ↑                       ↑
Required       Optional                Optional
(numeric for SUM/AVG/MIN/MAX;
 any type for COUNT)
```

### Capability Matrix

| Function     | Expression          | PARTITION BY | ORDER BY | Frame Clause |
|--------------|---------------------|--------------|----------|--------------|
| `COUNT(expr)`| All data types      | Optional     | Optional | Optional     |
| `SUM(expr)`  | Numeric values      | Optional     | Optional | Optional     |
| `AVG(expr)`  | Numeric values      | Optional     | Optional | Optional     |
| `MIN(expr)`  | Numeric values      | Optional     | Optional | Optional     |
| `MAX(expr)`  | Numeric values      | Optional     | Optional | Optional     |

### Function Summary

| Function     | Returns                                     | Example                                       |
|--------------|---------------------------------------------|-----------------------------------------------|
| `COUNT(expr)`| Number of rows in a window                  | `COUNT(*) OVER (PARTITION BY Product)`        |
| `SUM(expr)`  | Sum of values in a window                   | `SUM(Sales) OVER (PARTITION BY Product)`      |
| `AVG(expr)`  | Average of values in a window               | `AVG(Sales) OVER (PARTITION BY Product)`      |
| `MIN(expr)`  | Minimum value in a window                   | `MIN(Sales) OVER (PARTITION BY Product)`      |
| `MAX(expr)`  | Maximum value in a window                   | `MAX(Sales) OVER (PARTITION BY Product)`      |

### COUNT Window Function — NULL Handling

`COUNT(*)` and `COUNT(1)` count rows including NULLs. `COUNT(column)` excludes NULLs.

#### Including NULLs — `COUNT(*) OVER(PARTITION BY Product)`

| Product | Sales | Count |
|---------|-------|-------|
| Caps    | 20    | 3     |
| Caps    | 10    | 3     |
| Caps    | 5     | 3     |
| Gloves  | 30    | 3     |
| Gloves  | 70    | 3     |
| Gloves  | NULL  | 3     |  ← still counted

#### Excluding NULLs — `COUNT(Sales) OVER(PARTITION BY Product)`

| Product | Sales | Count |
|---------|-------|-------|
| Caps    | 20    | 3     |
| Caps    | 10    | 3     |
| Caps    | 5     | 3     |
| Gloves  | 30    | 2     |
| Gloves  | 70    | 2     |
| Gloves  | NULL  | 2     |  ← NOT counted

### SUM Window Function

> ⚠️ `SUM(*)` is **not allowed**. You must specify a column.

`SUM(Sales) OVER(PARTITION BY Product)`:

| Product | Sales | SUM | Calc        |
|---------|-------|-----|-------------|
| Caps    | 20    | 35  | 20+10+5=35 |
| Caps    | 10    | 35  |             |
| Caps    | 5     | 35  |             |
| Gloves  | 30    | 140 | 30+70+40=140|
| Gloves  | 70    | 140 |             |
| Gloves  | 40    | 140 |             |

### AVG Window Function — NULL Handling

`AVG` ignores NULLs by default. To treat NULLs as 0 use `COALESCE`.

#### Default `AVG(Sales) OVER(PARTITION BY Product)` — excludes NULL

| Product | Sales | AVG | Calc        |
|---------|-------|-----|-------------|
| Caps    | 20    | 11  | (20+10+5)/3 = 11 |
| Caps    | 10    | 11  |             |
| Caps    | 5     | 11  |             |
| Gloves  | 30    | 50  | (30+70)/2 = 50 (NULL skipped) |
| Gloves  | 70    | 50  |             |
| Gloves  | NULL  | 50  |             |

#### `AVG(COALESCE(Sales,0)) OVER(PARTITION BY Product)` — replaces NULL with 0

| Product | Sales (after COALESCE) | AVG | Calc        |
|---------|------------------------|-----|-------------|
| Gloves  | 30                     | 33  | (30+70+0)/3 = 33 |
| Gloves  | 70                     | 33  |             |
| Gloves  | 0 (was NULL)           | 33  |             |

### MIN & MAX Window Functions

```sql
SELECT
    Product,
    Sales,
    MIN(Sales) OVER (PARTITION BY Product) AS min_sales,
    MAX(Sales) OVER (PARTITION BY Product) AS max_sales
FROM Orders;
```

| Product | Sales | MIN | MAX |
|---------|-------|-----|-----|
| Caps    | 20    | 5   | 20  |
| Caps    | 10    | 5   | 20  |
| Caps    | 5     | 5   | 20  |
| Gloves  | 30    | 30  | 70  |
| Gloves  | 70    | 30  | 70  |
| Gloves  | 40    | 30  | 70  |

---

### 6.1 Running Total vs Rolling Total

This is one of the **most powerful** uses of window aggregates: **cumulative analysis**.

| Concept           | Definition                                                                              | Example Syntax                                              |
|-------------------|-----------------------------------------------------------------------------------------|-------------------------------------------------------------|
| **Running Total** | Summarize all values from the **first row up to the current row** (cumulative)          | `SUM(Sales) OVER(ORDER BY Month)`                           |
| **Rolling Total** | Summarize a **fixed number of consecutive rows** calculated within a moving window      | `SUM(Sales) OVER(ORDER BY Month ROWS 2 PRECEDING)`          |

> 💡 **Default Frame** for `ORDER BY` (without explicit frame): `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` → that's why a plain `OVER (ORDER BY ...)` produces a Running Total.

### 6.2 Cumulative Analysis Step-by-Step

Source data:

| Month | Sales |
|-------|-------|
| Jan   | 20    |
| Feb   | 10    |
| Mar   | 30    |
| Apr   | 5     |
| Jun   | 70    |
| Jul   | 40    |

#### Running Total — `SUM(Sales) OVER(ORDER BY Month)`

Step-by-step (current row marked ⏵):

| Step | Month | Sales | Running SUM | What It Includes              |
|------|-------|-------|-------------|--------------------------------|
| ⏵    | Jan   | 20    | 20          | Jan                            |
| ⏵    | Feb   | 10    | 30          | Jan+Feb                        |
| ⏵    | Mar   | 30    | 60          | Jan+Feb+Mar                    |
| ⏵    | Apr   | 5     | 65          | Jan+Feb+Mar+Apr                |
| ⏵    | Jun   | 70    | 135         | Jan+Feb+Mar+Apr+Jun            |
| ⏵    | Jul   | 40    | 175         | Jan+Feb+Mar+Apr+Jun+Jul (all)  |

#### Rolling Total — `SUM(Sales) OVER(ORDER BY Month ROWS 2 PRECEDING)`

This window includes **the current row + 2 previous rows** = a 3-row moving window.

| Step | Month | Sales | Rolling SUM | Window of Rows                 |
|------|-------|-------|-------------|---------------------------------|
| ⏵    | Jan   | 20    | 20          | (only Jan, no preceding)        |
| ⏵    | Feb   | 10    | 30          | Jan+Feb                          |
| ⏵    | Mar   | 30    | 60          | Jan+Feb+Mar                      |
| ⏵    | Apr   | 5     | 45          | Feb+Mar+Apr (Jan slides out)     |
| ⏵    | Jun   | 70    | 105         | Mar+Apr+Jun                      |
| ⏵    | Jul   | 40    | 115         | Apr+Jun+Jul                      |

### 6.3 Comparison Use Cases

> **Compare the value in the current row against an aggregated value of the window.**

Example: For each month, show how a single month's sales compare to the totals/extremes of all months.

| Month | Sales | Total (SUM) | Highest (MAX) | Lowest (MIN) | Average (AVG) |
|-------|-------|-------------|---------------|--------------|---------------|
| Jan   | 20    | 175         | 70            | 5            | 29            |
| Feb   | 10    | 175         | 70            | 5            | 29            |
| Mar   | 30    | 175         | 70            | 5            | 29            |
| Apr   | 5     | 175         | 70            | 5            | 29            |
| Jun   | 70    | 175         | 70            | 5            | 29            |
| Jul   | 40    | 175         | 70            | 5            | 29            |

```sql
SELECT Month, Sales,
    SUM(Sales) OVER () AS total,
    MAX(Sales) OVER () AS highest,
    MIN(Sales) OVER () AS lowest,
    AVG(Sales) OVER () AS average,
    Sales - AVG(Sales) OVER () AS deviation_from_avg
FROM Orders;
```

---

## 🏆 7. Window Ranking Functions

> **Rank functions assign a rank to each row in a window.**

### Syntax

```sql
RANK() OVER (PARTITION BY ProductID ORDER BY Sales)
  ↑           ↑                       ↑
 Empty      Optional               REQUIRED
```

### Capability Matrix

| Function          | Expression | PARTITION BY | ORDER BY    | Frame Clause   |
|-------------------|------------|--------------|-------------|----------------|
| `ROW_NUMBER()`    | Empty      | Optional     | **Required**| Not allowed    |
| `RANK()`          | Empty      | Optional     | **Required**| Not allowed    |
| `DENSE_RANK()`    | Empty      | Optional     | **Required**| Not allowed    |
| `CUME_DIST()`     | Empty      | Optional     | **Required**| Not allowed    |
| `PERCENT_RANK()`  | Empty      | Optional     | **Required**| Not allowed    |
| `NTILE(n)`        | Number     | Optional     | **Required**| Not allowed    |

### Function Summary

| Function         | Description                                                                    | Example                                       |
|------------------|--------------------------------------------------------------------------------|-----------------------------------------------|
| `ROW_NUMBER()`   | Assigns a **unique sequential number** to each row in a window                 | `ROW_NUMBER() OVER (ORDER BY Sales)`          |
| `RANK()`         | Assigns a rank to each row, **with gaps** after ties                           | `RANK() OVER (ORDER BY Sales)`                |
| `DENSE_RANK()`   | Assigns a rank to each row, **without gaps** after ties                        | `DENSE_RANK() OVER (ORDER BY Sales)`          |
| `CUME_DIST()`    | Cumulative distribution of a value within a set of values (0 < x ≤ 1)         | `CUME_DIST() OVER (ORDER BY Sales)`           |
| `PERCENT_RANK()` | Percentile ranking of a row (0 ≤ x ≤ 1)                                       | `PERCENT_RANK() OVER (ORDER BY Sales)`        |
| `NTILE(n)`       | Divides rows into **n approximately equal groups (buckets)**                   | `NTILE(2) OVER (ORDER BY Sales)`              |

---

### 7.1 ROW_NUMBER()

> **Assigns a unique sequential integer to each row within a window. Always unique, even on ties.**

```sql
ROW_NUMBER() OVER (ORDER BY Sales DESC)
```

Tied values get **different** numbers:

| Sales | Rank |
|-------|------|
| 100   | 1    |
| 80    | 2    | ← tie
| 80    | 3    | ← tie, but unique number assigned
| 50    | 4    |
| 20    | 5    |

### 7.2 RANK()

> **Assigns a rank to each row. Ties get the SAME rank, and the next rank LEAVES A GAP.**

```sql
RANK() OVER (ORDER BY Sales DESC)
```

| Sales | Rank |
|-------|------|
| 100   | 1    |
| 80    | 2    | ← tie
| 80    | 2    | ← same rank
| 50    | 4    | ← gap! (skipped 3)
| 20    | 5    |

### 7.3 DENSE_RANK()

> **Same as `RANK()`, but does NOT leave gaps after a tie.**

```sql
DENSE_RANK() OVER (ORDER BY Sales DESC)
```

| Sales | Rank |
|-------|------|
| 100   | 1    |
| 80    | 2    | ← tie
| 80    | 2    | ← same rank
| 50    | 3    | ← no gap (continues sequentially)
| 20    | 4    |

### Side-by-Side Comparison

| Sales | ROW_NUMBER | RANK | DENSE_RANK |
|-------|------------|------|------------|
| 100   | 1          | 1    | 1          |
| 80    | 2          | 2    | 2          |
| 80    | 3          | 2    | 2          |
| 50    | 4          | 4    | 3          |
| 20    | 5          | 5    | 4          |

### 7.4 Which One To Use?

A simple decision tree:

```
Need to handle tied values?
│
├── No  → ROW_NUMBER()
│
└── Yes → Should there be gaps in ranking after ties?
            │
            ├── Yes → RANK()
            │
            └── No  → DENSE_RANK()
```

| Scenario                                                   | Use            |
|------------------------------------------------------------|----------------|
| Pagination / unique row IDs / "the 3rd row, period"        | `ROW_NUMBER()` |
| Standard sports-style ranking ("you tied for 2nd, next is 4th") | `RANK()`     |
| Top categories or grades where you want consecutive ranks  | `DENSE_RANK()` |

---

### 7.5 NTILE(n)

> **Divides rows into a specified number `n` of approximately equal groups (buckets).**

```sql
NTILE(2) OVER (ORDER BY Sales DESC)
   ↑
Number of buckets
```

#### Bucket Size Formula

```
Bucket Size = Number of Rows ÷ Number of Buckets
```

#### Case 1: Even split — 4 rows, 2 buckets → bucket size = 2

| Sales | NTILE(2) |
|-------|----------|
| 100   | 1        | ← Bucket 1
| 80    | 1        |
| 80    | 2        | ← Bucket 2
| 50    | 2        |

#### Case 2: Uneven split — 5 rows, 2 buckets → bucket size = 2.5

> **Rule: Larger groups come FIRST, then smaller groups.**

| Sales | NTILE(2) |
|-------|----------|
| 100   | 1        | ← Bucket 1 (3 rows — bigger first)
| 80    | 1        |
| 80    | 1        |
| 50    | 2        | ← Bucket 2 (2 rows)
| 20    | 2        |

#### Case 3: 5 rows, 3 buckets → bucket size ≈ 1.7

| Sales | NTILE(3) |
|-------|----------|
| 100   | 1        | ← Bucket 1 (2 rows)
| 80    | 1        |
| 80    | 2        | ← Bucket 2 (2 rows)
| 50    | 2        |
| 20    | 3        | ← Bucket 3 (1 row)

**Common use cases:** Quartiles (`NTILE(4)`), Quintiles (`NTILE(5)`), Deciles (`NTILE(10)`), data segmentation, equalizing load processing.

---

### 7.6 CUME_DIST()

> **Calculates the relative position (cumulative distribution) of a specified value in a group of values.**

#### Formula

```
                  Number of Rows with value ≤ X
CUME_DIST(X) =  ─────────────────────────────────
                       Total Number of Rows
```

> **Returns values greater than 0 and less than or equal to 1** (i.e., `0 < CUME_DIST ≤ 1`).

#### Example — `CUME_DIST() OVER (ORDER BY Sales)`

| Sales | Dist | Calculation                |
|-------|------|----------------------------|
| 20    | 0.2  | 1/5 = 0.2                  |
| 50    | 0.4  | 2/5 = 0.4                  |
| 60    | 0.6  | 3/5 = 0.6                  |
| 80    | 0.8  | 4/5 = 0.8                  |
| 100   | 1.0  | 5/5 = 1.0 (always reaches 1)|

### 7.7 PERCENT_RANK()

> **Returns the percentile ranking number of a row.**

#### Formula

```
                       Rank of X − 1
PERCENT_RANK(X) =  ───────────────────────
                   Total Number of Rows − 1
```

> **Returns values between 0 and 1** (`0 ≤ PERCENT_RANK ≤ 1`).
> The lowest position is **always 0**, the highest position is **always 1**.

#### Example — `PERCENT_RANK() OVER (ORDER BY Sales)`

| Sales | Rank | Pct  | Calculation        |
|-------|------|------|--------------------|
| 20    | 1    | 0    | (1−1)/(5−1) = 0    | ← lowest position
| 50    | 2    | 0.25 | (2−1)/4 = 0.25     |
| 60    | 3    | 0.5  | (3−1)/4 = 0.5      |
| 80    | 4    | 0.75 | (4−1)/4 = 0.75     |
| 100   | 5    | 1    | (5−1)/4 = 1        | ← highest position

### CUME_DIST vs PERCENT_RANK

| Aspect            | `CUME_DIST()`                                   | `PERCENT_RANK()`                              |
|-------------------|-------------------------------------------------|------------------------------------------------|
| Range             | `0 < x ≤ 1`                                     | `0 ≤ x ≤ 1`                                    |
| Smallest value gets | > 0 (e.g., 0.2 above)                         | **Always 0**                                   |
| Largest value gets  | **Always 1**                                  | **Always 1**                                   |
| Numerator         | Count of rows with value ≤ current             | Rank of current − 1                            |
| Denominator       | Total rows                                     | Total rows − 1                                 |
| Use case          | "What proportion of the data is at or below me?"| "Where do I rank as a percentile?"            |

---

## 🎯 8. Window Value (Analytics) Functions

> **Return a specific value from a window to be compared with the value of the current row.**

### Function Summary

| Function                       | Returns                              | Example                                              |
|--------------------------------|--------------------------------------|------------------------------------------------------|
| `LEAD(expr, offset, default)`  | Value from a **subsequent** (next) row| `LEAD(Sales, 2, 0) OVER (ORDER BY OrderDate)`        |
| `LAG(expr, offset, default)`   | Value from a **previous** row        | `LAG(Sales, 2, 0) OVER (ORDER BY OrderDate)`         |
| `FIRST_VALUE(expr)`            | First value in a window              | `FIRST_VALUE(Sales) OVER (ORDER BY OrderDate)`       |
| `LAST_VALUE(expr)`             | Last value in a window               | `LAST_VALUE(Sales) OVER (ORDER BY OrderDate ...)`    |

### Capability Matrix

| Function       | Expression     | PARTITION BY | ORDER BY     | Frame Clause                   |
|----------------|----------------|--------------|--------------|--------------------------------|
| `LEAD()`       | All Data Types | Optional     | **Required** | **Not allowed**                |
| `LAG()`        | All Data Types | Optional     | **Required** | **Not allowed**                |
| `FIRST_VALUE()`| All Data Types | Optional     | **Required** | Optional                       |
| `LAST_VALUE()` | All Data Types | Optional     | **Required** | **Should be used** (see below) |

### LEAD/LAG Full Anatomy

```sql
LEAD(Sales, 2, 10) OVER (PARTITION BY ProductID ORDER BY OrderDate)
 │     │     │             ↑                       ↑
 │     │     │         Optional               REQUIRED
 │     │     │
 │     │     └── Default Value (Optional)
 │     │         Returns this value if next/previous row is not available
 │     │         Default = NULL
 │     │
 │     └── Offset (Optional)
 │         Number of rows forward (LEAD) or backward (LAG) from current row
 │         default = 1
 │
 └── Expression (REQUIRED) — any data type
```

### 8.1 LEAD()

> **Access the NEXT row's value.**

`LEAD(Sales) OVER (ORDER BY Month)` — step by step:

| Month | Sales | LEAD | Comment                              |
|-------|-------|------|--------------------------------------|
| Jan   | 20    | 10   | Reads Feb's Sales (10)               |
| Feb   | 10    | 30   | Reads Mar's Sales (30)               |
| Mar   | 30    | 5    | Reads Apr's Sales (5)                |
| Apr   | 5     | NULL | **Last row has no next row → NULL** |

### 8.2 LAG()

> **Access the PREVIOUS row's value.**

`LAG(Sales) OVER (ORDER BY Month)` — step by step:

| Month | Sales | LAG  | Comment                                |
|-------|-------|------|----------------------------------------|
| Jan   | 20    | NULL | **First row has no previous row → NULL** |
| Feb   | 10    | 20   | Reads Jan's Sales (20)                  |
| Mar   | 30    | 10   | Reads Feb's Sales (10)                  |
| Apr   | 5     | 30   | Reads Mar's Sales (30)                  |

### LEAD vs LAG Side by Side

| Function | Direction          | Edge Case (when nothing exists) |
|----------|--------------------|---------------------------------|
| `LEAD`   | Forward (next row) | Returns NULL (or default)       |
| `LAG`    | Backward (previous)| Returns NULL (or default)       |

#### Using offset and default

```sql
-- 2 rows ahead, 0 if not available
LEAD(Sales, 2, 0) OVER (ORDER BY Month)

-- 1 row back, 'N/A' if not available
LAG(Status, 1, 'N/A') OVER (ORDER BY Month)
```

### 8.3 FIRST_VALUE()

> **Returns the first value in the window.**

```sql
FIRST_VALUE(Sales) OVER (ORDER BY Month)
```

### 8.4 LAST_VALUE()

> **Returns the last value in the window.**

> ⚠️ **Important:** `LAST_VALUE()` almost always requires an **explicit frame**, otherwise the default frame (`RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`) makes "last value" mean the **current row** — usually not what you want!

```sql
-- Common correct usage:
LAST_VALUE(Sales) OVER (
    ORDER BY Month
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```

### Visual Recap

For an ordered series `Jan, Feb, Mar, Apr, Jun, Jul, Aug, Sep, Oct` with current row = `Jun`:

| Function          | Returns                |
|-------------------|------------------------|
| `FIRST_VALUE()`   | Jan's value            |
| `LAG(2)`          | Apr's value (2 back)   |
| `LEAD(2)`         | Aug's value (2 ahead)  |
| `LAST_VALUE()`    | Oct's value (with proper frame) |

### Combined Example

```sql
SELECT
    Month,
    Sales,
    LAG(Sales, 2)        OVER (ORDER BY Month) AS sales_2_months_ago,
    LEAD(Sales, 2)       OVER (ORDER BY Month) AS sales_2_months_ahead,
    FIRST_VALUE(Sales)   OVER (ORDER BY Month) AS first_sales,
    LAST_VALUE(Sales)    OVER (ORDER BY Month
                               ROWS BETWEEN UNBOUNDED PRECEDING
                                        AND UNBOUNDED FOLLOWING) AS last_sales
FROM MonthlySales;
```

---

## 🎯 9. SQL Window Function Use Cases

A window function is the right tool for any of these problems:

| Use Case                          | Typical Function(s)                                     |
|-----------------------------------|---------------------------------------------------------|
| **Top N Analysis**                | `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`               |
| **Bottom N Analysis**             | `ROW_NUMBER()` ASC, `RANK()` ASC                       |
| **Identify & Remove Duplicates**  | `ROW_NUMBER() OVER (PARTITION BY key ORDER BY ...)`    |
| **Assign Unique IDs / Pagination**| `ROW_NUMBER()`                                          |
| **Data Segmentation**             | `NTILE(n)`                                              |
| **Data Distribution Analysis**    | `CUME_DIST()`, `PERCENT_RANK()`                         |
| **Equalizing Load Processing**    | `NTILE(n)` (split workload into n batches)              |
| **Overall Analysis**              | `SUM/AVG/MIN/MAX OVER ()` (entire dataset)              |
| **Total Per Groups Analysis**     | `SUM/AVG OVER (PARTITION BY group)`                     |
| **Part-to-Whole Analysis**        | `value / SUM(value) OVER (PARTITION BY group)`          |
| **Time Series Analysis (MoM, YoY)**| `LAG()` / `LEAD()` to compare with prior periods       |
| **Time Gaps Analysis (Customer Retention)** | `LAG(date)` to find gap to previous activity   |
| **Comparison Analysis (Extreme: Highest, Lowest)** | `MAX/MIN OVER (...)` against current row |
| **Outlier Detection**             | `AVG`, `STDDEV` window functions                        |
| **Running Total**                 | `SUM(...) OVER (ORDER BY ...)`                          |
| **Rolling Total**                 | `SUM(...) OVER (ORDER BY ... ROWS N PRECEDING)`         |
| **Moving Average**                | `AVG(...) OVER (ORDER BY ... ROWS N PRECEDING)`         |

### Quick Recipes

```sql
-- Top 3 products per category
WITH ranked AS (
  SELECT *, RANK() OVER (PARTITION BY Category ORDER BY Sales DESC) AS rk
  FROM Products
)
SELECT * FROM ranked WHERE rk <= 3;

-- Remove duplicates keeping the latest row per Email
WITH d AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY Email ORDER BY UpdatedAt DESC) AS rn
  FROM Users
)
SELECT * FROM d WHERE rn = 1;

-- Month-over-month growth
SELECT Month, Sales,
       Sales - LAG(Sales) OVER (ORDER BY Month) AS mom_change,
       (Sales - LAG(Sales) OVER (ORDER BY Month)) * 100.0
         / NULLIF(LAG(Sales) OVER (ORDER BY Month), 0) AS mom_pct
FROM MonthlySales;

-- Each product's share of category sales (Part-to-Whole)
SELECT Product, Category, Sales,
       Sales * 100.0 / SUM(Sales) OVER (PARTITION BY Category) AS pct_of_category
FROM Products;

-- 3-month moving average
SELECT Month, Sales,
       AVG(Sales) OVER (ORDER BY Month ROWS 2 PRECEDING) AS moving_avg_3m
FROM MonthlySales;
```

---

## 🕳️ 10. NULL Handling Reference

| Function           | NULL Behavior                                                  |
|--------------------|----------------------------------------------------------------|
| `COUNT(*)`         | **Counts** rows with NULL                                      |
| `COUNT(column)`    | **Skips** NULLs                                                |
| `COUNT(DISTINCT col)` | **Skips** NULLs and counts distinct                         |
| `SUM(column)`      | **Skips** NULLs                                                |
| `AVG(column)`      | **Skips** NULLs in both numerator and denominator              |
| `MIN/MAX(column)`  | **Skips** NULLs                                                |
| `LAG/LEAD`         | If row doesn't exist → returns **NULL** (or default if given)  |
| `FIRST_VALUE`      | Returns first row's actual value (NULL if it's NULL)           |
| `LAST_VALUE`       | Returns last row's actual value                                |

### Trick: Force NULL into the calculation

```sql
-- Treat NULL as 0 for averaging
AVG(COALESCE(Sales, 0)) OVER (PARTITION BY Product)
```

---

## ⚠️ 11. Common Edge Cases & Tricky Behaviors

### Edge Case 1: `LAST_VALUE` returns the current row, not the actual last row

**Why:** Default frame with `ORDER BY` is `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`.

✅ Fix:
```sql
LAST_VALUE(Sales) OVER (
    ORDER BY Month
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```

### Edge Case 2: Adding `ORDER BY` silently changes the frame

```sql
-- Total per partition
SUM(Sales) OVER (PARTITION BY Product)

-- Same query + ORDER BY → becomes a Running Total!
SUM(Sales) OVER (PARTITION BY Product ORDER BY Date)
```

This is because the default frame becomes `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`.

### Edge Case 3: `COUNT(*)` vs `COUNT(column)` with NULLs

| Query                  | Result on NULL row |
|------------------------|--------------------|
| `COUNT(*)`             | Counted            |
| `COUNT(1)`             | Counted            |
| `COUNT(SalesColumn)`   | NOT counted (if NULL)|

### Edge Case 4: `SUM(*)` is not allowed

```sql
SUM(*) OVER (...)   -- ❌ syntax error
SUM(1) OVER (...)   -- ✅ works (counts rows essentially)
```

### Edge Case 5: Window functions cannot live in WHERE/GROUP BY/HAVING

❌ `WHERE ROW_NUMBER() OVER (...) = 1` — wrap in CTE/subquery instead.

### Edge Case 6: `RANK()` gaps after ties

If 3 rows tie for rank 1, the next rank is 4 (not 2). Use `DENSE_RANK()` for sequential without gaps.

### Edge Case 7: NTILE doesn't split exactly evenly

If rows aren't divisible by `n`, **larger groups come first**, then smaller.

### Edge Case 8: Window function with GROUP BY

A window function over an aggregated query operates on the **aggregated rows**, not the raw rows.

```sql
SELECT Category,
       SUM(Sales) AS total,
       RANK() OVER (ORDER BY SUM(Sales) DESC) AS rk
FROM Orders
GROUP BY Category;   -- RANK ranks the GROUPED rows
```

### Edge Case 9: Order matters in `OVER(...)`

The order is **always**: `PARTITION BY` → `ORDER BY` → frame. Never the reverse.

### Edge Case 10: Division by zero with `LAG`

```sql
-- ❌ Division by zero possible
(Sales - LAG(Sales) OVER (...)) / LAG(Sales) OVER (...)

-- ✅ Use NULLIF to safely return NULL
(Sales - LAG(Sales) OVER (...)) / NULLIF(LAG(Sales) OVER (...), 0)
```

---

## 🎙️ 12. Interview Questions & Answers

### Conceptual / Theoretical

**Q1. What is a window function in SQL? How is it different from a regular aggregate function?**
A: A window function performs a calculation across a set of rows (a "window") that are related to the current row, **without collapsing them into a single output row**. A regular aggregate (like `SUM` with `GROUP BY`) collapses many rows into one. Window functions use the `OVER()` clause to define the window.

---

**Q2. Explain the difference between `GROUP BY` and a window function.**
A:

| GROUP BY                        | Window Function                                |
|---------------------------------|-------------------------------------------------|
| Collapses rows                  | Preserves rows                                 |
| Group-level calculation         | Row-level calculation                          |
| Can only return aggregates and grouped columns | Can return any column + window calc |
| Uses `GROUP BY` keyword         | Uses `OVER()` clause                           |

---

**Q3. What does `PARTITION BY` do? Is it required?**
A: `PARTITION BY` divides the result set into windows (groups), and the window function runs separately on each. It's **optional** — without it, the entire result set is one window.

---

**Q4. Is `ORDER BY` inside `OVER()` required?**
A: It depends on the function:

- **Aggregate functions:** Optional.
- **Rank functions:** **Required**.
- **Value functions:** **Required**.

---

**Q5. What is the difference between `RANK()`, `DENSE_RANK()`, and `ROW_NUMBER()`?**

| Function     | Ties get same rank? | Leaves gaps? |
|--------------|---------------------|--------------|
| `ROW_NUMBER`| ❌ No (unique nums) | ❌ No        |
| `RANK`       | ✅ Yes             | ✅ Yes       |
| `DENSE_RANK` | ✅ Yes             | ❌ No        |

Example with values [100, 80, 80, 50]:

- `ROW_NUMBER`: 1, 2, 3, 4
- `RANK`: 1, 2, 2, 4
- `DENSE_RANK`: 1, 2, 2, 3

---

**Q6. What does `NTILE(n)` do?**
A: Splits rows into `n` approximately equal-sized buckets and assigns each row a bucket number (1..n). When rows don't divide evenly, **larger groups come first**.

---

**Q7. What's the difference between `CUME_DIST()` and `PERCENT_RANK()`?**

| Aspect             | CUME_DIST            | PERCENT_RANK            |
|--------------------|----------------------|--------------------------|
| Range              | `0 < x ≤ 1`          | `0 ≤ x ≤ 1`              |
| Lowest value gets  | > 0 (e.g., 1/N)      | Always 0                 |
| Highest value gets | Always 1             | Always 1                 |
| Formula            | (rows ≤ X) / total   | (rank − 1) / (total − 1) |

---

**Q8. What's the difference between `LEAD` and `LAG`?**
A: `LEAD` looks at the **next** row, `LAG` at the **previous** row. Both take an optional `offset` (default 1) and `default` value (default NULL). They return NULL when no such row exists.

---

**Q9. Why does `LAST_VALUE()` often return the wrong result?**
A: Because the default frame is `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`, so "last value" becomes the **current row's value**. Fix it with an explicit frame:
```sql
LAST_VALUE(col) OVER (ORDER BY ... ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
```

---

**Q10. What is the default window frame?**
A:

- If `ORDER BY` is **not** used: the entire partition.
- If `ORDER BY` **is** used: `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` (this is what makes a plain `OVER (ORDER BY x)` produce a Running Total).

---

**Q11. Difference between `ROWS` and `RANGE` in a frame clause?**
A:

- `ROWS` works on **physical rows** (literal row positions).
- `RANGE` works on **logical values** — all rows with the same `ORDER BY` value as the current row are considered "peers" and included together.

---

**Q12. What are the rules for using window functions?**
A:

1. They can only appear in `SELECT` and `ORDER BY` clauses.
2. Nesting window functions is not allowed.
3. They run **after** the `WHERE` clause.
4. They can be combined with `GROUP BY` only when referencing the same columns.

---

**Q13. Difference between Running Total and Rolling Total?**

| Running Total                       | Rolling Total                                  |
|-------------------------------------|------------------------------------------------|
| All values from first row → current | A fixed window of N rows around current row    |
| Always grows                        | Stays the same size (slides over data)         |
| `SUM(x) OVER (ORDER BY d)`          | `SUM(x) OVER (ORDER BY d ROWS N PRECEDING)`    |

---

**Q14. Where in the logical query order do window functions execute?**
A: After `WHERE`, `GROUP BY`, and `HAVING`, but before `SELECT`'s final projection, `ORDER BY`, and `LIMIT`. So you cannot filter on a window function in `WHERE`.

---

**Q15. Can you use a window function in a `WHERE` clause?**
A: No. Wrap it in a CTE or subquery first:
```sql
WITH r AS (SELECT *, RANK() OVER (...) AS rk FROM t)
SELECT * FROM r WHERE rk = 1;
```

---

### Practical / SQL Writing

**Q16. Write a query to find the top 3 highest-paid employees per department.**
```sql
WITH ranked AS (
  SELECT *,
         DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rk
  FROM employees
)
SELECT * FROM ranked WHERE rk <= 3;
```

---

**Q17. Find duplicate emails and keep only the latest record.**
```sql
WITH d AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_at DESC) AS rn
  FROM users
)
SELECT * FROM d WHERE rn = 1;
```

---

**Q18. Calculate month-over-month sales growth (%)**
```sql
SELECT month,
       sales,
       LAG(sales) OVER (ORDER BY month) AS prev_sales,
       (sales - LAG(sales) OVER (ORDER BY month)) * 100.0
         / NULLIF(LAG(sales) OVER (ORDER BY month), 0) AS mom_growth_pct
FROM monthly_sales;
```

---

**Q19. Compute a running total of sales per product.**
```sql
SELECT product, order_date, sales,
       SUM(sales) OVER (PARTITION BY product ORDER BY order_date) AS running_total
FROM orders;
```

---

**Q20. Compute a 7-day rolling average of sales.**
```sql
SELECT order_date, sales,
       AVG(sales) OVER (ORDER BY order_date ROWS 6 PRECEDING) AS rolling_7d_avg
FROM daily_sales;
```

---

**Q21. Find each employee's salary as a percentage of their department's total salary (Part-to-Whole).**
```sql
SELECT name, department, salary,
       salary * 100.0 / SUM(salary) OVER (PARTITION BY department) AS pct_of_dept
FROM employees;
```

---

**Q22. Get the highest-selling product per category (no ties).**
```sql
WITH r AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales DESC) AS rn
  FROM products
)
SELECT * FROM r WHERE rn = 1;
```

---

**Q23. Split customers into 4 equal groups based on lifetime spend (quartiles).**
```sql
SELECT customer_id, lifetime_spend,
       NTILE(4) OVER (ORDER BY lifetime_spend DESC) AS spend_quartile
FROM customers;
```

---

**Q24. For each row, show the first and last sale date of the same customer.**
```sql
SELECT customer_id, order_date, sales,
       FIRST_VALUE(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS first_order,
       LAST_VALUE(order_date)  OVER (PARTITION BY customer_id ORDER BY order_date
                                     ROWS BETWEEN UNBOUNDED PRECEDING
                                              AND UNBOUNDED FOLLOWING) AS last_order
FROM orders;
```

---

**Q25. Find the gap (in days) between each customer's consecutive orders.**
```sql
SELECT customer_id, order_date,
       order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS days_since_last
FROM orders;
```

---

## 🧾 13. Quick Reference Cheat Sheet

### Aggregate Functions

```sql
COUNT(*)            -- counts all rows (incl. NULL)
COUNT(col)          -- counts non-NULL values
COUNT(DISTINCT col) -- counts unique non-NULL values
SUM(col)            -- ignores NULL; SUM(*) ❌
AVG(col)            -- ignores NULL in num and denom
MIN(col), MAX(col)  -- works on numbers, dates, strings
```

### Window Function Skeleton

```sql
fn(expr) OVER (
    PARTITION BY col1, col2     -- optional
    ORDER     BY col3 [ASC|DESC]-- optional / required (depends)
    {ROWS|RANGE} BETWEEN <lower> AND <higher>
)
```

### Frame Boundaries

```
UNBOUNDED PRECEDING   -- start of partition
N PRECEDING            -- N rows before current
CURRENT ROW            -- the current row
N FOLLOWING            -- N rows after current
UNBOUNDED FOLLOWING   -- end of partition
```

### Default Frame Cheats

| Have ORDER BY? | Default Frame                                   |
|----------------|--------------------------------------------------|
| No             | Entire partition                                 |
| Yes            | `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` |

### Function Quick Lookup

| Need…                                  | Use                                              |
|----------------------------------------|--------------------------------------------------|
| Unique row number                      | `ROW_NUMBER()`                                  |
| Rank with gaps after ties              | `RANK()`                                        |
| Rank without gaps                      | `DENSE_RANK()`                                  |
| Split into N buckets                   | `NTILE(n)`                                      |
| Cumulative distribution (0..1)         | `CUME_DIST()`                                   |
| Percentile rank (0..1)                 | `PERCENT_RANK()`                                |
| Next row's value                       | `LEAD(expr, offset, default)`                   |
| Previous row's value                   | `LAG(expr, offset, default)`                    |
| First value in window                  | `FIRST_VALUE(expr)`                             |
| Last value in window                   | `LAST_VALUE(expr)` + frame UNBOUNDED FOLLOWING |
| Running total                          | `SUM(x) OVER (ORDER BY d)`                      |
| Rolling total (3-row)                  | `SUM(x) OVER (ORDER BY d ROWS 2 PRECEDING)`     |
| Moving average (3-row)                 | `AVG(x) OVER (ORDER BY d ROWS 2 PRECEDING)`     |
| Part-to-whole share                    | `x / SUM(x) OVER (PARTITION BY group)`          |
| Top N per group                        | `RANK() OVER (PARTITION BY g ORDER BY x DESC)` |
| Remove duplicates (keep latest)        | `ROW_NUMBER() OVER (PARTITION BY key ORDER BY date DESC) = 1` |

### Required vs Optional Cheat Sheet

| Function            | PARTITION BY | ORDER BY    | Frame       |
|---------------------|--------------|-------------|-------------|
| Aggregate           | Optional     | Optional    | Optional    |
| `ROW_NUMBER`        | Optional     | Required    | Not allowed |
| `RANK`              | Optional     | Required    | Not allowed |
| `DENSE_RANK`        | Optional     | Required    | Not allowed |
| `NTILE`             | Optional     | Required    | Not allowed |
| `CUME_DIST`         | Optional     | Required    | Not allowed |
| `PERCENT_RANK`      | Optional     | Required    | Not allowed |
| `LEAD` / `LAG`      | Optional     | Required    | Not allowed |
| `FIRST_VALUE`       | Optional     | Required    | Optional    |
| `LAST_VALUE`        | Optional     | Required    | **Should use** |

### Window Function Rules (memorize)

1. ✅ Only in **SELECT** and **ORDER BY**
2. ❌ No nesting window functions
3. ⏭ Runs **after WHERE**
4. ⚖ Combinable with `GROUP BY` **only if same columns**

### Compact Frame Form (only for PRECEDING)

```sql
-- These are equivalent:
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
ROWS 2 PRECEDING                          -- short form

-- For FOLLOWING, no shortcut exists:
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING  -- must spell it out
```

---

> 🎓 **Built for learning.** Star this repo, fork it, and use these notes whenever you're stuck on SQL window functions.
> Notes by *Data With Baraa* SQL Course — adapted into deep markdown notes for self-study.
