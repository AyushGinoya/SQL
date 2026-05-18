# SQL 30 Performance Tips — Complete Cheat Sheet

> A deep-dive into 30 battle-tested SQL performance tips. Each tip explains **what to do**, **why it matters**, **the wrong way**, **the right way**, and **the underlying mechanics**. Includes interview Q&A and a quick-reference summary at the end.

> 🎯 **Golden Rule:** **Always test using the Execution Plan.** Every optimization claim should be verified — run your query before and after, check the plan, measure the time.

---

## 📑 Table of Contents

### Categories
- [🔍 Fetching Data (Tips #1–#3)](#-fetching-data-tips-13)
- [🔎 Filtering Data (Tips #4–#7)](#-filtering-data-tips-47)
- [🔗 Joining Data (Tips #8–#16)](#-joining-data-tips-816)
- [📊 Aggregating Data (Tips #17–#18)](#-aggregating-data-tips-1718)
- [🪆 Subqueries (Tips #19–#20)](#-subqueries-tips-1920)
- [🏗️ DDL — Data Definition (Tips #21–#25)](#️-ddl--data-definition-tips-2125)
- [🚀 Indexing (Tips #26–#30)](#-indexing-tips-2630)

### Extras
- [📋 How to Read an Execution Plan](#-how-to-read-an-execution-plan)
- [🎯 Interview Questions & Answers](#-interview-questions--answers)
- [🧾 Quick Reference Cheat Sheet](#-quick-reference-cheat-sheet)

---

## 🔍 FETCHING DATA (Tips #1–#3)

### Tip #1 — Only Select the Columns You Need. Avoid `SELECT *`

**Why it matters:**
- `SELECT *` returns **all columns**, including large ones (TEXT, BLOB, VARCHAR(MAX)) you may not need.
- More data = more **I/O**, more **network traffic**, more **memory** consumed.
- Prevents the optimizer from using **covering indexes** (since it must fetch every column).
- Breaks if the table schema changes (new columns appear unexpectedly).

#### ❌ Bad
```sql
SELECT * FROM Customers WHERE Country = 'USA';
```

#### ✅ Good
```sql
SELECT CustomerID, FirstName, LastName, Email
FROM Customers
WHERE Country = 'USA';
```

#### Hidden Benefit: Covering Index
```sql
-- This index can FULLY answer the good query above (covering index)
CREATE NONCLUSTERED INDEX IX_Customers_Country
ON Customers (Country)
INCLUDE (CustomerID, FirstName, LastName, Email);
```
With `SELECT *`, the index couldn't cover the query → extra lookups to base table.

---

### Tip #2 — Avoid `DISTINCT` or `ORDER BY` Unless Absolutely Necessary

**Why it matters:**
- `DISTINCT` requires the engine to **sort or hash** all rows to find unique values → expensive.
- `ORDER BY` triggers a **sort operation** → memory + CPU intensive.
- Often `DISTINCT` is used as a **band-aid** to hide a JOIN that's creating duplicates — fix the JOIN instead.

#### ❌ Bad — DISTINCT hiding a JOIN problem
```sql
SELECT DISTINCT c.CustomerID, c.Name
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;
-- If a customer has 10 orders, the JOIN creates 10 rows → DISTINCT removes 9
```

#### ✅ Good — Use EXISTS instead
```sql
SELECT c.CustomerID, c.Name
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
);
```

#### ❌ Bad — Unnecessary ORDER BY
```sql
SELECT ProductID, ProductName FROM Products ORDER BY ProductName;
-- If the result is consumed by an app that re-sorts anyway, this is wasted work
```

#### ✅ Good — Only sort if the user actually needs it
```sql
SELECT ProductID, ProductName FROM Products;
```

> ⚠️ **Exception:** If sort is required for `TOP`, pagination, or display purposes, keep it — but ensure a supporting index exists.

---

### Tip #3 — For Exploration, Limit Rows Using `TOP` / `LIMIT`

**Why it matters:**
- When exploring an unknown table, you don't need millions of rows — you need a **sample**.
- Avoids accidentally returning a huge result set that crashes your client or fills your memory.

#### ✅ Good — Sample data first

```sql
-- SQL Server
SELECT TOP 100 * FROM Orders;

-- MySQL / PostgreSQL
SELECT * FROM Orders LIMIT 100;

-- Oracle
SELECT * FROM Orders FETCH FIRST 100 ROWS ONLY;
```

#### Use `TABLESAMPLE` for random samples
```sql
SELECT * FROM Orders TABLESAMPLE (1 PERCENT);
```

#### ⚠️ Gotcha: `TOP` without `ORDER BY`
The rows returned are **not deterministic** — could be different each time.
```sql
SELECT TOP 100 * FROM Orders ORDER BY OrderID;  -- ✅ deterministic
```

---

## 🔎 FILTERING DATA (Tips #4–#7)

### Tip #4 — Create Non-Clustered Indexes on `WHERE` Columns

**Why it matters:**
- Without an index, the engine does a **full table scan**.
- A non-clustered index on the filter column enables an **index seek** → O(log n) instead of O(n).

#### Scenario
```sql
SELECT CustomerID, OrderDate, Amount
FROM Orders
WHERE Status = 'Pending';   -- Status used in WHERE often
```

#### Create the index
```sql
CREATE NONCLUSTERED INDEX IX_Orders_Status
ON Orders (Status);
```

#### Even better — a covering index
```sql
CREATE NONCLUSTERED INDEX IX_Orders_Status_Cover
ON Orders (Status)
INCLUDE (CustomerID, OrderDate, Amount);  -- All SELECT columns
```

#### Rule of thumb for index columns
| Column Used In | Index? |
|----------------|--------|
| `WHERE` clause | ✅ Yes (filter columns) |
| `JOIN ... ON` | ✅ Yes (join columns) |
| `ORDER BY` | ✅ Often helpful |
| `GROUP BY` | ✅ Often helpful |
| `SELECT` only | ⚠️ Use `INCLUDE` for covering |

---

### Tip #5 — Avoid Functions on Indexed Columns in `WHERE` (Non-SARGable)

**Why it matters:**
- Wrapping a column in a function (`UPPER()`, `YEAR()`, `CAST()`, etc.) makes the predicate **non-SARGable** (Search ARGument Able).
- The engine **can't use the index** because it can't pre-compute the function for every indexed value efficiently — it falls back to a **full scan**.

#### ❌ Bad — Function on column
```sql
-- Index on OrderDate exists but won't be used
SELECT * FROM Orders WHERE YEAR(OrderDate) = 2025;

-- Index on Email won't be used
SELECT * FROM Customers WHERE UPPER(Email) = 'BOB@X.COM';

-- Same problem
SELECT * FROM Customers WHERE CAST(CustomerID AS VARCHAR) = '123';
```

#### ✅ Good — Rewrite to keep the column "naked"
```sql
-- Use a range instead of YEAR()
SELECT * FROM Orders
WHERE OrderDate >= '2025-01-01' AND OrderDate < '2026-01-01';

-- Apply function to literal, not column
SELECT * FROM Customers WHERE Email = LOWER('bob@x.com');
-- (or store emails in canonical case to begin with)

-- Compare numbers as numbers
SELECT * FROM Customers WHERE CustomerID = 123;
```

#### Common non-SARGable patterns to fix
| Non-SARGable | SARGable Rewrite |
|--------------|-------------------|
| `WHERE YEAR(d) = 2025` | `WHERE d >= '2025-01-01' AND d < '2026-01-01'` |
| `WHERE MONTH(d) = 6` | `WHERE d >= '2025-06-01' AND d < '2025-07-01'` (if year is known) |
| `WHERE UPPER(name) = 'BOB'` | `WHERE name = 'Bob'` + use collation, or store normalized |
| `WHERE ISNULL(col, 0) = 0` | `WHERE col = 0 OR col IS NULL` |
| `WHERE col + 1 = 10` | `WHERE col = 9` |
| `WHERE CAST(col AS INT) = 5` | Fix the data type instead |

---

### Tip #6 — Don't Start String Searches With a Wildcard

**Why it matters:**
- B-Tree indexes are sorted alphabetically. A leading wildcard means "match anywhere," so the engine **can't seek** into the tree.
- `LIKE 'abc%'` → ✅ uses index (seeks to "abc" range).
- `LIKE '%abc'` or `LIKE '%abc%'` → ❌ full scan.

#### ❌ Bad — Leading wildcard
```sql
SELECT * FROM Products WHERE ProductName LIKE '%phone%';
-- Full scan even with an index on ProductName
```

#### ✅ Good — Trailing wildcard only
```sql
SELECT * FROM Products WHERE ProductName LIKE 'iPhone%';
-- Index seek
```

#### Visualization

```
B-Tree (index on ProductName, sorted alphabetically):

   Apple → Banana → iPhone → iPhone 15 → Samsung → ...

LIKE 'iPhone%'   →  seek to "iPhone", scan forward to first non-match  ✅
LIKE '%phone%'   →  could match "iPhone", "Headphone", "Microphone"...
                    must check every entry → no seek possible           ❌
```

#### When you truly need "contains" search
- Use a **Full-Text Index** (SQL Server, PostgreSQL `tsvector`, MySQL `FULLTEXT`).
- Or use a dedicated search engine (Elasticsearch, OpenSearch).

```sql
-- SQL Server Full-Text Search
SELECT * FROM Products WHERE CONTAINS(ProductName, 'phone');
```

---

### Tip #7 — Use `IN` Instead of Multiple `OR` Conditions

**Why it matters:**
- `IN` is more **readable** and lets the optimizer treat the list as a single set lookup.
- The optimizer often rewrites multiple `OR`s as `IN` internally — but writing it cleanly helps maintainability and sometimes performance.

#### ❌ Bad — Repetitive OR chain
```sql
SELECT * FROM Orders
WHERE Status = 'Pending'
   OR Status = 'Shipped'
   OR Status = 'Delivered'
   OR Status = 'Cancelled';
```

#### ✅ Good — IN list
```sql
SELECT * FROM Orders
WHERE Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled');
```

#### ⚠️ Caveat — Very Large IN Lists
- `IN` with thousands of values can hurt performance and hit parameter limits.
- For large lists, use a **temp table** or **table-valued parameter**:

```sql
-- Better for large lists (1000+ values)
CREATE TABLE #StatusFilter (Status VARCHAR(20));
INSERT INTO #StatusFilter VALUES ('Pending'), ('Shipped'), ...;

SELECT o.*
FROM Orders o
JOIN #StatusFilter f ON o.Status = f.Status;
```

---

## 🔗 JOINING DATA (Tips #8–#16)

### Tip #8 — Understand Join Performance. Prefer `INNER JOIN`

**Why it matters:**
Different join types have different costs:

| Join Type | Returns | Cost |
|-----------|---------|------|
| `INNER JOIN` | Only matching rows | ✅ Lowest |
| `LEFT JOIN` | All from left + matches from right (NULLs otherwise) | Medium |
| `RIGHT JOIN` | All from right + matches from left | Medium |
| `FULL OUTER JOIN` | All rows from both sides | Highest |
| `CROSS JOIN` | Cartesian product (every row × every row) | ⚠️ Explosive |

#### ✅ Use `INNER JOIN` when you only need matched rows
```sql
SELECT c.Name, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;
-- Only customers WHO have orders
```

#### ⚠️ Don't use LEFT JOIN "just in case"
```sql
-- ❌ Wasteful if you'll filter out the unmatched rows anyway
SELECT c.Name, o.OrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NOT NULL;  -- This turns LEFT JOIN into INNER JOIN!
```

---

### Tip #9 — Always Use Explicit (ANSI-Style) JOINs

**Why it matters:**
- Implicit joins (`WHERE` join syntax) are **deprecated**, **hard to read**, and **error-prone** (easy to forget a condition → accidental cartesian).
- Explicit joins (`INNER JOIN ... ON`) separate **join logic** from **filter logic**.

#### ❌ Bad — Old implicit syntax
```sql
SELECT *
FROM Customers c, Orders o
WHERE c.CustomerID = o.CustomerID
  AND o.Status = 'Pending';
```

#### ✅ Good — Explicit ANSI syntax
```sql
SELECT *
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.Status = 'Pending';
```

#### Why this matters for outer joins
The old `(+)` Oracle outer join syntax and `*=`, `=*` SQL Server syntax are **deprecated** and don't always behave consistently. Always use `LEFT JOIN` / `RIGHT JOIN` / `FULL JOIN`.

---

### Tip #10 — Index the Join Columns

**Why it matters:**
- JOINs internally perform repeated lookups on the join column.
- Without indexes, the engine resorts to **nested loops scans** or **hash joins** that scan everything.
- With indexes, the engine can use efficient **merge joins** or **index seeks**.

#### Scenario
```sql
SELECT c.Name, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;
```

#### Ensure these indexes exist
```sql
-- Customers.CustomerID is usually a clustered PK (already indexed)
-- Make sure Orders.CustomerID has a non-clustered index
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
ON Orders (CustomerID);
```

#### Rule
> Foreign key columns should **almost always** have a non-clustered index on them.

---

### Tip #11 — Filter Before Joining Large Tables

**Why it matters:**
- Joining 1M × 1M rows is far more expensive than joining 100 × 1M.
- Filtering early **shrinks the dataset** before the JOIN operation.
- Modern optimizers often do this for you, but writing it explicitly guarantees it.

#### ❌ Bad — Filter after JOIN
```sql
SELECT c.Name, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA' AND o.OrderDate >= '2025-01-01';
-- Engine MIGHT do the right thing, but no guarantee
```

#### ✅ Good — Filter early with subqueries / CTEs
```sql
WITH USCustomers AS (
    SELECT CustomerID, Name FROM Customers WHERE Country = 'USA'
),
RecentOrders AS (
    SELECT CustomerID, OrderDate FROM Orders WHERE OrderDate >= '2025-01-01'
)
SELECT c.Name, o.OrderDate
FROM USCustomers c
JOIN RecentOrders o ON c.CustomerID = o.CustomerID;
```

#### Mental model
```
1M Customers ⨯ 10M Orders                       100 USCustomers ⨯ 50K RecentOrders
─────────────────────────                       ──────────────────────────────────
Massive join, then filter           VS         Small join — already filtered
        🐌                                                🚀
```

---

### Tip #12 — Aggregate Before Joining Large Tables

**Why it matters:**
- If you need `SUM(amount) BY customer`, aggregate **first**, then join → way fewer rows.
- Same principle as filtering early.

#### ❌ Bad — Join first, then aggregate
```sql
SELECT c.Name, SUM(o.Amount) AS Total
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Name;
-- Joins all 10M orders to customers, then groups
```

#### ✅ Good — Aggregate first
```sql
SELECT c.Name, t.Total
FROM Customers c
JOIN (
    SELECT CustomerID, SUM(Amount) AS Total
    FROM Orders
    GROUP BY CustomerID
) t ON c.CustomerID = t.CustomerID;
-- Orders are pre-aggregated to ~1M rows (one per customer), then joined
```

---

### Tip #13 — Replace `OR` in Join Conditions With `UNION`

**Why it matters:**
- `OR` in join conditions confuses the optimizer — it often can't use indexes effectively.
- Splitting into two queries combined with `UNION` lets each leg use its index.

#### ❌ Bad — OR in JOIN
```sql
SELECT *
FROM Customers c
JOIN Orders o
  ON c.CustomerID = o.CustomerID
  OR c.Email = o.GuestEmail;
-- Optimizer struggles — likely a nested loops with scans
```

#### ✅ Good — Split with UNION
```sql
SELECT *
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT *
FROM Customers c
JOIN Orders o ON c.Email = o.GuestEmail;
-- Each JOIN can use its respective index
```

---

### Tip #14 — Beware Nested Loops. Use SQL Hints When Needed

**Why it matters:**
- The query optimizer chooses between **Nested Loops**, **Hash Match**, and **Merge Join**.
- **Nested loops** are great for small inputs but catastrophic on large ones (O(n × m)).
- Check the execution plan — if you see a nested loops on two huge tables, performance will suffer.

#### Join Algorithms

| Algorithm | Best For | Cost |
|-----------|----------|------|
| **Nested Loops** | Small outer + indexed inner | Cheap on small data |
| **Hash Match** | Two large unsorted tables | Builds hash → uses memory |
| **Merge Join** | Two large sorted tables | Cheapest for big sorted data |

#### Forcing a join type (SQL Server)
```sql
SELECT *
FROM Customers c
INNER HASH JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Other options: INNER MERGE JOIN, INNER LOOP JOIN
```

> ⚠️ **Use hints sparingly.** The optimizer usually knows best. Use hints only when you've confirmed via the execution plan that the optimizer is wrong.

---

### Tip #15 — Use `UNION ALL` Instead of `UNION` if Duplicates Are OK

**Why it matters:**
- `UNION` removes duplicates → requires an extra **sort or hash** step.
- `UNION ALL` simply concatenates → no de-duplication overhead.

#### ❌ Slower
```sql
SELECT CustomerID FROM Orders_2024
UNION
SELECT CustomerID FROM Orders_2025;
-- Sorts + de-duplicates
```

#### ✅ Faster (if duplicates are acceptable or impossible)
```sql
SELECT CustomerID FROM Orders_2024
UNION ALL
SELECT CustomerID FROM Orders_2025;
-- Pure concatenation
```

#### When duplicates are impossible
If the two sets are guaranteed disjoint (e.g., different year ranges, different statuses), **always use `UNION ALL`** — same result, faster execution.

---

### Tip #16 — When You Need Distinct Results, Use `UNION ALL + DISTINCT`

**Why it matters:**
- Surprisingly, `UNION ALL` followed by `DISTINCT` can be **faster** than `UNION` in some cases.
- Reason: the optimizer can sometimes parallelize the `UNION ALL` and then de-duplicate more efficiently than it can plan a `UNION`.

#### Approach
```sql
-- Instead of:
SELECT col FROM A
UNION
SELECT col FROM B;

-- Try:
SELECT DISTINCT col FROM (
    SELECT col FROM A
    UNION ALL
    SELECT col FROM B
) x;
```

> 📌 **Always test both** with execution plans — results depend on data, indexes, and the optimizer version.

---

## 📊 AGGREGATING DATA (Tips #17–#18)

### Tip #17 — Use Columnstore Indexes for Heavy Aggregations

**Why it matters:**
- Columnstore indexes store data **column-by-column** and use heavy **compression**.
- For analytical queries (`SUM`, `COUNT`, `AVG`, `GROUP BY` over millions of rows), they're **10–100× faster** than rowstore indexes.
- They read **only the columns needed**, not entire rows.

#### Use case
```sql
-- Fact table with 100M rows
SELECT Region, SUM(SalesAmount)
FROM FactSales
GROUP BY Region;
```

#### Apply columnstore
```sql
-- Clustered columnstore — best for pure OLAP fact tables
CREATE CLUSTERED COLUMNSTORE INDEX IX_FactSales_CS
ON FactSales;

-- Or non-clustered columnstore for mixed workloads
CREATE NONCLUSTERED COLUMNSTORE INDEX IX_FactSales_CS_NC
ON FactSales (Region, SalesAmount, OrderDate);
```

#### When to use what

| Workload | Index Type |
|----------|------------|
| OLTP (transactions) | Rowstore (Clustered B-Tree on PK) |
| OLAP (analytics, aggregations) | **Columnstore** |
| Mixed (real-time analytics on OLTP) | Non-Clustered Columnstore |

---

### Tip #18 — Pre-Aggregate Data Into a Separate Table

**Why it matters:**
- If reports/dashboards run the **same aggregation** thousands of times per day, computing it on the fly is wasteful.
- Pre-aggregate **once** (overnight ETL) into a summary table — queries become instant lookups.

#### Pattern
```sql
-- Source: FactSales (100M rows)
-- Target: a summary table

CREATE TABLE DailySalesSummary (
    SaleDate    DATE,
    Region      VARCHAR(50),
    TotalSales  DECIMAL(18,2),
    OrderCount  INT,
    PRIMARY KEY (SaleDate, Region)
);

-- Populate nightly
INSERT INTO DailySalesSummary
SELECT
    CAST(OrderDate AS DATE),
    Region,
    SUM(Amount),
    COUNT(*)
FROM FactSales
WHERE OrderDate >= DATEADD(DAY, -1, GETDATE())
GROUP BY CAST(OrderDate AS DATE), Region;
```

#### Now reports are instant
```sql
SELECT Region, SUM(TotalSales)
FROM DailySalesSummary
WHERE SaleDate BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY Region;
-- Reads ~365 rows per region vs 100M raw rows
```

#### Modern alternatives
- **Indexed Views / Materialized Views** — auto-maintained summaries.
- **Star schema with aggregate tables** — classic data warehouse pattern.

---

## 🪆 SUBQUERIES (Tips #19–#20)

### Tip #19 — Understand `JOIN` vs `EXISTS` vs `IN`

**Why it matters:**
Each pattern has different performance characteristics:

| Pattern | Best For | Notes |
|---------|----------|-------|
| **JOIN** | When you need columns from both tables | Can multiply rows if not careful |
| **EXISTS** | Checking existence (no duplicates) | Short-circuits — stops on first match |
| **IN (subquery)** | Small to medium lists | Can be inefficient on huge lists |
| **IN (literal list)** | Small literal lists | Fast for ≤ ~100 values |

#### Examples

```sql
-- Goal: Customers who have placed orders

-- 1️⃣ Using JOIN (returns duplicates if customer has multiple orders!)
SELECT DISTINCT c.CustomerID, c.Name
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 2️⃣ Using EXISTS (✅ usually best for existence checks)
SELECT c.CustomerID, c.Name
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
);

-- 3️⃣ Using IN
SELECT c.CustomerID, c.Name
FROM Customers c
WHERE c.CustomerID IN (SELECT CustomerID FROM Orders);
```

#### EXISTS vs IN — NULL Behavior Gotcha

```sql
-- ⚠️ This returns NOTHING if any value in the subquery is NULL!
SELECT * FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Blacklist);
-- If Blacklist has even one NULL, the entire NOT IN returns no rows

-- ✅ NOT EXISTS handles NULLs correctly
SELECT * FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM Blacklist b WHERE b.CustomerID = c.CustomerID
);
```

> 🚨 **The `NOT IN` with NULLs trap** is one of the most common SQL bugs. Always prefer `NOT EXISTS` for negation.

---

### Tip #20 — Simplify Queries Using CTEs

**Why it matters:**
- Common Table Expressions (CTEs) break complex queries into **readable, named steps**.
- Easier to debug, easier to maintain, often easier for the optimizer.
- Can replace deeply nested subqueries.

#### ❌ Bad — Nested subqueries
```sql
SELECT *
FROM (
    SELECT c.CustomerID, c.Name, (
        SELECT COUNT(*)
        FROM Orders o
        WHERE o.CustomerID = c.CustomerID
          AND o.OrderDate >= (SELECT MAX(OrderDate) FROM Orders) - 30
    ) AS RecentOrders
    FROM Customers c
) x
WHERE x.RecentOrders > 5;
```

#### ✅ Good — Step-by-step CTE
```sql
WITH MaxDate AS (
    SELECT MAX(OrderDate) AS MaxOrderDate FROM Orders
),
RecentOrderCounts AS (
    SELECT
        o.CustomerID,
        COUNT(*) AS RecentOrders
    FROM Orders o
    CROSS JOIN MaxDate m
    WHERE o.OrderDate >= DATEADD(DAY, -30, m.MaxOrderDate)
    GROUP BY o.CustomerID
)
SELECT c.CustomerID, c.Name, r.RecentOrders
FROM Customers c
JOIN RecentOrderCounts r ON c.CustomerID = r.CustomerID
WHERE r.RecentOrders > 5;
```

#### Bonus: Recursive CTEs
```sql
-- Walk an employee hierarchy
WITH OrgChart AS (
    SELECT EmployeeID, ManagerID, Name, 1 AS Level
    FROM Employees WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.ManagerID, e.Name, oc.Level + 1
    FROM Employees e
    JOIN OrgChart oc ON e.ManagerID = oc.EmployeeID
)
SELECT * FROM OrgChart ORDER BY Level;
```

---

## 🏗️ DDL — Data Definition (Tips #21–#25)

### Tip #21 — Choose Precise Data Types

**Why it matters:**
- Each data type has a **fixed storage cost**.
- Smaller types = less I/O, smaller indexes, faster comparisons, less memory.
- Choosing `VARCHAR(MAX)` for a 5-character zip code wastes huge amounts of space.

#### Common types & sizes (SQL Server)

| Type | Storage | Use For |
|------|---------|---------|
| `BIT` | 1 bit | Booleans (Yes/No, Active/Inactive) |
| `TINYINT` | 1 byte (0–255) | Small numbers (age, status code) |
| `SMALLINT` | 2 bytes (±32K) | Small numeric IDs |
| `INT` | 4 bytes (±2.1B) | Most IDs |
| `BIGINT` | 8 bytes | Very large IDs (billions+) |
| `DECIMAL(p,s)` | 5–17 bytes | Money, exact decimals |
| `FLOAT` | 8 bytes | Scientific/inexact decimals |
| `DATE` | 3 bytes | Just dates (no time) |
| `DATETIME2` | 6–8 bytes | Modern timestamp |
| `CHAR(n)` | Fixed n bytes | Fixed-length strings (e.g., country codes) |
| `VARCHAR(n)` | Variable, up to n | Variable strings |
| `NVARCHAR(n)` | 2× bytes | Unicode (international text) |

#### ❌ Bad
```sql
CREATE TABLE Customers (
    CustomerID  VARCHAR(100),    -- Should be INT
    Age         VARCHAR(10),     -- Should be TINYINT
    IsActive    VARCHAR(5),      -- Should be BIT
    ZipCode     TEXT             -- Should be VARCHAR(10)
);
```

#### ✅ Good
```sql
CREATE TABLE Customers (
    CustomerID  INT IDENTITY(1,1) PRIMARY KEY,
    Age         TINYINT,
    IsActive    BIT,
    ZipCode     VARCHAR(10)
);
```

---

### Tip #22 — Avoid Excessive Lengths (`VARCHAR(MAX)` Unless Needed)

**Why it matters:**
- `VARCHAR(MAX)` / `NVARCHAR(MAX)` / `TEXT` stores data **out of row** (off the data page) when large.
- This adds I/O overhead and **prevents some optimizations** (indexing, in-memory operations).

#### ❌ Bad
```sql
CREATE TABLE Products (
    Name        VARCHAR(MAX),  -- Names won't be > 200 chars
    Description VARCHAR(MAX),  -- Maybe OK
    SKU         VARCHAR(MAX)   -- SKUs are short!
);
```

#### ✅ Good
```sql
CREATE TABLE Products (
    Name        VARCHAR(200),
    Description VARCHAR(MAX),  -- Genuinely long
    SKU         VARCHAR(50)
);
```

#### Rule
- Use `VARCHAR(n)` with a realistic `n` for short-to-medium strings.
- Use `VARCHAR(MAX)` **only** for genuinely large/unbounded text (articles, comments, descriptions).

---

### Tip #23 — Use `NOT NULL` Where Possible

**Why it matters:**
- `NULL` adds **complexity** to queries (3-valued logic).
- `NULL` columns require **extra storage** (null bitmap).
- `NULL` confuses comparisons (`NULL = NULL` is `UNKNOWN`, not `TRUE`).
- Indexes on nullable columns can be less efficient.

#### ❌ Bad — Everything nullable
```sql
CREATE TABLE Orders (
    OrderID    INT,           -- Should be NOT NULL (it's a PK)
    CustomerID INT,           -- Should be NOT NULL (every order has a customer)
    Amount     DECIMAL(10,2), -- Should be NOT NULL
    Status     VARCHAR(20)    -- Should be NOT NULL with a default
);
```

#### ✅ Good — Explicit NOT NULL
```sql
CREATE TABLE Orders (
    OrderID    INT             NOT NULL,
    CustomerID INT             NOT NULL,
    Amount     DECIMAL(10,2)   NOT NULL,
    Status     VARCHAR(20)     NOT NULL DEFAULT 'Pending',
    Notes      VARCHAR(500)    NULL  -- Truly optional
);
```

#### Three-valued logic problems
```sql
-- These return DIFFERENT results when NULLs exist
SELECT * FROM Orders WHERE Status = 'Cancelled';      -- Excludes NULLs
SELECT * FROM Orders WHERE Status <> 'Cancelled';     -- Also excludes NULLs!
SELECT * FROM Orders WHERE Status IS NULL;            -- Only NULLs
```

| `x` | `x = 'A'` | `x <> 'A'` | `x IS NULL` |
|-----|-----------|------------|-------------|
| `'A'` | TRUE | FALSE | FALSE |
| `'B'` | FALSE | TRUE | FALSE |
| `NULL` | UNKNOWN | UNKNOWN | TRUE |

---

### Tip #24 — Ensure All Tables Have a Clustered Primary Key

**Why it matters:**
- A clustered PK gives the table **physical structure** (sorted storage).
- Without it, the table is a **heap** → slow lookups, prone to fragmentation.
- The clustered key is included in every non-clustered index → makes it a powerful lookup mechanism.

#### ✅ Standard pattern
```sql
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) NOT NULL,
    Email      VARCHAR(255) NOT NULL,
    Created    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Customers PRIMARY KEY CLUSTERED (CustomerID)
);
```

#### Choosing a clustered key — best practices
✅ **Good clustered keys are:**
- Narrow (small data type — `INT` or `BIGINT`)
- Unique
- Static (never updated)
- Ever-increasing (avoids page splits — e.g., `IDENTITY`)

❌ **Bad clustered keys:**
- Wide (e.g., `VARCHAR(100)`)
- Random (e.g., `GUID` — causes fragmentation)
- Frequently updated

---

### Tip #25 — Index Foreign Keys That Are Frequently Queried

**Why it matters:**
- Foreign keys are constantly used in JOINs and lookups.
- SQL Server **does NOT automatically index FK columns** (unlike PKs).
- Missing FK indexes are one of the most common performance issues.

#### Scenario
```sql
CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    CustomerID INT NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID),
    Amount     DECIMAL(10,2)
);
-- ⚠️ CustomerID has no index by default!
```

#### Add the index
```sql
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
ON Orders (CustomerID);
```

#### Why this matters
```sql
SELECT * FROM Orders WHERE CustomerID = 123;
-- Without index: full scan
-- With index: instant seek

-- Also helps cascading deletes:
DELETE FROM Customers WHERE CustomerID = 123;
-- Engine needs to find all Orders with that CustomerID
-- Without index: full scan of Orders 😱
```

---

## 🚀 INDEXING (Tips #26–#30)

### Tip #26 — Avoid Over-Indexing

**Why it matters:**
- Every index speeds up **reads** but slows down **writes** (`INSERT`, `UPDATE`, `DELETE`).
- Every write must update all relevant indexes.
- Indexes consume **storage** and **memory** (buffer pool).
- Too many indexes can also confuse the optimizer.

#### The tradeoff
```
                  READS                     WRITES
                    ▲                          ▲
                    │                          │
                    │  ✅ More indexes         │  ❌ More indexes
                    │  → faster reads          │  → slower writes
                    │                          │
                    └──────────────────────────┘
                          Find the balance
```

#### Rule of thumb
| Table Type | Index Count Target |
|------------|---------------------|
| OLTP (write-heavy) | 3–5 indexes max |
| OLAP (read-heavy) | 5–10 indexes OK |
| Reference tables (read-only) | As needed for queries |

---

### Tip #27 — Drop Unused Indexes

**Why it matters:**
- Indexes that are never used by queries are **pure cost** (storage + write overhead).
- Common after schema evolution: old indexes get left behind.

#### Find unused indexes (SQL Server)
```sql
SELECT
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks,
    s.user_scans,
    s.user_lookups,
    s.user_updates
FROM sys.dm_db_index_usage_stats s
JOIN sys.indexes i
    ON i.object_id = s.object_id AND i.index_id = s.index_id
WHERE s.database_id = DB_ID()
  AND s.user_seeks = 0
  AND s.user_scans = 0
  AND s.user_lookups = 0
  AND s.user_updates > 0   -- Index is being maintained but never read
ORDER BY s.user_updates DESC;
```

#### Drop them
```sql
DROP INDEX IX_Orders_OldUnused ON Orders;
```

> ⚠️ Be careful — DMVs reset on SQL Server restart. Check after the server has been running for a while (e.g., a month).

---

### Tip #28 — Update Statistics Weekly

**Why it matters:**
- The query optimizer relies on **statistics** (row counts, value distribution histograms) to choose execution plans.
- Outdated stats → bad estimates → bad plans → slow queries.
- Auto-update happens only when ~20% of rows change — for large tables, that's millions of rows of staleness.

#### Manual update
```sql
-- Update all stats on a table
UPDATE STATISTICS Customers;

-- Full scan (most accurate, slower)
UPDATE STATISTICS Customers WITH FULLSCAN;

-- Specific index/statistic
UPDATE STATISTICS Customers IX_Customers_Email;

-- All stats in the database
EXEC sp_updatestats;
```

#### Automate it weekly
Set up a SQL Agent Job to run:
```sql
EXEC sp_updatestats;
-- Or for very large dbs, use Ola Hallengren's maintenance scripts
```

---

### Tip #29 — Reorganize/Rebuild Fragmented Indexes Weekly

**Why it matters:**
- Over time, inserts/updates cause **page splits** and **fragmentation**.
- Fragmented indexes have wasted space and require more I/O.
- Defragmentation restores performance.

#### Check fragmentation
```sql
SELECT
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent,
    ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN sys.indexes i
    ON i.object_id = ips.object_id AND i.index_id = ips.index_id
WHERE ips.page_count > 1000   -- Ignore tiny indexes
ORDER BY ips.avg_fragmentation_in_percent DESC;
```

#### Fix it

| Fragmentation | Action |
|---------------|--------|
| < 5% | Do nothing |
| 5% – 30% | `REORGANIZE` (online, lighter) |
| > 30% | `REBUILD` (heavier, can be online with Enterprise edition) |

```sql
-- Light defragmentation
ALTER INDEX IX_Orders_CustomerID ON Orders REORGANIZE;

-- Full rebuild
ALTER INDEX IX_Orders_CustomerID ON Orders REBUILD;

-- Online rebuild (no locking, Enterprise only)
ALTER INDEX IX_Orders_CustomerID ON Orders REBUILD WITH (ONLINE = ON);

-- Rebuild ALL indexes on a table
ALTER INDEX ALL ON Orders REBUILD;
```

---

### Tip #30 — For Large Tables: Partition + Columnstore

**Why it matters:**
- This is the **gold-standard combination** for large analytical tables (fact tables).
- **Partitioning** → splits data physically (e.g., by year) → enables partition elimination + parallel processing.
- **Columnstore** → compresses + scans only needed columns → massive analytical speed.
- **Together** → each partition is a compressed columnstore segment → unbeatable for OLAP at scale.

#### Pattern
```sql
-- Step 1: Create filegroups for each partition
ALTER DATABASE DW ADD FILEGROUP FG_2023;
ALTER DATABASE DW ADD FILEGROUP FG_2024;
ALTER DATABASE DW ADD FILEGROUP FG_2025;
ALTER DATABASE DW ADD FILEGROUP FG_2026;

-- (Add .ndf files to each filegroup ...)

-- Step 2: Partition function
CREATE PARTITION FUNCTION pfSalesYear (DATE)
AS RANGE RIGHT FOR VALUES ('2024-01-01', '2025-01-01', '2026-01-01');

-- Step 3: Partition scheme
CREATE PARTITION SCHEME psSalesYear
AS PARTITION pfSalesYear
TO (FG_2023, FG_2024, FG_2025, FG_2026);

-- Step 4: Create the table on the partition scheme
CREATE TABLE FactSales (
    SaleID     BIGINT NOT NULL,
    OrderDate  DATE NOT NULL,
    ProductID  INT NOT NULL,
    Amount     DECIMAL(18,2) NOT NULL
) ON psSalesYear (OrderDate);

-- Step 5: Add a CLUSTERED COLUMNSTORE INDEX, aligned to the partition scheme
CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactSales
ON FactSales
ON psSalesYear (OrderDate);
```

#### Query benefits
```sql
SELECT Region, SUM(Amount)
FROM FactSales
WHERE OrderDate >= '2025-01-01' AND OrderDate < '2026-01-01'
GROUP BY Region;
-- ✅ Engine reads ONLY the 2025 partition (partition elimination)
-- ✅ Reads ONLY the OrderDate, Region, Amount columns (columnstore)
-- ✅ Decompresses + aggregates in memory (extremely fast)
```

---

## 📋 How to Read an Execution Plan

> **Test every optimization** — claims of "this is faster" must be verified with the execution plan.

### Viewing the Plan (SQL Server)

```sql
-- 1. Estimated plan (without running the query)
SET SHOWPLAN_XML ON;
GO
SELECT * FROM Orders WHERE Status = 'Pending';
GO
SET SHOWPLAN_XML OFF;

-- 2. Actual plan (after running)
SET STATISTICS XML ON;
GO
SELECT * FROM Orders WHERE Status = 'Pending';
GO

-- 3. I/O and time stats
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO
SELECT * FROM Orders WHERE Status = 'Pending';
```

In SSMS, just click **"Include Actual Execution Plan"** (Ctrl+M).

### What to Look For

| Operator | Good or Bad? | Notes |
|----------|--------------|-------|
| **Index Seek** | ✅ Great | Direct B-Tree lookup |
| **Clustered Index Seek** | ✅ Great | Reading data via PK |
| **Index Scan** | ⚠️ OK / Bad | Full index read — only acceptable if needed |
| **Table Scan** | ❌ Bad | Full table read (no useful index) |
| **Key Lookup** | ⚠️ OK if rare | Index found rows, but had to go back to table |
| **Hash Match** | ⚠️ Big data | Acceptable on large unsorted data |
| **Sort** | ⚠️ Expensive | Try to avoid with proper indexes |
| **Nested Loops** | ✅ on small / ❌ on large | Watch the row counts |

### Red Flags
- 🚩 **Thick arrows** between operators → many rows flowing → consider filtering earlier.
- 🚩 **Missing Index hint** (green text) → SQL Server is telling you to add an index.
- 🚩 **Estimated vs Actual rows mismatch** → outdated statistics.
- 🚩 **Spool / Sort / Hash Aggregate with high cost** → likely needs an index or query rewrite.

---

## 🎯 Interview Questions & Answers

### 🟢 Beginner

**Q1. Why is `SELECT *` considered bad practice?**
> It fetches all columns, increasing I/O, network traffic, and memory usage. It prevents covering indexes from being used and makes queries fragile when schemas change. Always select only the columns you need.

---

**Q2. What's the difference between `UNION` and `UNION ALL`?**
> `UNION` removes duplicates (requires a sort/hash step). `UNION ALL` simply concatenates the results. `UNION ALL` is always faster — use it whenever duplicates are acceptable or impossible.

---

**Q3. Why is `LIKE '%word%'` slow?**
> A leading wildcard prevents the engine from using an index seek on the B-Tree (which is sorted alphabetically). It must scan every row. Use `LIKE 'word%'` or full-text search for substring matches.

---

**Q4. What is a SARGable query?**
> SARGable = Search ARGument Able. A query where the engine can use an index seek. Wrapping a column in a function (`YEAR(col)`, `UPPER(col)`) makes the predicate non-SARGable. Rewrite to keep the column "naked" (e.g., use date ranges instead of `YEAR()`).

---

**Q5. Why are explicit ANSI JOINs preferred over old comma-separated joins?**
> ANSI JOINs (`INNER JOIN ... ON`) separate join logic from filter logic, are clearer, more maintainable, and avoid the risk of accidentally creating a Cartesian product by forgetting a condition. They also fully support outer joins.

---

### 🟡 Intermediate

**Q6. What's the difference between `IN`, `EXISTS`, and `JOIN`?**

| Pattern | Best For | Notes |
|---------|----------|-------|
| `JOIN` | Need columns from both tables | May produce duplicates |
| `EXISTS` | Existence check (yes/no) | Short-circuits on first match; handles NULL correctly |
| `IN` | Small/medium value lists | Beware NULL trap with `NOT IN` |

For existence checks, `EXISTS` is generally safest.

---

**Q7. Why does `NOT IN` return no rows when the subquery contains NULLs?**
> SQL uses three-valued logic. `x NOT IN (1, 2, NULL)` is equivalent to `x <> 1 AND x <> 2 AND x <> NULL`. The last comparison is `UNKNOWN` for any `x`, making the whole expression `UNKNOWN` → no rows returned. Use `NOT EXISTS` to avoid this.

---

**Q8. When would you use a CTE vs a subquery?**
> Use a CTE when:
> - The query has multiple logical steps (improves readability).
> - You need to reference the same intermediate result multiple times.
> - You need recursion (recursive CTE).
>
> Use a subquery when:
> - The logic is simple and one-shot.
> - You need it in a single specific location.

---

**Q9. What is a covering index?**
> A non-clustered index that includes all columns referenced by a query, either in the key or via `INCLUDE`. The engine answers the query entirely from the index without going back to the base table.
> ```sql
> CREATE INDEX IX_Orders_Customer_Cover
> ON Orders (CustomerID)
> INCLUDE (OrderDate, Amount);
> ```

---

**Q10. Why is filtering BEFORE a join generally better?**
> Filtering reduces the dataset size before the join occurs, so fewer rows are matched. While modern optimizers often push predicates automatically, explicit early filtering (via subqueries/CTEs) guarantees it and improves readability.

---

**Q11. Why should foreign keys be indexed?**
> SQL Server does NOT automatically index FK columns (unlike PKs). FKs are used in JOINs and cascading operations — without an index, these become full table scans. Always add a non-clustered index on FK columns used in queries.

---

### 🔴 Advanced

**Q12. What's the difference between Nested Loops, Hash Match, and Merge Join?**

| Algorithm | Best For | Memory | Sort Required |
|-----------|----------|--------|---------------|
| **Nested Loops** | Small outer + indexed inner | Low | No |
| **Hash Match** | Large unsorted inputs | High (build hash) | No |
| **Merge Join** | Large pre-sorted inputs | Low | Yes (must be sorted) |

The optimizer chooses based on data sizes, indexes, and sort orders. You can force a specific algorithm with hints (e.g., `INNER HASH JOIN`) but should only do so after analysis.

---

**Q13. How does the optimizer decide between Index Seek and Index Scan?**
> Based on statistics — specifically, the estimated number of rows. If the engine thinks the query returns few rows (e.g., < 1% of the table), it picks a seek. For many rows (> 30%), it picks a scan or table scan because seeking + lookups for each row would be more expensive.

---

**Q14. Why should you avoid `VARCHAR(MAX)` unless necessary?**
> Values up to ~8000 bytes fit "in row" on a data page, but larger values are stored "off row" in LOB (Large Object) pages, adding I/O hops. Additionally, you can't create regular indexes on `VARCHAR(MAX)` columns. Always size your strings appropriately.

---

**Q15. What's the difference between `REORGANIZE` and `REBUILD`?**

| Aspect | REORGANIZE | REBUILD |
|--------|------------|---------|
| **Speed** | Slower | Faster (but heavier) |
| **Resource usage** | Light | Heavy |
| **Locking** | Online (no blocking) | Offline by default; online with Enterprise |
| **Effect** | Defragments + compacts pages | Drops and recreates the index |
| **Statistics** | Doesn't update stats | Updates stats with full scan |
| **When to use** | 5–30% fragmentation | > 30% fragmentation |

---

**Q16. What's the benefit of partitioning + columnstore for large fact tables?**
> Partition elimination + column-level reads + compression. The engine reads only the relevant partition AND only the requested columns AND processes compressed data — multiplying I/O savings. For a 100M-row fact table, a typical analytical query may end up reading less than 1% of the physical pages.

---

**Q17. How do you find missing indexes in SQL Server?**
> Use the missing index DMVs:
> ```sql
> SELECT
>     migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) AS Improvement,
>     mid.statement AS TableName,
>     mid.equality_columns,
>     mid.inequality_columns,
>     mid.included_columns
> FROM sys.dm_db_missing_index_groups mig
> JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
> JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
> ORDER BY Improvement DESC;
> ```
> Review carefully — the optimizer's suggestions aren't always optimal. Consolidate suggestions and avoid duplicate indexes.

---

**Q18. Should you always trust the optimizer's choice?**
> Mostly yes, but not always. The optimizer relies on statistics, and outdated/stale stats can lead to bad plans. Also, the optimizer uses heuristics — it doesn't always pick globally optimal plans. When you see a clearly suboptimal plan:
> 1. First, **update statistics**.
> 2. Then check **index design**.
> 3. As a last resort, use **query hints** (`OPTION (HASH JOIN)`, `OPTION (RECOMPILE)`).

---

**Q19. What is parameter sniffing and why is it a problem?**
> SQL Server caches the execution plan for a stored procedure based on the **first set of parameters** it sees. If those parameters are atypical (e.g., a value that returns 1 row when most values return 1M rows), the cached plan may be terrible for subsequent calls. Fixes include `OPTION (RECOMPILE)`, local variables, or `OPTIMIZE FOR` hints.

---

**Q20. What's the difference between an indexed view and a regular view?**
> A regular view is just a saved query — it doesn't store data. An indexed view (materialized view) physically stores its results and is automatically maintained when underlying data changes. Indexed views are great for pre-aggregated data but add write overhead.

---

## 🧾 Quick Reference Cheat Sheet

### 🔍 Fetching Data
| # | Tip |
|---|-----|
| 1 | Don't `SELECT *` — list columns explicitly |
| 2 | Avoid `DISTINCT` / `ORDER BY` unless required |
| 3 | Use `TOP` / `LIMIT` when exploring |

### 🔎 Filtering Data
| # | Tip |
|---|-----|
| 4 | Index columns used in `WHERE` |
| 5 | Don't wrap columns in functions (keeps queries SARGable) |
| 6 | Avoid leading wildcards (`LIKE '%word%'`) |
| 7 | Use `IN` over multiple `OR`s |

### 🔗 Joining Data
| # | Tip |
|---|-----|
| 8 | Prefer `INNER JOIN` when possible |
| 9 | Use explicit ANSI JOIN syntax |
| 10 | Index your join columns |
| 11 | Filter before joining |
| 12 | Aggregate before joining |
| 13 | Replace `OR` in joins with `UNION` |
| 14 | Watch nested loops; use hints sparingly |
| 15 | Use `UNION ALL` if duplicates OK |
| 16 | `UNION ALL + DISTINCT` can beat `UNION` |

### 📊 Aggregating Data
| # | Tip |
|---|-----|
| 17 | Use columnstore indexes for heavy aggregations |
| 18 | Pre-aggregate into summary tables |

### 🪆 Subqueries
| # | Tip |
|---|-----|
| 19 | Understand `JOIN` vs `EXISTS` vs `IN`; avoid `NOT IN` with NULLs |
| 20 | Use CTEs to simplify complex logic |

### 🏗️ DDL
| # | Tip |
|---|-----|
| 21 | Choose precise data types |
| 22 | Don't over-size strings (`VARCHAR(MAX)` only if needed) |
| 23 | Use `NOT NULL` where applicable |
| 24 | Every table → clustered primary key |
| 25 | Index foreign keys queried often |

### 🚀 Indexing
| # | Tip |
|---|-----|
| 26 | Don't over-index (write penalty) |
| 27 | Drop unused indexes |
| 28 | Update statistics weekly |
| 29 | Reorganize/rebuild fragmented indexes weekly |
| 30 | Large fact tables → partition + columnstore |

---

### 🛠️ Essential Diagnostic Queries

```sql
-- Top 10 most expensive queries
SELECT TOP 10
    qs.total_worker_time / qs.execution_count AS AvgCPU,
    qs.execution_count,
    SUBSTRING(qt.text, qs.statement_start_offset/2,
        (CASE WHEN qs.statement_end_offset = -1 THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
              ELSE qs.statement_end_offset END - qs.statement_start_offset)/2) AS Query
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY AvgCPU DESC;

-- Find missing indexes
SELECT * FROM sys.dm_db_missing_index_details;

-- Find unused indexes
SELECT * FROM sys.dm_db_index_usage_stats;

-- Find fragmented indexes
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 30;

-- Update all stats in a database
EXEC sp_updatestats;
```

---

### 📐 The Performance Mindset

```
1. MEASURE FIRST     → Use Execution Plan + STATISTICS IO/TIME
2. INDEX WISELY      → Right indexes on right columns
3. WRITE SARGABLE    → Keep columns naked in WHERE
4. FILTER EARLY      → Reduce dataset before JOIN/aggregation
5. JOIN SMARTLY      → ANSI syntax + indexed keys
6. TYPE PRECISELY    → Right data types, NOT NULL where possible
7. MAINTAIN REGULARLY→ Stats + defrag weekly
8. RETEST OFTEN      → Performance is a moving target
```

---

## 🎯 Final Mantra

> **"Always Test using the Execution Plan."**
>
> Performance advice — including everything in this document — is a **starting point**, not a guarantee. Real-world performance depends on your data, your queries, your hardware, and your workload. **Test, measure, iterate.**

---

*Notes compiled from the SQL 30 Performance Tips cheat sheet (Data With Baraa). Pair these with hands-on practice: enable `SET STATISTICS IO ON; SET STATISTICS TIME ON;` and watch the numbers change as you apply each tip.*
