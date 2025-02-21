-- Selecting all records from the Sales.Orders table
SELECT 
	*
FROM Sales.Orders


-- Using GROUP BY to aggregate data 
-- Grouping by OrderID, ProductID, and OrderDate to calculate total sales per order and product
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY 
	OrderID,
	ProductID,
	OrderDate


-- Using a window function to calculate the total sales for all rows (same value for each row)
SELECT 
	SUM(Sales) OVER() AS TotalSales
FROM Sales.Orders


-- Using PARTITION BY to calculate total sales for each ProductID
SELECT 
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProducts
FROM Sales.Orders


-- Adding OrderID and OrderDate while keeping total sales partitioned by ProductID
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProducts
FROM Sales.Orders


-- Adding OrderStatus to get more details along with total sales partitioned by ProductID
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProducts
FROM Sales.Orders


-- Calculating both total sales across all rows and total sales per product
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER() AS TotalSales,  -- Total sales of all orders
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProducts -- Total sales per product
FROM Sales.Orders


-- Further breaking down total sales by ProductID and OrderStatus
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER() AS TotalSales, -- Total sales of all orders
	SUM(Sales) OVER(PARTITION BY ProductID) AS SalesByProducts, -- Total sales per product
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) AS TotalSalesByProductsAndOrderStatus -- Total sales per product and order status
FROM Sales.Orders


-- Ranking sales in descending order (higher sales get a lower rank)
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	OrderStatus,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) AS RankSales
FROM Sales.Orders


-- Ranking sales within each product category in descending order
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	OrderStatus,
	Sales,
	RANK() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS RankSales
FROM Sales.Orders


-- Using SUM() as a window function with a range of 2 future rows (current row + next 2 rows)
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate 
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS RankSales
FROM Sales.Orders


-- Using SUM() as a window function with a range of 2 preceding rows (previous 2 rows + current row)
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate 
	ROWS 2 PRECEDING) AS RankSales
FROM Sales.Orders


-- Using SUM() as a window function from the beginning of the partition up to the current row
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate 
	ROWS UNBOUNDED PRECEDING) AS RankSales
FROM Sales.Orders


-- Default frame for window functions is: ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW


--NOTES

-- 1. WINDOW FUNCTIONS CAN ONLY BE USED IN SELECT AND ORDER BY CLAUSE
SELECT 
    OrderID,
    ProductID,
    OrderDate,
    OrderStatus,
    Sales,
    SUM(Sales) OVER(PARTITION BY OrderStatus) AS TotalSalesByStatus
FROM Sales.Orders
ORDER BY SUM(Sales) OVER(PARTITION BY OrderStatus) DESC; -- ✅ Allowed in ORDER BY

--  NOT ALLOWED: Using window functions in WHERE clause
-- This will cause an error
-- SELECT 
--     OrderID,
--     ProductID,
--     OrderDate,
--     OrderStatus,
--     Sales,
--     SUM(Sales) OVER(PARTITION BY OrderStatus) AS TotalSalesByStatus
-- FROM Sales.Orders
-- WHERE SUM(Sales) OVER(PARTITION BY OrderStatus) > 100; --  Invalid SQL


-- 2. WINDOW FUNCTIONS CANNOT BE USED FOR FILTERING DATA DIRECTLY
-- Correct Approach: Use CTE (Common Table Expression) or Subquery
WITH RankedSales AS (
    SELECT 
        OrderID,
        ProductID,
        Sales,
        SUM(Sales) OVER(PARTITION BY OrderStatus) AS TotalSalesByStatus
    FROM Sales.Orders
)
SELECT * FROM RankedSales WHERE TotalSalesByStatus > 100; -- Allowed

-- 3. NESTING SELECT WINDOW FUNCTIONS NOT ALLOWED
-- SQL executes window functions AFTER WHERE condition

--  This will cause an error
-- SELECT 
--     OrderID,
--     ProductID,
--     OrderDate,
--     OrderStatus,
--     Sales,
--     SUM(Sales) OVER(PARTITION BY OrderStatus) AS TotalSalesByStatus
-- FROM Sales.Orders
-- WHERE ProductID IN (101,102) AND SUM(Sales) OVER(PARTITION BY OrderStatus) > 500; --  Invalid SQL

--  Correct Approach: Use CTE (Common Table Expression)
WITH ProductSales AS (
    SELECT 
        OrderID,
        ProductID,
        Sales,
        SUM(Sales) OVER(PARTITION BY OrderStatus) AS TotalSalesByStatus
    FROM Sales.Orders
)
SELECT * FROM ProductSales WHERE ProductID IN (101, 102); --  Allowed

-- 4. WINDOW FUNCTIONS CAN BE USED WITH GROUP BY ONLY IF SAME COLUMNS ARE USED
--  Correct Example
SELECT 
    CustomerID, 
    SUM(Sales) AS TotalSales,
    RANK() OVER(ORDER BY SUM(Sales) DESC) AS CustomerRank
FROM Sales.Orders
GROUP BY CustomerID; -- Allowed because SUM(Sales) is grouped by CustomerID

-- 5. RANK CUSTOMERS BASED ON TOTAL SALES
SELECT 
    CustomerID, 
    SUM(Sales) AS TotalSales,
    RANK() OVER(ORDER BY SUM(Sales) DESC) AS Rank,
    DENSE_RANK() OVER(ORDER BY SUM(Sales) DESC) AS DenseRank,
    ROW_NUMBER() OVER(ORDER BY SUM(Sales) DESC) AS RowNumber
FROM Sales.Orders
GROUP BY CustomerID; -- Ranking Customers based on Total Sales

-- EXPLANATION OF RANKING FUNCTIONS:
-- 1. RANK() - Assigns rank but SKIPS ranks when there are ties.
-- 2. DENSE_RANK() - Assigns consecutive ranks without skipping numbers.
-- 3. ROW_NUMBER() - Assigns a unique row number to each row.

