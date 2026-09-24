/*****************************************************************************************************************
NAME:    EC_IT143_W3.4_ed
PURPOSE: Answer eight AdventureWork question using SQL.

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     09/18/2026   ED            Created W3.4 AdventureWork answer script.


RUNTIME: 
30 mins

NOTES:
This script answers eight question using the AdventureWorks2022
database. Question and original author are documented below.
 
******************************************************************************************************************/

-- Q1: What is the list price of the most expensive product in AdventureWorks?
-- A1: Original Author:Godsend Clever Glory Boutoto
SELECT TOP 1
Name,
ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

--Q2: How many employees currently work for AdventureWorks?
--A2: Original Authour:Godsend Clever Glory Boutoto
SELECT COUNT(*) AS TotalEmployees
FROM HumanResources.Employee;

--Q3: Which sales territories generated the highest sales amounts?
-- How many sales orders did each territory receive?
--A3:Original Author:Daniel Asuquo
SELECT
    st.Name AS SalesTerritory,
    COUNT(soh.SalesOrderID) AS TotalOrders,
    SUM(soh.TotalDue) AS TotalSalesAmount
FROM Sales.SalesTerritory AS st
INNER JOIN Sales.SalesOrderHeader AS soh
    ON st.TerritoryID = soh.TerritoryID
GROUP BY
    st.Name
ORDER BY
    TotalSalesAmount DESC;
    
--Q4: Which customers placed the most sales orders?
--Can you show each customer's name and total number of orders?
--A4:Original Author: Daniel Asuquo
SELECT
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    COUNT(soh.SalesOrderID) AS TotalOrders
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader AS soh
    ON c.CustomerID = soh.CustomerID
GROUP BY
    p.BusinessEntityID,
    p.FirstName,
    p.LastName
ORDER BY
    TotalOrders DESC;
    
--Q5: Which product categories generated the most revenue during 2012?
--Show category name, total quantity sold, and total sales amount.
--A5: Original Author: Daniel Asuquo
SELECT
    pc.Name AS ProductCategory,
    SUM(sod.OrderQty) AS TotalQuantitySold,
    SUM(sod.LineTotal) AS TotalSalesAmount
FROM Sales.SalesOrderDetail AS sod
INNER JOIN Sales.SalesOrderHeader AS soh
    ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory AS psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE
    soh.OrderDate >= '20120101'
    AND soh.OrderDate < '20130101'
GROUP BY
    pc.Name
ORDER BY
    TotalSalesAmount DESC;
    
--Q6: Which customers generated the highest total sales during 2013?
--Include customer name, number of orders, total quantity purchased,
--and total sales amount.
--A6: Original Author: Daniel Asuquo
SELECT
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,
    SUM(sod.OrderQty) AS TotalQuantityPurchased,
    SUM(sod.LineTotal) AS TotalSalesAmount
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader AS soh
    ON c.CustomerID = soh.CustomerID
INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID
WHERE
    soh.OrderDate >= '20130101'
    AND soh.OrderDate < '20140101'
GROUP BY
    p.BusinessEntityID,
    p.FirstName,
    p.LastName
ORDER BY
    TotalSalesAmount DESC;
    
--Q7: What foreign key relationships connect the Person.Person,
--Person.EmailAddress, and Person.PersonPhone tables?
--A7: Original Author: Joshua Kadiri
SELECT
    fk.name AS ForeignKeyName,
    OBJECT_SCHEMA_NAME(fk.parent_object_id) AS ParentSchema,
    OBJECT_NAME(fk.parent_object_id) AS ParentTable,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id)
        AS ParentColumn,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id) AS ReferencedSchema,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id)
        AS ReferencedColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id
WHERE
    (
        OBJECT_SCHEMA_NAME(fk.parent_object_id) = 'Person'
        AND OBJECT_NAME(fk.parent_object_id) IN
            ('Person', 'EmailAddress', 'PersonPhone')
    )
    OR
    (
        OBJECT_SCHEMA_NAME(fk.referenced_object_id) = 'Person'
        AND OBJECT_NAME(fk.referenced_object_id) IN
            ('Person', 'EmailAddress', 'PersonPhone')
    )
ORDER BY
    ParentTable;
    
--Q8A: Is BusinessEntityID unique in Person.Person?
--Original Author: Joshua Kadiri
SELECT
    BusinessEntityID,
    COUNT(*) AS IDCount
FROM Person.Person
GROUP BY
    BusinessEntityID
HAVING
    COUNT(*) > 1;

SELECT GETDATE() AS my_date;