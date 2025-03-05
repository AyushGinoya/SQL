--Common Table Expression (CTE) in SQL
--A Common Table Expression (CTE) is a temporary, named result set (virtual table) that is defined within
--the execution scope of a single SQL statement. CTEs improve query readability, maintainability, and performance
--in complex SQL operations.



--Why Use CTEs?
--CTEs provide several advantages over traditional subqueries and derived tables:

--Readability – Break down Complex query in smaller parts. They make complex queries easier to read and understand by breaking them into logical steps.
--Modularity – pieces are easy to manage,delovpe. Queries are easier to structure and debug by breaking them into smaller components.
--Reusability – A CTE can be referenced multiple times within a query, eliminating redundant computations.
--Recursion Support – CTEs allow recursive queries, which are useful for hierarchical or tree-structured data.
--Performance Optimization – In some cases, CTEs can improve query execution plans by allowing SQL engines to optimize better than deeply nested subqueries.


--CTE vs. Subquery


--|   Feature   |							CTE							|						Subquery					|
--|-------------|-------------------------------------------------------|---------------------------------------------------|
--| Definition  | Declared using `WITH` keyword							| Used inside `SELECT`, `FROM`, or `WHERE` clause	|
--| Reusability | Can be referenced multiple times						| Cannot be reused (must be repeated)				|
--| Readability | Improves readability by breaking logic into sections  | Becomes harder to read in complex queries			|
--| Recursion   | Supports recursion (recursive CTEs)					| Does not support recursion						|
--| Performance | Can sometimes optimize execution plans better			| May result in redundant computation				|

--When to Use CTEs?
--- When breaking a complex query into smaller logical parts.
--- When a temporary result set needs to be reused multiple times in the same query.
--- When working with recursive data, such as organizational charts or folder structures.
--- When improving query readability and maintainability


--=====================================================
--=======================TYPES=========================
--=====================================================





--1) Standalone CTE D

--Defined and Used independently.
--Runs independently as it's self-contained and doesn't rely on other CTEs or queries.


-- DB------>CTE-------->Intermediat Result---------->Main Query-------->Final Result
-----------------------------------          ---------------------------------
--         independent                                Depedependent



--This retrieves a list of customers along with their total sales amount.
WITH CTE_Total_Sales AS
(
	SELECT 
		o.CustomerID,
		SUM(o.Sales) AS TOTALSALE
	FROM Sales.Orders o
	GROUP BY o.CustomerID
)
SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	TOTALSALE
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales
ON c.CustomerID = CTE_Total_Sales.CustomerID

--You can not directly use order by within the CTE but you cand do in main query




--2)Multiple CTE
--
--		|---------------->CTE-1---------------|
--		|---------------->CTE-2---------------|
--		DB--------------->CTE-3-----------Main Query(Use all CTE)----------->Final Result
--		|---------------->CTE-4---------------|
--		|---------------->CTE-5---------------|




--This retrieves a list of customers along with their total sales amount and last order date.
WITH CTE_Total_Sales AS
(
	SELECT 
		o.CustomerID,
		SUM(o.Sales) AS TOTALSALE
	FROM Sales.Orders o
	GROUP BY o.CustomerID
),
CTE_Last_Order AS
(
	SELECT 
		o.CustomerID,
		MAX(o.OrderDate) AS Last_Order
	FROM Sales.Orders o
	GROUP BY o.CustomerID
)
SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	TOTALSALE,
	Last_Order
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales
ON c.CustomerID = CTE_Total_Sales.CustomerID
LEFT JOIN CTE_Last_Order
ON CTE_Last_Order.CustomerID = c.CustomerID






--3)Nested CTE

--CTE inside another CТЕ
--A nested CTE uses the result of another CTE, so it can't run independently


-- DB------>CTE-1-------->Intermediat Result------>CTE-2-------->Intermediat Result---------->Main Query-------->Final Result



--This retrieves a list of customers along with total sales and their rank based on sales amount.
WITH CTE_Total_Sales AS
(
	SELECT 
		o.CustomerID,
		SUM(o.Sales) AS TOTALSALE
	FROM Sales.Orders o
	GROUP BY o.CustomerID
),
CTE_Customer_Rank AS
(
	SELECT
	CustomerID,
	TOTALSALE,
	RANK() OVER(ORDER BY TOTALSALE DESC) AS CustRank
	FROM CTE_Total_Sales
)

SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	CTE_Total_Sales.TOTALSALE,
	CustRank
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales
ON c.CustomerID = CTE_Total_Sales.CustomerID
LEFT JOIN CTE_Customer_Rank
ON c.CustomerID = CTE_Customer_Rank.CustomerID
ORDER BY CustRank







--This retrieves a list of customers with total sales, rank based on sales, and customer segmentation.
WITH CTE_Total_Sales AS
(
	SELECT 
		o.CustomerID,
		SUM(o.Sales) AS TOTALSALE
	FROM Sales.Orders o
	GROUP BY o.CustomerID
),
CTE_Customer_Segment AS
(
	SELECT
	CustomerID,
	CASE 
    	WHEN TOTALSALE>100 THEN 'High'
    	WHEN TOTALSALE>80 THEN 'Medium'
    	ELSE 'Low'
    END CustomerSegment
	FROM CTE_Total_Sales
),
CTE_Customer_Rank AS
(
	SELECT
	CustomerID,
	TOTALSALE,
	RANK() OVER(ORDER BY TOTALSALE DESC) AS CustRank
	FROM CTE_Total_Sales
)

SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	CTE_Total_Sales.TOTALSALE,
	CustRank,
	CustomerSegment
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales
ON c.CustomerID = CTE_Total_Sales.CustomerID
LEFT JOIN CTE_Customer_Rank
ON c.CustomerID = CTE_Customer_Rank.CustomerID
LEFT JOIN CTE_Customer_Segment
ON c.CustomerID = CTE_Customer_Segment.CustomerID
ORDER BY CustRank




--DON'T USE MORE THE 5 CTE IN ONE QUERY
--B'COZ IT IS HARD TO UNDERSTAND AND MAINTAIN







--============================================
--==============4=Recursive CTE===============
--============================================



--This query prints numbers from 1 to 20 using recursion.
WITH CTE_NUM AS
(
	SELECT 1 AS MyNumber
	UNION ALL
	SELECT MyNumber+1 FROM CTE_NUM 
	WHERE MyNumber<20
)
SELECT * FROM CTE_NUM










--This retrieves a hierarchical employee structure, displaying each employee along with their level in the organization.
WITH CTE_Emp_Hirch AS
(
	SELECT 
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	1 AS Lavel
	FROM Sales.Employees e
	WHERE e.ManagerID IS NULL

	UNION ALL

	SELECT 
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	Lavel+1
	FROM Sales.Employees e
	INNER JOIN CTE_Emp_Hirch
	ON e.ManagerID = CTE_Emp_Hirch.EmployeeID
	 
)

SELECT * FROM CTE_Emp_Hirch