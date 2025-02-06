CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    UnitPrice DECIMAL(10, 2),
    Ingredients TEXT,
    Size VARCHAR(50),
    Weight DECIMAL(10, 2),
    Colors VARCHAR(255),
    Category VARCHAR(100),
    Supplier VARCHAR(100),
    Discontinued VARCHAR(3),
    Description TEXT
);	



INSERT INTO Product (ProductID, ProductName, UnitPrice, Ingredients, Size, Weight, Colors, Category, Supplier, Discontinued, Description) VALUES
(11, 'Handmade Eco Soap', 150.00, 'Natural oils, Salt, Pepper', 'Small', 350, 'Green, Yellow', 'Personal Care', 'Supplier4', 'No', 'Handmade eco-friendly soap with salt and pepper for exfoliation.'),
(12, 'Eco-Friendly Mug', 10.00, 'Ceramic, Salt, Pepper', 'Medium', 800, 'Red, Blue', 'Home Goods', 'Supplier5', 'No', 'Handmade eco-friendly mug made of ceramic with salt and pepper infused patterns.'),
(13, 'Pepper Salt Mix', 500.00, 'Salt, Pepper', 'Large', 900, 'Green, Red, Blue', 'Seasonings', 'Supplier6', 'YES', 'Pepper and salt mix for seasoning, eco-friendly packaging.'),
(14, 'Organic Honey', 250.00, 'Honey, Salt', 'Small', 200, 'Yellow', 'Food', 'Supplier1', 'No', 'Organic honey with a hint of salt.'),
(15, 'Chili Sauce', 120.00, 'Chili, Salt', 'Medium', 850, 'Red', 'Condiments', 'Supplier3', 'No', 'Spicy chili sauce with salt.'),
(16, 'Fruit Jam', 80.00, 'Fruit, Sugar', 'Large', 350, 'Red, Yellow', 'Food', 'Supplier2', 'YES', 'Natural fruit jam made with sugar.'),
(17, 'Spicy Mustard', 700.00, 'Mustard, Chili', 'Small', 150, 'Yellow', 'Condiments', 'Supplier1', 'No', 'Spicy mustard with a hint of chili.'),
(18, 'Garlic Paste', 60.00, 'Garlic, Salt', 'Medium', 700, 'White', 'Condiments', 'Supplier4', 'YES', 'Garlic paste with a salty taste.'),
(19, 'Cinnamon Powder', 100.00, 'Cinnamon', 'Large', 400, 'Brown', 'Spices', 'Supplier5', 'No', 'Organic cinnamon powder.'),
(20, 'Olive Oil', 150.00, 'Olive, Salt', 'Medium', 500, 'Green', 'Oils', 'Supplier6', 'YES', 'Organic olive oil with a touch of salt.');


SELECT * FROM Product
--DROP TABLE Product

--1. Select all products with a unit price greater than 100 and discontinued products. 
SELECT *
FROM Product
WHERE UnitPrice > 100 AND Discontinued='YES'


--2. Find products with 'sugar' as an ingredient or weight less than 500g. 
SELECT *
FROM Product
WHERE Ingredients LIKE '%Sugar%' AND Weight<500;


--3. Retrieve products with size 'Medium' and in the category 'Beverages'. #####
SELECT * 
FROM Product
WHERE Size='Medium' AND Category='Beverages';


--4. Select all products from 'Supplier1' but not discontinued. 
SELECT *
FROM Product
WHERE Supplier='Supplier1' AND Discontinued='No'


--5. Find products with multiple colors including 'Red' and 'Blue'. 
SELECT * 
FROM Product
WHERE Colors LIKE '%Red%'
AND Colors LIKE '%Blue%';


--6. Select products where the description contains 'organic' and the unit price is between 50 and 150. 
SELECT * 
FROM Product
WHERE CHARINDEX('organic', Description) > 0
AND UnitPrice BETWEEN 50 AND 150;


SELECT * 
FROM Product
WHERE Description LIKE '%organic%'
AND UnitPrice BETWEEN 50 AND 150;


--7. Retrieve products where the size is either 'Small' or 'Large' and weight is not null. 
SELECT * 
FROM Product
WHERE Weight IS NOT NULL
AND Size='Small' OR Size='Large'


--8. Select products with a specific ID range and supplier 'Supplier2'. 
SELECT * 
FROM Product
WHERE ProductID BETWEEN 16 AND 20
AND Supplier='Supplier2'


--9. Find products with discontinued status 'No' and ingredients excluding 'gluten'. 
SELECT * 
FROM Product
WHERE Discontinued='No'
AND CHARINDEX('gluten',ingredients) < 0


SELECT * 
FROM Product
WHERE Discontinued = 'No'
AND Ingredients NOT LIKE '%gluten%';


--10. Retrieve top 10 most expensive products. 
SELECT * 
FROM Product
ORDER BY UnitPrice DESC;


--11. Select products grouped by category and count the number of products in each category. 
SELECT category,COUNT(*) AS NoOFProduct
FROM Product
GROUP BY Category


--12. Find products with size 'Large' and either 'Supplier1' or 'Supplier3'. 
SELECT *
FROM Product
WHERE Size = 'Large'
AND Supplier IN('Supplier1','Supplier3')


SELECT * 
FROM Product
WHERE Size = 'Large'
AND (Supplier = 'Supplier1' OR Supplier = 'Supplier3');


--13. Select products where weight is either less than 250g or greater than 1000g. 
SELECT * 
FROM Product
WHERE Weight < 250 OR Weight > 1000;


--14. Retrieve products with colors containing 'Green' but not discontinued. 
SELECT * 
FROM Product
WHERE Colors LIKE '%Green%'
AND Discontinued = 'No';


--15. Select products where the description has both 'handmade' and 'eco-friendly'. 
SELECT * 
FROM Product
WHERE Description LIKE '%handmade%'
AND Description LIKE '%eco-friendly%';


--16. Find products with a unit price less than 20 and weight more than 300g. 
SELECT * 
FROM Product
WHERE UnitPrice < 20
AND Weight > 300;



--17. Select products with unit price not between 50 and 150. 
SELECT * 
FROM Product
WHERE UnitPrice NOT BETWEEN 50 AND 150;


--18. Select products with ingredients containing both 'salt' and 'pepper'. 
SELECT * 
FROM Product
WHERE Ingredients LIKE '%Salt%'
AND Ingredients LIKE '%Pepper%';


--19. Find products with unit price in top 5% and supplier 'Supplier2'. 
WITH RankedProducts AS (
    SELECT ProductID, ProductName, UnitPrice, Supplier,
           NTILE(100) OVER (ORDER BY UnitPrice DESC) AS PercentileRank
    FROM Product
)
SELECT *
FROM RankedProducts
WHERE PercentileRank <= 5
AND Supplier = 'Supplier2';




--20. Retrieve products with weight less than 500g and not 'Supplier3' & arrange it with Product Name in descending order 
SELECT * 
FROM Product
WHERE Weight < 500 
AND Supplier<>'Supplier3'
ORDER BY ProductName DESC;


--21. Select products supplied by multiple suppliers and not discontinued. 
SELECT ProductID, ProductName, Supplier
FROM Product
WHERE Discontinued = 'No'
GROUP BY ProductID, ProductName, Supplier
HAVING COUNT(DISTINCT Supplier) > 1;


--22. Select products with unique ingredients across the database.   #####
SELECT ProductID, ProductName, Ingredients
FROM Product
GROUP BY Ingredients
HAVING COUNT(Ingredients) = 1;


--23. Retrieve products where the size is 'Large' and ingredient list is extensive. 
--24. Select products by suppliers with an average unit price below a threshold 50. 
DECLARE @threshold INT;
SET @threshold = 50;

SELECT ProductID, ProductName, Supplier, UnitPrice
FROM Product
WHERE Supplier IN (
    SELECT Supplier
    FROM Product
    GROUP BY Supplier
    HAVING AVG(UnitPrice) < @threshold
);


--25. Retrieve products grouped by category with the highest average unit price per supplier.
--SELECT Category, DISTINCT Supplier , AVG(UnitPrice) AS AvgUnitPrice
--FROM Product
--GROUP BY Category, Supplier
--ORDER BY AvgUnitPrice DESC;

--26. Select products where the unit price and weight both exceed average values. 
SELECT *
FROM Product
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Product)
AND Weight > (SELECT AVG(Weight) FROM Product)


--27. Find products with multiple sizes and unique colors. 
SELECT DISTINCT(Colors), ProductName,Size
FROM Product 

--28. Creates a ProductBackUp table of the entire Product table. 
SELECT * 
INTO ProductBackUp
FROM Product;


--29. Copies ProductID, ProductName, and Description into a new table called ProductDetails.  
SELECT ProductID, ProductName, Description
INTO ProductDetails
FROM Product;


--30. Creates a new table with PRD_Product having Unit Price Less than 500. 
SELECT * 
INTO PRD_Product
FROM Product
WHERE UnitPrice < 500;


--31. Creates a table ActiveProducts with non-discontinued products.
SELECT * 
INTO ActiveProducts
FROM Product
WHERE Discontinued = 'No';


--32. Creates a table with products of size 'Large'. 
SELECT * 
INTO LargeProducts
FROM Product
WHERE Size = 'Large';


--33. Creates a table with products whose description contains 'organic'. 
SELECT * INTO OrganicProducts
FROM Product
WHERE Description LIKE '%organic%';


--34. Copies products with colors containing 'Red' into a new table. 
SELECT * INTO RedColorProducts
FROM Product
WHERE Colors LIKE '%Red%';


--35. Copies specific columns of products in the 'Beverages' and 'Snacks' categories into a new table. 
SELECT ProductID, ProductName, UnitPrice, Category, Supplier
INTO BeveragesAndSnacksProducts
FROM Product
WHERE Category IN ('Beverages', 'Snacks');


--36. Find categories with an average unit price greater than 50 and order by average unit price. 
SELECT Category, AVG(UnitPrice) AS AvgUnitPrice
FROM Product
GROUP BY Category
HAVING AVG(UnitPrice) > 50
ORDER BY AvgUnitPrice;


--37. Retrieves categories with an average unit price greater than 50, ordered by the average price descending.
SELECT Category, AVG(UnitPrice) AS AvgUnitPrice
FROM Product
GROUP BY Category
HAVING AVG(UnitPrice) > 50
ORDER BY AvgUnitPrice DESC;


--38. Finds suppliers with total product weight over 1000, ordered by total weight descending. 
SELECT Supplier, SUM(Weight) AS total_weight
FROM Product
GROUP BY Supplier
HAVING  SUM(Weight)>1000
ORDER BY total_weight


--39. Identifies categories with maximum unit price greater than 150, ordered by maximum price descending.
SELECT Category,SUM(UnitPrice) AS Price
FROM Product
GROUP BY Category
HAVING SUM(UnitPrice)>150
ORDER BY Price


--40. Lists suppliers with more than 10 products, ordered by product count descending. 
SELECT Supplier, COUNT(ProductID) AS ProductCount
FROM Product
GROUP BY Supplier
HAVING COUNT(ProductID) > 10
ORDER BY ProductCount DESC;


--41. Retrieves categories with an average product weight greater than 200, ordered by average weight descending.
SELECT Category,AVG(Weight) AS AvgP
FROM Product
GROUP BY Category
HAVING AVG(WEIGHT)>200
ORDER BY AvgP DESC;


--42. Finds suppliers with total unit price over 500, ordered by total price descending. 
SELECT Supplier, SUM(UnitPrice) AS TotalPrice
FROM Product
GROUP BY Supplier
HAVING SUM(UnitPrice) > 500
ORDER BY TotalPrice DESC;


--43. Identifies categories with minimum unit price less than 20, ordered by minimum price ascending. 
SELECT Category, MIN(UnitPrice) AS MinUnitPrice
FROM Product
GROUP BY Category
HAVING MIN(UnitPrice) < 20
ORDER BY MinUnitPrice ASC;


--44. Lists categories with more than 5 products, ordered by product count descending. 
SELECT Category, COUNT(ProductID) AS ProductCount
FROM Product
GROUP BY Category
HAVING COUNT(ProductID) > 5
ORDER BY ProductCount DESC;


--45. Finds categories with total weight over 1000, ordered by total weight descending. 
SELECT Category, SUM(Weight) AS TotalWeight
FROM Product
GROUP BY Category
HAVING SUM(Weight) > 1000
ORDER BY TotalWeight DESC;


--46. Lists categories with more than 20 products, ordered by total products descending. 
SELECT Category, COUNT(ProductID) AS ProductCount
FROM Product
GROUP BY Category
HAVING COUNT(ProductID) > 20
ORDER BY ProductCount DESC;


--47. Finds suppliers with total weight over 500, ordered by total weight descending. 
SELECT Supplier, SUM(Weight) AS TotalWeight
FROM Product
GROUP BY Supplier
HAVING SUM(Weight) > 500
ORDER BY TotalWeight DESC;


--48. Calculates the total revenue for each product by multiplying the unit price by the quantity. 
SELECT ProductID, ProductName, UnitPrice, (UnitPrice * 5) AS TotalRevenue
FROM Product;

--49. Calculates the discounted price for each product with a 10% discount. 
SELECT ProductID, ProductName, UnitPrice, (UnitPrice * 0.9) AS DiscountedPrice
FROM Product;

--50. Calculates the weight difference from the average weight for each product. 
SELECT ProductID, ProductName, Weight, 
       (Weight - (SELECT AVG(Weight) FROM Product)) AS WeightDifference
FROM Product;


--51. Counts the total number of products in each category. 
SELECT Category,COUNT(ProductName) AS Pcount
FROM Product
GROUP BY Category


--52. Calculates the total revenue for each category by summing the product of unit price and quantity. 

--53. Calculates the price increase by 5% for each product. 
SELECT ProductName, UnitPrice,UnitPrice*1.05 AS Inc_Price
FROM Product


--54. Finds the maximum, minimum, and average unit price for each supplier. 
SELECT Supplier, 
       MAX(UnitPrice) AS MaxUnitPrice,
       MIN(UnitPrice) AS MinUnitPrice,
       AVG(UnitPrice) AS AvgUnitPrice
FROM Product
GROUP BY Supplier;


--55. Calculates total number of products and average unit price for each category.
SELECT Category, 
       COUNT(ProductID) AS TotalProducts,
       AVG(UnitPrice) AS AvgUnitPrice
FROM Product
GROUP BY Category;