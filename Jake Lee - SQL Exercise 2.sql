/* *********************
Jake Lee
MIS6300
SQL Exercise 2
***********************/


USE AdventureWorks2012; /*Set current database*/

/*1. Display the total amount collected from the orders for each order date. */

SELECT OrderDate
		,sum(SubTotal) AS 'Total Sub  Total'
		,sum(TaxAmt) AS 'Total Tax Amount'
		,sum(Freight) AS 'Total Freight'
		,sum(TotalDue) AS 'Total Amount Due'

FROM Sales.SalesOrderHeader

GROUP BY OrderDate
ORDER BY OrderDate


/*2. Display the total amount collected after selling the products, 774 and 777. */

SELECT d.ProductID
		,sum(d.OrderQty) AS 'Total Order Qty'
		,sum(d.LineTotal) AS 'Total Amount'

FROM Sales.SalesOrderHeader AS h
		,Sales.SalesOrderDetail AS d

WHERE h.SalesOrderId = d.SalesOrderID AND d.ProductID in(774, 777)

GROUP BY d.ProductID


/*3. Write a query to display the sales person ID of all the sales persons and the name of the territory to which they belong.*/

SELECT s.BusinessEntityID AS 'Sales Person ID'
		,t.Name AS 'Territory'
		,p.LastName
		,p.FirstName
		,e.JobTitle

FROM Sales.SalesPerson AS s 
		LEFT JOIN Sales.SalesTerritory AS t  /** Use LEFT JOIN specifically to include sales managers who are not assigned to territoreis **/
		on s.TerritoryID = t.TerritoryID
		JOIN Person.Person AS p
		on s.BusinessEntityID = p.BusinessEntityID
		JOIN HumanResources.Employee AS e
		on p.BusinessEntityID =  e.BusinessEntityID


/*4. Write a query to display the Business Entities of the customers that have the 'Vista' credit card.*/

SELECT pc.BusinessEntityID
		,p.FirstName
		,p.LastName
		,cc.CardType

FROM Sales.PersonCreditCard AS pc
		,Sales.CreditCard AS cc
		,Person.Person AS p

WHERE cc.CardType LIKE 'Vista' AND  pc.CreditCardId = cc.CreditCardID AND p.BusinessEntityID = pc.BusinessEntityID


/*5, Write a query to display all the country region codes along with their corresponding territory IDs*/

SELECT t.TerritoryID
		,c.CountryRegionCode
		,c.Name

FROM Sales.SalesTerritory AS t
		RIGHT JOIN Person.CountryRegion AS c
		ON t.CountryRegionCode = c.CountryRegionCode


/*6. Find out the average of the total dues of all the orders.*/

SELECT avg(TotalDue) AS 'Average of the Total Dues of All Orders'

FROM Sales.SalesOrderHeader


/*7. Write a query to report the sales order ID of those orders where the total value is greater than the average of the total value of all the orders.*/

SELECT SalesOrderID
		,TotalDue

FROM Sales.SalesOrderHeader

WHERE TotalDue > (SELECT avg(TotalDue) FROM Sales.SalesOrderHeader)