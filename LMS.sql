-- Library Management System

--Create Database
Create database LMS

-- Create Schema
Create Schema LMS


-- Create Tables books
drop table  if exists LMS.books
Create table LMS.books 
(
	isbn varchar(50) primary key,
	book_title varchar(200),
	category varchar(50),
	rental_price float,
	status varchar(50),
	author varchar(75),
	publisher varchar(75)
)

-- create table branch
drop table  if exists LMS.branch
Create table LMS.branch 
(
	branch_id varchar(10) primary key,
	manager_id varchar(10),
	branch_address	varchar(50),
	contact_no numeric
)

-- create table employee
drop table if exists LMS.employee
create table LMS.employee
(
	emp_id varchar(10) primary key,
	emp_name varchar(50),
	position varchar(50),
	salary int,
	branch_id varchar(10)
)

-- create table issued_status
drop table if exists LMS.issued_status
create table LMS.issued_status
(
issued_id varchar(10) primary Key,
issued_member_id varchar(10),
issued_book_name varchar(100),
issued_date	date,
issued_book_isbn varchar(50),
issued_emp_id varchar(50)
)


-- create table members
drop table if exists LMS.members
create table LMS.members
(
member_id varchar (10) primary key,
member_name varchar (10),
member_address varchar (100),
reg_date date
)


-- create table return_status
drop table if exists LMS.return_status
create table LMS.return_status
(
return_id varchar(10) primary key,
issued_id varchar(10),
return_book_name varchar(100),
return_date	date,
return_book_isbn varchar(50)
)

--Bulk insert into tables

bulk insert [LMS].[LMS].[books]
from 'C:\Users\nidhi\Downloads\New folder\Library project datasource\books.csv'
with (
fieldterminator = ',',
rowterminator = '\n',
firstrow = 2
);


bulk insert [LMS].[LMS].employee
from 'C:\Users\nidhi\Downloads\New folder\Library project datasource\employees.csv'
with (
fieldterminator = ',',
rowterminator = '\n',
firstrow = 2
);


--Project Tasks

-- Q1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
-- Answer
insert into LMS.books 
(
	[isbn]
	,[book_title]
	,[category]
	,[rental_price]
	,[status]
	,[author]
	,[publisher]
 )
 Values
 ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')


 --Q2 update esxsiting members address
 --Answer
 Update LMS.members
 set member_address = '125 Oak St'
 where member_id = 'C103';

 --Q3 Delete the record with issued_id = 'IS121' from the issued_status table.
 --Answer
delete from LMS.issued_status
where issued_id = 'IS121'

--Q4 Select all books issued by the employee with emp_id = 'E101'.
--Answer 
Select * from LMS.issued_status
where issued_emp_id = 'E101'

--Q5  Use GROUP BY to find members who have issued more than one book.
--Answer
Select issued_emp_id, Count(*) as 'Count' from LMS.issued_status group by issued_emp_id having Count(*) > 1

--Q6 Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
--Answer 1
select 
book_title,
count(issued_book_isbn) as 'Count'
into CTAS_1
from dbo.lms_dm
group by book_title

--Answer 2
Select b.book_title, count(i.issued_book_isbn) as 'Count' into CTAS
from lms.issued_status i
left join LMS.books b
on i.issued_book_isbn = b.isbn
group by b.book_title

Select * from CTAS

--Q7 Task 8: Find Total Rental Income by Category:
--Answer 1
select 
Category,
Sum(rental_price) as Rental
from dbo.lms_dm
group by Category
order by Rental desc

--Answer 2
Select b.category,sum(b.rental_price) as rental from LMS.issued_status i
left join lms.books b
on i.issued_book_isbn = b.isbn
group by b.category
order by Rental desc

-- Q8 List Members Who Registered in the Last 180 Days
--Answer
Select * from 
(select member_id, datediff(day,reg_date,max(reg_date) over ()) as age from lms.members )m where age <=180

--Q9 List Employees with Their Branch Manager's Name and their branch details:
--Answer
	select e.emp_id,e.emp_name,e.position,e.salary,b.branch_address,e1.emp_name as manager from lms.employees e
	left join lms.branch b
	on b.branch_id=e.branch_id
	left join lms.employees e1
	on e1.emp_id = b.manager_id
	order by manager

--Q10 Retrieve the List of Books Not Yet Returned
--Answer 
Select i.issued_id,i.issued_book_name,r.return_id from lms.issued_status i
left join lms.return_status r
on r.issued_id = i.issued_id
where r.return_id is null

--Q11 Write a query to identify members who have overdue books (assume a 30-day return period). 
--Display the member's_id, member's name, book title, issue date, and days overdue.
--Answer
Select * from
(
Select m.member_id,m.member_name,i.issued_book_name,i.issued_date,DATEDIFF(day,i.issued_date,max(i.issued_date) over()) as Age,r.return_id from LMS.members m
left join lms.issued_status i
on i.issued_member_id=m.member_id
left join lms.return_status r
on r.issued_id=i.issued_id
) as Sub_1
where Sub_1.return_id is null
and Age >= 30


--Q12 Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table.
--Answer 1
create proc proc_1
	@returnid varchar(50),
	@issueid varchar(50)
as
	begin
		declare 
		@v_issued varchar(50),
		@v_book varchar(100)
Select 
	@v_issued = issued_book_isbn,
	@v_book = issued_book_name
from LMS.issued_status
where issued_id = @issueid

insert into lms.return_status
		(return_id,issued_id,return_book_name,return_date,return_book_isbn)
Values 
		(@returnid,@issueid,@v_book,GETDATE(),@v_issued)
update lms.books
set status ='No'
where isbn = @v_issued
end
go

exec proc_1 'RS119','IS135'

 --Q13 Create a query that generates a performance report for each branch,
 --showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
--Answer
 Select 
	 sub.branch_id,
	 count(sub.issued_id) as 'Book issued',
	 sum(sub.rental_price) as 'Rental Income',
	 count(sub.return_id) as 'Book Returned'
 from 
 (
 Select 
	 e.branch_id,
	 i.issued_id,
	 b.rental_price,
	 r.return_id 
 from lms.employees e
 left join lms.issued_status i
  on e.emp_id = i.issued_emp_id
 left join lms.books b
  on i.issued_book_isbn = b.isbn
  left join lms.return_status r
  on r.issued_id = i.issued_id
  ) as sub
  group by  sub.branch_id
  order by [Rental Income] desc

 --Q14 Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
 --Answer
SELECT  
e.emp_name,
Sub_2.Issued_emp_id,
count(*) as 'Count of Book'
FROM 
(
 SELECT  
 Issued_emp_id,
 datediff(day,issued_date,MAX(issued_date) over()) as Age
 FROM LMS.issued_status 
) as Sub_2
join lms.employees e
on Sub_2.Issued_emp_id = e.emp_id 
Where Sub_2.Age <=60 
group by 
Sub_2.Issued_emp_id,
e.emp_name
order by count(*) desc

--Q15 Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
--Answer
Select top 3 e.emp_name,count(*) as 'Book Count',b.branch_address from lms.issued_status i
join lms.employees e
on i.issued_emp_id = e.emp_id
join lms.branch b
on e.branch_id=b.branch_id
group by e.emp_name,b.branch_address
order by 'book Count' desc


--Q16 Create a stored procedure to manage the status of books in a library system. Description: Write a stored procedure that updates the status of a book in the 
--library based on its issuance. 
--The procedure should function as follows: 
--The stored procedure should take the book_id as an input parameter.
--The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books
--table should be updated to 'no'. 
--If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
--Answer
create or alter proc proc_2
	@bookid varchar(50),
	@issued varchar(50) = null,
	@member varchar(50) = null,
	@employee varchar(50) = null
as
begin
	declare 
	@id varchar(50),
	@book varchar(100),
	@status varchar(50)

Select @id = [isbn],
    @book = [book_title],
	@status = [status]
    from lms.books

where isbn = @bookid
if @status = 'No'
	begin
	print 'The book is currently not available'
	return
	end

if 	@issued is null
	or @member is null
	or @employee is null
	begin
	print 'Provide details to issue'
	return
	end

insert into lms.issued_status
		([issued_id]
      ,[issued_member_id]
      ,[issued_book_name]
      ,[issued_date]
      ,[issued_book_isbn]
      ,[issued_emp_id]
	)
Values (@issued,@member,@book,GETDATE(),@bookid,@employee)

update lms.books
set status = 'No'
where isbn = @bookid

	begin
	print 'The book is Successfully Issued'
	return
	end
end 
go

exec proc_2 '978-0-7432-4722-4','IS141','C111','E999'


