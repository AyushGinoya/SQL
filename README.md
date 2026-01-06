# Resources that I have used:

1. [DataWithBaraa YouTube Channel](https://www.youtube.com/@DataWithBaraa)



---

# 📘 Easy SQL Theory Guide

This guide explains **important SQL concepts** in a simple and intuitive way, with real-world examples to make learning easy.

---

## 1️⃣ JOINs – Combining Tables

**JOINs** are used to combine rows from two or more tables based on a related column.

👉 **Think of JOINs as matching rows from different tables using a common key.**

### Types of JOINs

#### 🔹 INNER JOIN

* Returns **only matching rows** from both tables
* Similar to an **intersection**

```
Only records that exist in both tables
```

#### 🔹 LEFT JOIN

* Returns **all rows from the left table**
* Matching rows from the right table
* If no match → `NULL` values

```
Left table is always complete
To find records with NO matches, start from the table that may have missing references.
```

#### 🔹 RIGHT JOIN

* Returns **all rows from the right table**
* Matching rows from the left table
* If no match → `NULL` values

```
Right table is always complete
```

#### 🔹 FULL OUTER JOIN

* Returns **all rows from both tables**
* `NULL` where no match exists

```
Complete data from both tables
```

## 2️⃣ GROUP BY – Summarizing Data

`GROUP BY` is used to **group rows that share the same values** and then apply **aggregate functions**.

### Common Aggregate Functions

* `COUNT()`
* `SUM()`
* `AVG()`
* `MAX()`
* `MIN()`

👉 **Think of GROUP BY like sorting fruits into baskets by type, then counting each basket.**

### 🧠 Example

```
GROUP BY Department
SUM(Salary)
```

✔️ This gives the **total salary per department**

⚠️ Important Rule:

> Every column in `SELECT` must either be:

* In `GROUP BY`
* Or used inside an aggregate function

---

## 3️⃣ Window Functions – Calculations Across Rows

Window functions perform calculations **without collapsing rows**.

```
Window functions cannot detect missing rows. To find “no data”, you must query the parent table.
```
👉 **Unlike GROUP BY, each row keeps its identity.**

### Common Window Functions

#### 🔹 ROW_NUMBER()

* Assigns unique numbers (1, 2, 3, …)

#### 🔹 RANK()

* Assigns ranks
* Can have duplicates
* Skips numbers after ties
  (Example: 1, 2, 2, 4)

#### 🔹 LAG() / LEAD()

* Access previous or next row values
* Useful for comparisons

#### 🔹 Aggregate Functions with OVER()

* `SUM() OVER()`
* `AVG() OVER()`
* `COUNT() OVER()`
* Used for:

  * Running totals
  * Moving averages

### 🔑 Key Syntax

```sql
OVER (PARTITION BY column ORDER BY column)
```

📌 Example Use Cases:

* Ranking employees by salary
* Finding salary difference from previous employee
* Calculating cumulative totals

---

## 4️⃣ CTEs – Common Table Expressions (WITH Clause)

CTEs are **temporary named result sets** that exist only during query execution.

👉 **Think of CTEs as “scratch paper” for your SQL query.**

### Basic Syntax

```sql
WITH temp_result AS (
    SELECT ...
)
SELECT * FROM temp_result;
```

### ✅ Benefits of CTEs

* Improves **readability**
* Simplifies **complex queries**
* Can be referenced **multiple times**
* Enables **recursive queries**

📌 Use CTEs when:

* Queries become too long
* You want cleaner, modular SQL
* You need step-by-step logic

---

Just tell me 👍

