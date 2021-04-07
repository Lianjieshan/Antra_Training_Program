--Section A
--1.What is an object in SQL?
--Microsoft SQL Server provides objects and counters that can be used by System Monitor to monitor activity in computers running an instance of SQL Server. 
--An object is any SQL Server resource, such as a SQL Server lock or Windows process

--2.What is Index? What are the advantages and disadvantages of using Indexes?
--An index is a distinct structure in the database that is built using the create index statement. It requires 
--its own disk space and holds a copy of the indexed table data. 
--advatages
--Speed up SELECT query
--Helps to make a row unique or without duplicates(primary,unique) 
--If index is set to fill-text index, then we can search against large string values. 
--disadvatages
--Indexes take additional disk space.
--indexes slow down INSERT,UPDATE and DELETE, but will speed up UPDATE if the WHERE condition has an indexed field.

--3.What are the types of Indexes?
--Clustered Index.
--Non-Clustered Index.
--Unique Index.
--Filtered Index.
--Columnstore Index.
--Hash Index.
--Spatial Index
--XML Index
--Full-Text Index

--4.Does SQL Server automatically create indexes when a table is created? If yes, under which constraints?
--Yes, under a PRIMARY KEY constraint

--5.Can a table have multiple clustered index? Why?
--No, There can be only one clustered index per table, because the data rows themselves can be stored in only one order.

--6.Can an index be created on multiple columns? Is yes, is the order of columns matter?
--Yes,order does not matter. Each column is considered individually.

--7.Can indexes be created on views?
--Yes, creating a unique clustered index on a view improves query performance

--8.What is normalization? What are the steps (normal forms) to achieve normalization?
--Normalization is a systematic approach of decomposing tables to eliminate data redundancy(repetition) and undesirable characteristics like Insertion, Update and Deletion Anomalies. 
--First Normal Form
--Second Normal Form
--Third Normal Form
--BCNF
--Fourth Normal Form

--9.What is denormalization and under which scenarios can it be preferable?
--Denormalization is a database optimization technique in which we add redundant data to one or more tables. 
--1 To enhance query performance
--2 To make a database more convenient to manage
--3 To facilitate and accelerate reporting

--10.How do you achieve Data Integrity in SQL Server?
--Data integrity refers to the accuracy, consistency, and reliability of data that is stored in the database. 
--Data integrity is enforced by database constraints

--11.What are the different kinds of constraint do SQL Server have?
--Not Null Constraint
--Check Constraint
--Default Constraint
--Unique Constraint
--Primary Constraint
--Foreign Constraint

--12.What is the difference between Primary Key and Unique Key?
--For Primary Key
--Unique identifier for rows of a table	
--Cannot be NULL	
--Only one primary key can be present in a table		
--Selection using primary key creates clustered index
--For Unique Key
--Unique identifier for rows of a table when primary key is not present
--Can be NULL
--Multiple Unique Keys can be present in a table
--Selection using unique key creates non-clustered index

--13.What is foreign key?
--The FOREIGN KEY constraint is used to prevent actions that would destroy links between tables. 
--A FOREIGN KEY is a field (or collection of fields) in one table, that refers to the PRIMARY KEY in another table.

--14.Can a table have multiple foreign keys?
--Yes

--15.Does a foreign key have to be unique? Can it be null?
--Yes, it can be NULL or duplicate.

--16.Can we create indexes on Table Variables or Temporary Tables?
--Yes

--17.What is Transaction? What types of transaction levels are there in SQL Server?
--Transaction is a single recoverable unit of work that executes either ompletely or Not at all
--Read Uncommitted (Lowest level)
--Read Committed
--Repeatable Read
--Serializable (Highest Level)
--Snapshot Isolation


--Section B
--1.Write an sql statement that will display the name of each customer and the sum of order totals placed by that customer during the year 2002
 Create table customer(cust_id int,  iname varchar (50)) 
 create table orders (order_id int,cust_id int,amount money,order_date smalldatetime)
 select c.cust_id, c.iname, count(*)
 from customer c inner join orders o 
 on c.cust_id = o.cust_id
 where year(o.order_date) = 2002
 group by c.cust_id, c.iname

--2 write a query that returns all employees whose last names  start with “A”.
Create table person (id int, firstname varchar(100), lastname varchar(100)) 
select *
from person
where lastname like 'A%'

--3 Please write a query that would return the names of all top managers(an employee who does not have  a manger, and the number of people that report directly to this manager.
Create table persons(person_id int primary key, manager_id int null, name varchar(100)not null) 
select p.person_id, p.name
from persons p left join persons m
on p.manager_id = m.person_id
where p.manager_id = null

--4.List all events that can cause a trigger to be executed.
--DML statements that modify data in a table ( INSERT , UPDATE , or DELETE )
--DDL statements.
--System events such as startup, shutdown, and error messages.
--User events such as logon and logoff. Note: Oracle Forms can define, store, and run triggers of a different sort.

--5 Generate a destination schema in 3rd Normal Form.  Include all necessary fact, join, and dictionary tables, and all Primary and Foreign Key relationships.  
--a. Each Company can have one or more Divisions.
--b. Each record in the Company table represents a unique combination 
--c. Physical locations are associated with Divisions.
--d. Some Company Divisions are collocated at the same physical of Company Name and Division Name.
--e. Contacts can be associated with one or more divisions and the address, but are differentiated by suite/mail drop records.status of each association should be separately maintained and audited.

create table employee (employeeID int primary key, firstname varchar(64),
lastname varchar(64), phonenumber int, email varchar(64) unique)

create table divisions (divisionsID int primary key, name varchar(64),location varchar(64),
employeeID int foreign key references employee(employeeID))

create table company (companyID int primary key, companyname varchar(64),
divisionID int foreign key references divisions(divisionsID))







