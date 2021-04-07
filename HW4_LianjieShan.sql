--Section A
--What is View? What are the benefits of using views?
--A view is a virtual table whose contents are defined by a query. Like a real table, a view consists of a set of named columns and rows of data
--Benefits: 
--1.To Simplify Data Manipulation
--2.Views enable you to create a backward compatible interface for a table when its schema changes. 
--3.To Customize Data
--4.Distributed queries can also be used to define views that use data from multiple heterogeneous sources 
--5.If you want to combine similarly structured data from different servers, each of which stores data for a different region of your organization

--Can data be modified through views?
--Yes, a view can be modified by simply using the ALTER VIEW keyword instead, and then changing the structure of the SELECT statement.

--What is stored procedure and what are the benefits of using it?
--A stored procedure groups one or more Transact-SQL statements into a logical unit, stored as an object in a SQL Server database 
--Benefits:
--1.Increase database security 
--2.Faster execution
--3.Stored procedures help centralize your Transact-SQL code in the data tier.
--4.Stored procedures can help reduce network traffic for larger ad hoc queries
--5.Stored procedures encourage code reusability

--What is the difference between view and stored procedure?
--Unlike views, when a stored procedure is executed for the first time, 
--SQL determines the most optimal query access plan and stores it in the plan memory cache. SQL Server can then reuse the plan on subsequent executions of this stored procedure 

--What is the difference between stored procedure and functions?
--1.The function must return a value but in Stored Procedure it is optional. Even a procedure can return zero or n values.
--2.Functions can have only input parameters for it whereas Procedures can have input or output parameters.
--3.Functions can be called from Procedure whereas Procedures cannot be called from a Function.
--4.The procedure allows SELECT as well as DML(INSERT/UPDATE/DELETE) statement in it whereas Function allows only SELECT statement in it.
--5.Procedures cannot be utilized in a SELECT statement whereas Function can be embedded in a SELECT statement.
--6.Stored Procedures cannot be used in the SQL statements anywhere in the WHERE/HAVING/SELECT section whereas Function can be.
--7.Functions that return tables can be treated as another rowset. This can be used in JOINs with other tables.
--8.Inline Function can be though of as views that take parameters and can be used in JOINs and other Rowset operations.
--9.An exception can be handled by try-catch block in a Procedure whereas try-catch block cannot be used in a Function.
--10.We can use Transactions in Procedure whereas we can't use Transactions in Function.

--Can stored procedure return multiple result sets?
--Yes

--Can stored procedure be executed as part of SELECT Statement? Why?
--No, Stored procedures are for executing by an outside program, or on a timed interval.

--What is Trigger? What types of Triggers are there?
--Triggers are a special type of stored procedure that get executed (fired) when a specific event happens
--INSERT, UPDATE, and DELETE triggers

--What are the scenarios to use Triggers?
--Enforce Integrity beyond simple Referential Integrity
--Implement business rules
--Maintain audit record of changes
--Accomplish cascading updates and deletes

--What is the difference between Trigger and Stored Procedure?
--For Trigger:
--1.Trigger executes implicitly. Whenever an event INSERT, UPDATE, and DELETE occurs it executed automatically.
--2.We cannot define a trigger inside another trigger.
--3.Transaction statements are not allowed in the trigger.
--4.We cannot return value in a trigger.
--For Stored Procedure:
--1.A Procedure executed explicitly when the user using statements such as exec, EXECUTE, etc.
--2.We can define procedures inside another procedure. Also, we can use functions inside the stored procedure.
--3.Transaction statements such as COMMIT, ROLLBACK, and SAVEPOINT are allowed in the procedure.
--4.Stored procedures return a zero or N value. However, we can pass values as parameters.
--5.Return keyword used to exit the procedure.



--Section B
--1.
begin transaction
select *
from EmployeeTerritories e inner join Territories t
on e.TerritoryID = t.TerritoryID
inner join Region r on r.RegionID = t.RegionID
insert into Region(RegionID,RegionDescription) values(5,'Middle Earth')
insert into Territories(TerritoryID,TerritoryDescription,RegionID) values(10000, 'Gondor', 5)
insert into EmployeeTerritories(EmployeeID,TerritoryID) values ('Aragorn King','10000')
commit transaction
--2
update Territories set TerritoryDescription = 'Arnor' where TerritoryDescription = 'Gondor'
--3 
delete from Region where RegionID =5
select * from Region
--4
create view [view_product_order_Lianjie]
as
select p.ProductName, sum(od.Quantity) as TotalQuantities
from Products p inner join [Order Details] od 
on p.ProductID = od.ProductID
group by p.ProductName
select * from [view_product_order_Lianjie]
--5
create proc sp_product_order_quantity_Lianjie
@id int,
@sum int out
as
begin
    return( @sum = select sum(Quantity)  
	from [Order Details] 
	where ProductID=@id
	group by ProductID)
end
--6
create proc sp_product_order_city_Lianjie
@name varchar(64),
@city varchar(64) out
as
begin 
	return (@city =
	select top 5 dt.ShipCity
	from 
	(
	select *, count(OrderID) as totalorder
	from Orders 
	group by ShipCity
	)dt
	where @name = CustomerID
	order by totalorder
	)
end
--7
create proc sp_move_employees_Lianjie
as
begin
	select TerritoryDescription
	from Territories
	where TerritoryDescription = 'Tory'
end
--8
create trigger test_morethan100 on 
(select * from Territories t inner join EmployeeTerritories e
on t.TerritoryID = e.TerritoryID
)
for update
set Territories.TerritoryDescription = 'Troy'
as 
begin
select count(e.TerritoryID) as totalnumber
from Territories t inner join EmployeeTerritories e
on t.TerritoryID = e.TerritoryID 
where t.TerritoryDescription = 'stevens point'
group by t.TerritoryDescription
having count(e.TerritoryID)>100
end
--9
create table city_lianjie(id int not null primary key, name varchar(64))
create table people_lianjie(id int not null primary key,name varchar(64),
city int foreign key references city_lianjie(id))
Insert into city_lianjie(id,name) values(1, 'Seattle'),(2,'Green Bay')
Insert into people_lianjie(id,name,city) 
values (1,'Aaron Rodgers',2),
(2,'Russell Wilson',1),(3,'Jody Nelson',2)
delete from city_lianjie where name='Seattle'
--10
create proc sp_birthday_employees_Lianjie

as
begin
    create table birthday_employees_your_Lianjie
	(EmployeeID int primary key, Lastname varchar(64),Firstname varchar(64), BirthDate datetime)
	insert into birthday_employees_your_Lianjie 
	(EmployeeID, Lastname,Firstname, BirthDate)
	select EmployeeID, Lastname,Firstname, BirthDate
	from Employees
	where month(BirthDate)=2
end
--11.1
create proc sp_your_last_name_1
as
begin
    return(
	select dt.ShipCity, dt.total
	from(
	select o.CustomerID, o.ShipCity, count(p.ProductID) as total
	from Products p 
	inner join [Order Details] od on p.ProductID = od.ProductID
	inner join Orders o on od.OrderID = o.OrderID
	group by  o.CustomerID)dt 
	where dt.total <=1)
end
--11.2
create proc sp_your_last_name_2
as
begin
    return(
	with cte 
	as(
	select o.CustomerID, o.ShipCity, count(p.ProductID) as total
	from Products p 
	inner join [Order Details] od on p.ProductID = od.ProductID
	inner join Orders o on od.OrderID = o.OrderID
	group by  o.CustomerID)
	select cte.ShipCity, cte.total
	from cte
	where cte.total <=1)
end
--12.How do you make sure two tables have the same data?
--use CHECKSUM TABLE and compare the results. 
--14
select FirstName + LastName + MiddleName as full_Name
from table 
--15
select top 1 student
from table 
where sex = 'F'
order by marks
--16
select * from table 
where sex = 'F'
order by Marks
union all
select * from table 
where sex = 'M'
order by Marks