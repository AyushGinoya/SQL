-- Select orders with sales rank using ROW_NUMBER
SELECT
	o.OrderID,
	o.ProductID,
	o.Sales,
	ROW_NUMBER() OVER(ORDER BY o.Sales DESC) AS RANK_BY_SALES
FROM Sales.Orders o


-------------------------------------RANK()
-- Assigns a rank to each row
-- Handles ties by giving the same rank to duplicate values
-- Leaves gaps in ranking when ties occur

SELECT
	o.OrderID,
	o.ProductID,
	o.Sales,
	ROW_NUMBER() OVER(ORDER BY o.Sales DESC) AS Row_BY_SALES,
	RANK() OVER(ORDER BY o.Sales DESC) AS RANK_BY_SALES
FROM Sales.Orders o


-------------------------------------DENSE_RANK()
-- Assigns a rank to each row
-- Handles ties by giving the same rank to duplicate values
-- Unlike RANK(), it does not leave gaps in ranking

SELECT
	o.OrderID,
	o.ProductID,
	o.Sales,
	ROW_NUMBER() OVER(ORDER BY o.Sales DESC) AS SALES_ROW,
	RANK() OVER(ORDER BY o.Sales DESC) AS SALES_RANK,
	DENSE_RANK() OVER(ORDER BY o.Sales DESC) AS SALES_DENSERANK
FROM Sales.Orders o


-- Rank sales within each product category
SELECT
	o.OrderID,
	o.ProductID,
	o.Sales,
	ROW_NUMBER() OVER(PARTITION BY o.ProductID ORDER BY o.Sales DESC) AS RankByProduct
FROM Sales.Orders o


-----------TOP-N QUERY (Second highest sales per product)
SELECT 
*
FROM (
SELECT
	o.OrderID,
	o.ProductID,
	o.Sales,
	ROW_NUMBER() OVER(PARTITION BY o.ProductID ORDER BY o.Sales DESC) AS RankByProduct
FROM Sales.Orders o
) T WHERE T.RankByProduct=2 -- Change to 1 for highest


-------------------BOTTOM-N QUERY (Customers with lowest sales)
SELECT * FROM(
SELECT
	o.CustomerID,
	SUM(o.Sales) AS sales,
	ROW_NUMBER() OVER(ORDER BY SUM(o.Sales)) AS RankCust
FROM Sales.Orders o
GROUP BY o.CustomerID
) AS t WHERE t.RankCust<=2  -- Select bottom 2 customers


-- Assigning unique ID to archived orders
SELECT
	ROW_NUMBER() OVER(ORDER BY oa.OrderID, oa.OrderDate) AS unique_id,
	*
FROM Sales.OrdersArchive oa


-- Identifying duplicate data using ROW_NUMBER()
-- If RN > 1, it means there are duplicates
SELECT * FROM (
SELECT
	ROW_NUMBER() OVER(PARTITION BY oa.OrderID ORDER BY oa.CreationTime DESC) AS RN,
	*
FROM Sales.OrdersArchive oa
) t WHERE t.RN>1  -- Retrieves duplicate records


-- NTILE Example (Divides sales into buckets)
-- NTILE(N) splits data into N equal parts
-- Larger groups come first if there are extra rows
SELECT
	o.OrderID,
	o.Sales,
	NTILE(1) OVER(ORDER BY o.Sales DESC) OneBucket,
	NTILE(2) OVER(ORDER BY o.Sales DESC) TwoBucket,
	NTILE(3) OVER(ORDER BY o.Sales DESC) ThreeBucket,
	NTILE(4) OVER(ORDER BY o.Sales DESC) FourBucket
FROM Sales.Orders o


-- SEGMENTATION: Categorizing sales into High, Medium, and Low
SELECT
*,
CASE
	WHEN T.BUCKET=1 THEN 'HIGH'
	WHEN T.BUCKET=2 THEN 'MEDIUM'
	WHEN T.BUCKET=3 THEN 'LOW'
END AS SALESDATA
FROM (
SELECT
	o.OrderID,
	o.Sales,
	NTILE(3) OVER(ORDER BY o.Sales DESC) AS BUCKET
FROM Sales.Orders o
) T 


---------------------CUME_DIST()
-- Cumulative distribution function
-- CUME_DIST = (Row Position) / (Total Rows)
-- Includes the current row when calculating percentile ranking
SELECT
	o.OrderID,
	o.Sales,
	CUME_DIST() OVER(ORDER BY o.Sales DESC) AS Per
FROM Sales.Orders o


---------------------PERCENT_RANK()
-- Similar to CUME_DIST but excludes the current row in ranking
-- PERCENT_RANK = (Row Position - 1) / (Total Rows - 1)
SELECT
	o.OrderID,
	o.Sales,
	CUME_DIST() OVER(ORDER BY o.Sales DESC) AS Per_CD,
	ROUND(PERCENT_RANK() OVER(ORDER BY o.Sales DESC),2)  AS Per_PR
FROM Sales.Orders o


-- Filtering products based on CUME_DIST() and PERCENT_RANK()
-- Retrieves top 40% of products based on price
SELECT 
	* 
FROM (
SELECT
	*,
	CUME_DIST() OVER(ORDER BY p.Price DESC) AS DISTRANK,
	PERCENT_RANK() OVER(ORDER BY p.Price DESC) AS PERRANK
FROM Sales.Products p
) T WHERE T.DISTRANK<=0.4
