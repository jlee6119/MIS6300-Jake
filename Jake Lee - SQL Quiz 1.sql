/* *********************
Jake Lee
MIS6300
SQL Quiz 1
***********************/

use AdventureWorks2012;

/*a.	Show First name and last name of employees whose job title is ¡°Sales Representative¡±, ranking from oldest to youngest. You may use HumanResources.Employee table and Person.Person table. (14 rows)*/

SELECT p.FirstName AS 'First Name'
		,p.LastName AS 'Last Name'
		,e.BirthDate AS 'Birth Date'

FROM HumanResources.Employee AS e
		,Person.Person AS p

WHERE e.JobTitle = 'Sales Representative'
		AND e.BusinessEntityID = p.BusinessEntityID

ORDER BY e.BirthDate


/*b.	Find out all the products which sold more than $5000 in total. Show product ID and name and total amount collected after selling the products. You may use LineTotal from Sales.SalesOrderDetail table and Production.Product table. (254 rows)*/

SELECT p.ProductID AS 'Product ID'
		,p.Name AS 'Product Name'
		,sum(s.LineTotal) AS 'Total Amount'

FROM Sales.SalesOrderDetail AS s
		,Production.Product AS p

WHERE  s.ProductID = p.ProductID

GROUP BY p.ProductId
		,p.Name

HAVING sum(s.LineTotal) > 5000


/*c.	Show BusinessEntityID, territory name and SalesYTD of all sales persons whose SalesYTD is greater than $500,000, regardless of whether they are assigned a territory. You may use Sales.SalesPerson table and Sales.SalesTerritory table. (16 rows)*/

SELECT s.BusinessEntityID
		,s.SalesYTD AS 'Sales Year-to-Date'
		,t.Name AS 'Territory Name'

FROM Sales.SalesPerson AS  s
		LEFT JOIN Sales.SalesTerritory AS t

		on s.TerritoryID =  t.TerritoryID

WHERE s.SalesYTD > 500000


/*d.	Show the sales order ID of those orders in the year 2008 of which the total due is great than the average total due of all the orders of the same year. (3200 rows)*/

SELECT SalesOrderID AS 'Sales Order ID'
		,TotalDue AS 'Total Due'
		,convert(Date, OrderDate) AS 'Order Date'
		,year(OrderDate) AS 'Order Year'
		,(SELECT avg(TotalDue) FROM Sales.SalesOrderHeader WHERE year(OrderDate) = 2008) AS '2008 Average Total Due'

FROM Sales.SalesOrderHeader

WHERE year(OrderDate) = 2008
		AND TotalDue > (SELECT avg(TotalDue) FROM Sales.SalesOrderHeader WHERE year(OrderDate) = 2008)