-- ===================== COUNT FUNCTION =====================

-- Counting total rows, non-null values, and column-specific counts
SELECT 
    *, 
    COUNT(1) OVER() AS TCO, -- Total Count of Rows (including NULLs)
    COUNT(*) OVER() AS TCS, -- Total Count of Rows (same as COUNT(1))
    COUNT(c.Score) OVER() AS CS, -- Count of Non-NULL Scores
    COUNT(c.Country) OVER() AS cc -- Count of Non-NULL Country Values
FROM Sales.Customers c;


-- Counting occurrences of OrderID using window function
SELECT 
    OrderID,
    COUNT(OrderID) OVER(PARTITION BY o.OrderID) AS OrderCount
FROM Sales.Orders o;


-- Checking for duplicate OrderIDs in OrdersArchive
SELECT 
    *, 
    OrderID,
    COUNT(OrderID) OVER(PARTITION BY oa.OrderID) AS CheckPK
FROM Sales.OrdersArchive oa;


-- Identifying duplicate OrderIDs (Orders appearing more than once)
SELECT 
    * 
FROM (
    SELECT 
        oa.OrderID,
        COUNT(oa.OrderID) OVER(PARTITION BY oa.OrderID) AS CheckPK
    FROM Sales.OrdersArchive oa
) AS T
WHERE CheckPK > 1;

-- COUNT Function Use Cases:
-- 1. Identifying NULL values.
-- 2. Identifying duplicates in tables.
-- 3. Counting occurrences of data in different partitions.

-- ===================== SUM FUNCTION =====================

-- Calculating total sales and sales per product
SELECT 
    o.OrderID,
    o.ProductID,
    o.OrderDate,
    SUM(o.Sales) OVER() AS OVALL, -- Total Sales for all orders
    SUM(o.Sales) OVER(PARTITION BY o.ProductID) AS Pcd -- Sales grouped by ProductID
FROM Sales.Orders o;


-- Calculating percentage contribution of each sale to total sales
SELECT 
    o.OrderID,
    o.ProductID,
    o.OrderDate,
    SUM(o.Sales) OVER() AS OVALL, -- Total Sales for all orders
    ROUND(CAST(o.Sales AS FLOAT) / SUM(o.Sales) OVER() * 100, 2) AS PERST -- Percentage of total sales
FROM Sales.Orders o;


-- Calculating average sales per product and overall
SELECT 
    o.OrderID,
    o.ProductID,
    o.OrderDate,
    AVG(o.Sales) OVER() AS AVALL, -- Overall average sales
    AVG(o.Sales) OVER(PARTITION BY o.ProductID) AS AVGP -- Average sales per product
FROM Sales.Orders o;


-- Handling NULL values while calculating average scores
SELECT 
    c.CustomerID,
    c.Country,
    AVG(c.Score) OVER() AS AVGOVERALL, -- Average score across all customers
    AVG(COALESCE(c.Score, 0)) OVER(PARTITION BY c.CustomerID) AS AVGCUST -- Average per customer, treating NULL as 0
FROM Sales.Customers c;


-- Filtering sales greater than the overall average
SELECT 
    * 
FROM (
    SELECT 
        o.OrderID,
        o.OrderDate,
        o.Sales,
        AVG(o.Sales) OVER() AS AVGS -- Calculating overall average sales
    FROM Sales.Orders o
) AS SUB
WHERE Sales > AVGS; -- Filtering rows where sales are greater than average

-- ===================== MIN / MAX FUNCTION =====================

-- Finding maximum and minimum sales per product and overall
SELECT 
    o.OrderID,
    o.OrderDate,
    o.Sales,
    o.ProductID,
    MAX(o.Sales) OVER(PARTITION BY o.ProductID) AS MAXP, -- Maximum sales per product
    MIN(o.Sales) OVER(PARTITION BY o.ProductID) AS MINP, -- Minimum sales per product
    MAX(o.Sales) OVER() AS MAXO, -- Overall maximum sales
    MIN(o.Sales) OVER() AS MINO -- Overall minimum sales
FROM Sales.Orders o;


-- Finding the employee with the highest salary
SELECT 
    * 
FROM (
    SELECT 
        e.*, 
        MAX(e.Salary) OVER() AS MX -- Maximum salary across all employees
    FROM Sales.Employees e
) AS T
WHERE Salary = MX; -- Filtering only the highest salary


-- Difference between max sales and min sales per product
SELECT 
    o.OrderID,
    o.OrderDate,
    o.Sales,
    o.ProductID,
    MAX(o.Sales) OVER() AS MAXO, -- Maximum sales overall
    MIN(o.Sales) OVER() AS MINO, -- Minimum sales overall
    o.Sales - MIN(o.Sales) OVER() AS MAXD, -- Difference between current sale and minimum sale
    MAX(o.Sales) OVER() - o.Sales AS MIND -- Difference between maximum sale and current sale
FROM Sales.Orders o;


-- Moving average for sales per product
SELECT 
    o.OrderID,
    o.OrderDate,
    o.Sales,
    o.ProductID,
    AVG(o.Sales) OVER(PARTITION BY o.ProductID) AS ASales, -- Average sales per product
    AVG(o.Sales) OVER(PARTITION BY o.ProductID ORDER BY o.OrderDate) AS MOVINGAVG -- Moving average ordered by date
FROM Sales.Orders o;


-- Rolling average with a defined window frame
SELECT 
    o.OrderID,
    o.OrderDate,
    o.Sales,
    o.ProductID,
    AVG(o.Sales) OVER(PARTITION BY o.ProductID) AS ASales, -- Average sales per product
    AVG(o.Sales) OVER(PARTITION BY o.ProductID ORDER BY o.OrderDate) AS MOVINGAVG, -- Moving average ordered by date
    AVG(o.Sales) OVER(
        PARTITION BY o.ProductID 
        ORDER BY o.OrderDate 
        ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
    ) AS ROLLINGAVG -- Rolling average considering current row and the next row
FROM Sales.Orders o;
