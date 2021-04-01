-- Section A
-- 1.What is a result set?
-- Result set is a set of data, could be empty or not, returned by a select statement, or a stored procedure, that is saved in RAM or displayed on the screen.
-- A TSQL script can have 0 to multiple result sets

-- 2.What is the difference between Union and Union All?
-- a. UNION removes duplicate records (where all columns in the results are the same), UNION ALL does not.
-- b. union can not be used with recursive CTE but union all can be used with recursive CTE
-- c. union will sort the resultset based on the first column of the first select statement but union all will not
-- d. union is slower than union all

-- 3.What are the other Set Operators SQL Server has?
-- Union, Union all, Intersect, Except 

-- 4.What is the difference between Union and Join?
-- a. Join combines data from many tables, Union combines the result-set of 2 or more SELECT statment
-- b. Join conbines data into new colums, Union combines data into new rows
-- c. For Join, number of colulmns selected from each table may not be same. For Union, it should be same with the same condition
-- d. For Join, datatypes of corresponding columns selected from each table can be different. For Union, it should be same with the same condition

-- 5.What is the difference between INNER JOIN and FULL JOIN?
-- Inner join returns only the matching rows between both tables, non-matching rows are eliminated
-- Full join returns all rows from both the tables, including non-matching rows from the both tables

-- 6.What is difference between left join and outer join
-- Left Outer Join Returns all the rows from the LEFT table and matching records between both the tables
-- Right Outer Join: Returns all the rows from the RIGHT table and matching records between both the tables
-- Full Outer Join: It combines the result of the Left Outer Join and Right Outer Join.

-- 7.What is cross join?
-- CROSS JOIN is used to generate a paired combination of each row of the first table with each row of the second table
-- This join type is also known as cartesian join.

-- 8.What is the difference between WHERE clause and HAVING clause?
-- The WHERE clause is used in the selection of rows according to given conditions whereas 
-- the HAVING clause is used in column operations and is applied to aggregated rows or groups

-- 9.Can there be multiple group by columns?
-- Yes, a group by clause can contain two or more columns and these columns will group in order




-- Section B
USE [AdventureWorks2017]
go
-- 1.How many products can you find in the Production.Product table?
select count(ProductID) as TotalNumber
from Production.Product

-- 2.Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. 
-- The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
select ProductSubcategoryID, count(ProductID) as TotalNumber
from Production.Product
where ProductSubcategoryID is not null 
group by ProductSubcategoryID

-- 3.How many Products reside in each SubCategory? Write a query to display the results with the following titles.
select ProductSubcategoryID, count(ProductID) as CountedProducts
from Production.Product
group by ProductSubcategoryID

-- 4.How many products that do not have a product subcategory
select ProductSubcategoryID, count(ProductID) as TotalNumber
from Production.Product
where ProductSubcategoryID is null 
group by ProductSubcategoryID

-- 5.Write a query to list the summary of products in the Production.ProductInventory table.
select ProductID, sum(Quantity) as Thesum
from Production.ProductInventory 
group by ProductID

-- 6.Write a query to list the summary of products in the Production.
-- ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
select ProductID, sum(Quantity) as Thesum
from Production.ProductInventory 
where LocationID = 40 
group by ProductID
Having sum(Quantity) <100


-- 7.Write a query to list the summary of products with the shelf information in the Production.
-- ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
select shelf, ProductID, sum(Quantity) as Thesum
from Production.ProductInventory 
where LocationID = 40 
group by shelf, ProductID
Having sum(Quantity) <100

-- 8.Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
select LocationID, avg(quantity) as TheAvg
from Production.ProductInventory 
where LocationID = 10
group by LocationID

-- 9.Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
select ProductID, shelf, avg(quantity) as TheAvg
from Production.ProductInventory 
group by ProductID, shelf

-- 10.Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
select ProductID, shelf, avg(quantity) as TheAvg
from Production.ProductInventory 
where Shelf not like 'N/A'
group by ProductID, shelf

-- 11.List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
select Color, Class, count(*) as TheCount, avg(ListPrice) as AvgPrice
from Production.Product
where Color is not null and Class is not null 
group by Color, Class

-- 12.Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following. 
select c.Name as Country, s.Name as Province
from person.CountryRegion as c inner join person.StateProvince as s
on c.CountryRegionCode = s.CountryRegionCode

-- 13.Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
select c.Name as Country, s.Name as Province
from person.CountryRegion as c inner join person.StateProvince as s
on c.CountryRegionCode = s.CountryRegionCode
where c.Name = 'Germany' or c.Name = 'Canada'

USE [Northwind]
go
-- 14.List all Products that has been sold at least once in last 25 years.
select distinct p.ProductName
from Orders as o 
inner join [Order Details] as od
on o.OrderID = od.OrderID
inner join Products as p
on od.ProductID = p.ProductID
where Year(o.OrderDate) > 1995
order by 1

-- 15.List top 5 locations (Zip Code) where the products sold most.
select top 5 o.ShipPostalCode, count(o.ShipPostalCode) as cont
from Orders as o
inner join [Order Details] as od
on o.OrderID = od.OrderID
inner join Products as p
on od.ProductID = p.ProductID
group by o.ShipPostalCode
order by 2 desc 

-- 16.List top 5 locations (Zip Code) where the products sold most in last 20 years.
select o.ShipPostalCode, count(o.ShipPostalCode) as cont
from Orders as o
inner join [Order Details] as od
on o.OrderID = od.OrderID
inner join Products as p
on od.ProductID = p.ProductID
where Year(o.OrderDate) > 2000
group by o.ShipPostalCode
order by 2 desc
--For this question, the coloum 'orderdate' does not have any record after 1998. Thus it will return 0 record.

-- 17.List all city names and number of customers in that city.    
select ShipCity as city, count(distinct CustomerID) as CustomerNumber
from Orders
group by ShipCity

-- 18.List city names which have more than 10 customers, and number of customers in that city
select ShipCity as city, count(distinct CustomerID) as CustomerNumber
from Orders
group by ShipCity
having count(distinct CustomerID)>10
-- For this question, I cannot find any city which customer number is greater than 10

-- 19.List the names of customers who placed orders after 1/1/98 with order date.
select c.ContactName, o.OrderDate
from Orders o inner join Customers c on o.CustomerID = c.CustomerID
where o.OrderDate > '1998-01-01'

-- 20.List the names of all customers with most recent order dates 
select c.ContactName, o.OrderDate
from Orders o inner join Customers c on o.CustomerID = c.CustomerID
group by c.ContactName, o.OrderDate
Having count(o.OrderDate)= 1
order by o.OrderDate desc 

-- 21.Display the names of all customers  along with the  count of products they bought 
select c.ContactName, sum(od.Quantity) as Quant
from Orders o 
inner join Customers c on o.CustomerID = c.CustomerID
inner join [Order Details] as od on o.OrderID = od.OrderID
group by c.ContactName

-- 22.Display the customer ids who bought more than 100 Products with count of products.
select o.CustomerID, sum(od.Quantity) as Quant
from Orders o 
inner join Customers c on o.CustomerID = c.CustomerID
inner join [Order Details] as od on o.OrderID = od.OrderID
group by o.CustomerID
having sum(od.Quantity)>100
order by Quant desc

-- 23.List all of the possible ways that suppliers can ship their products. Display the results as below
select s.CompanyName as 'Supplier Company Name', sh.CompanyName as 'shipping Company Name'   
from Suppliers S 
inner join Products P on s.SupplierID = p.SupplierID
inner join [Order Details] od on od.ProductID = p.ProductID
inner join Orders O on o.OrderID = od.OrderID
inner join Shippers Sh on sh.ShipperID = o.ShipVia
group by s.CompanyName, sh.CompanyName

-- 24.Display the products order each day. Show Order date and Product Name.
Select o.OrderDate, p.ProductName 
from Products P 
inner join [Order Details] od on od.ProductID = p.ProductID
inner join Orders O on o.OrderID = od.OrderID
group by o.OrderDate,p.ProductName 

-- 25.Displays pairs of employees who have the same job title.
select e.Title, e.FirstName, e.LastName
from Employees as e
group by e.Title, e.FirstName, e.LastName

-- 26.Display all the Managers who have more than 2 employees reporting to them.
select m.EmployeeID, m.FirstName, m.LastName, count(*) as num_respond
from Employees e join Employees m on m.EmployeeID = e.ReportsTo
group by m.EmployeeID, m.FirstName, m.LastName
having count(*)>2

-- 27.Display the customers and suppliers by city. The results should have the following columns
select c.City as 'City Name', c.ContactName as 'Contact Name', 'Customer' as 'Type'
from Suppliers S 
inner join Products P on s.SupplierID = p.SupplierID
inner join [Order Details] od on od.ProductID = p.ProductID
inner join Orders O on o.OrderID = od.OrderID
inner join Customers C on c.CustomerID = o.CustomerID
group by c.City, c.ContactName
union all 
select c.City as 'City Name', s.ContactName as 'Contact Name','Supplier' as 'Type'
from Suppliers S 
inner join Products P on s.SupplierID = p.SupplierID
inner join [Order Details] od on od.ProductID = p.ProductID
inner join Orders O on o.OrderID = od.OrderID
inner join Customers C on c.CustomerID = o.CustomerID
group by c.City, s.ContactName

-- 28.Have two tables T1 and T2,Please write a query to inner join these two tables and write down the result of this query.
-- Creat Table T1 and T2
create table T1 (F1_T1 int)
insert into T1 values (1)
insert into T1 values (2)
insert into T1 values (3)

create table T2 (F2_T2 int)
insert into T2 values (2)
insert into T2 values (3)
insert into T2 values (4)
select * from T1
select * from T2

-- inner join two tables
select *
from T1 inner join T2 on T1.F1_T1 =T2.F2_T2 

-- 29.Based on above two table, Please write a query to left outer join these two tables and write down the result of this query.
-- Left join base on T1
select *
from T1 left join T2 on T1.F1_T1 =T2.F2_T2 
-- Left join base on T2
select *
from T2 left join T1 on T1.F1_T1 =T2.F2_T2 