/* *********************
Jake Lee
MIS6300
SQL Exercise 3
***********************/

use AdventureWorksDW2012;

/*1, Display number of orders and total sales amount(sum of SalesAmount) of Internet Sales in 1st quarter each year in each country. Note: your result set should produce a total of 18 rows. */

SELECT count(s.SalesOrderNumber) AS 'Number of Orders'
		,sum(s.SalesAmount) AS 'Total Sales Amount'
		,d.CalendarYear AS 'Order Year'
		,g.EnglishCountryRegionName AS 'Country'

FROM dbo.DimDate AS d
		,dbo.FactInternetSales AS s
		,dbo.DimCustomer AS c
		,dbo.DimGeography AS g

WHERE d.CalendarQuarter = 1 AND d.DateKey = s.OrderDateKey AND s.CustomerKey = c.CustomerKey AND c.GeographyKey = g.GeographyKey

GROUP BY d.CalendarYear, g.EnglishCountryRegionName
ORDER BY d.CalendarYear, g.EnglishCountryRegionName;


/*2, Show total reseller sales amount (sum of SalesAmount), calendar quarter of order date, product category name and reseller’s business type by quarter by category and by business type in 2006. Note: your result set should produce a total of 44 rows. */

SELECT sum(rs.SalesAmount) AS 'Total Reseller Sales Amount'
		,d.CalendarQuarter
		,pc.EnglishProductCategoryName AS 'Category Name'
		,r.BusinessType AS 'Reseller Business Type'

FROM dbo.FactResellerSales AS rs
		,dbo.DimDate AS d
		,dbo.DimProduct AS p
		,dbo.DimProductCategory AS pc
		,dbo.DimProductSubcategory AS psc
		,dbo.DimReseller AS r

WHERE rs.OrderDateKey = d.DateKey
		AND d.CalendarYear = 2006
		AND rs.ProductKey = p.ProductKey
		AND p.ProductSubcategoryKey = psc.ProductSubcategoryKey
		AND psc.ProductCategoryKey = pc.ProductCategoryKey
		AND rs.ResellerKey = r.ResellerKey

GROUP BY d.CalendarQuarter,pc.EnglishProductCategoryName,r.BusinessType
ORDER BY d.CalendarQuarter,pc.EnglishProductCategoryName,r.BusinessType;


/*3, Based on 2, perform an OLAP operation: slice. In comment, describe how you perform the slicing, i.e. what do you do to what dimension(s)? Why is it a operation of slicing?*/

SELECT sum(rs.SalesAmount) AS 'Total Reseller Sales Amount'
		,d.CalendarQuarter
		,pc.EnglishProductCategoryName AS 'Category Name'
		,r.BusinessType AS 'Reseller Business Type'

FROM dbo.FactResellerSales AS rs
		,dbo.DimDate AS d
		,dbo.DimProduct AS p
		,dbo.DimProductCategory AS pc
		,dbo.DimProductSubcategory AS psc
		,dbo.DimReseller AS r

WHERE rs.OrderDateKey = d.DateKey
		AND d.CalendarYear = 2006
		AND rs.ProductKey = p.ProductKey
		AND p.ProductSubcategoryKey = psc.ProductSubcategoryKey
		AND psc.ProductCategoryKey = pc.ProductCategoryKey
		AND rs.ResellerKey = r.ResellerKey
		AND pc.EnglishProductCategoryName =  'Bikes' /** I am slicing the dataset to Product Category dimension. This is a slice operation because I am retrieving an array of data that corresponds a single value of the dimension. I could probably get rid of the Category Name coulmn as I am selecting a certain  product category.  Some other slicing operations I could perform are: by a specific quarter of the year or by a specific reseller type. Question: if I add the condition where Total Reseller Value is >= 100,000, is it still a slice operation?   **/

GROUP BY d.CalendarQuarter,pc.EnglishProductCategoryName,r.BusinessType
ORDER BY d.CalendarQuarter,pc.EnglishProductCategoryName,r.BusinessType;


/*4, Based on 2, perform an OLAP operation: drill-down. In comment, describe how you perform the drill-down, i.e. what do you do to what dimension(s)? Why is it a operation of drilling-down?*/

SELECT sum(rs.SalesAmount) AS 'Total Reseller Sales Amount'
		,d.CalendarQuarter
		,d.MonthNumberOfYear
		,d.EnglishMonthName AS 'Month'	/** I am drilling-down on the time dimension - from quarter to months. This is a drill down operation because I'm expanding the dataset that corresponds to more specific values of the dimention. I could probably perform other drilling-down operations, such as:  Product, which would require me to add Product cube, or Reseller Region, which would require me to add Geography cube. **/
		,pc.EnglishProductCategoryName AS 'Category Name'
		,r.BusinessType AS 'Reseller Business Type'

FROM dbo.FactResellerSales AS rs
		,dbo.DimDate AS d
		,dbo.DimProduct AS p
		,dbo.DimProductCategory AS pc
		,dbo.DimProductSubcategory AS psc
		,dbo.DimReseller AS r

WHERE rs.OrderDateKey = d.DateKey
		AND d.CalendarYear = 2006
		AND rs.ProductKey = p.ProductKey
		AND p.ProductSubcategoryKey = psc.ProductSubcategoryKey
		AND psc.ProductCategoryKey = pc.ProductCategoryKey
		AND rs.ResellerKey = r.ResellerKey

GROUP BY d.CalendarQuarter,d.MonthNumberOfYear,d.EnglishMonthName,pc.EnglishProductCategoryName,r.BusinessType
ORDER BY  d.CalendarQuarter,d.MonthNumberOfYear,pc.EnglishProductCategoryName,r.BusinessType;
