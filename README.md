# SQL_Project_Library-Management-System

## Project Overview

The project involves setting up a Database for library where books are being issued to and return by Library members, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. 

## Objectives

1. **Set up a LMS database**: Create and populate a LMS database with the provided Books, members, employee and library data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `LMS`.
- **Table Creation**: A table named `books`, 'branch','employees', 'issued_status', 'members' and 'retrun status' to store the resp. data.
- **Bulk Import**: Perform bulk import of data into the tables.

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

### 3. Data Analysis & Findings
SQL queries were developed to answer specific business questions:

1. **Write a SQL query to Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
2. **Write a SQL query to update existing members address
3. **Write a SQL query to delete the record with issued_id = 'IS121' from the issued_status table.
4. **Write a SQL query using GROUP BY to find members who have issued more than one book.
5. **Write a SQL query to Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
6. **Write a SQL query to Find Total Rental Income by Category:
7. **Write a SQL query to List Members Who Registered in the Last 180 Days
8. **Write a SQL query to find List Employees with Their Branch Manager's Name and their branch details:
9. **Write a SQL query to  Retrieve the List of Books Not Yet Returned
10. **Write a SQL query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.
11. Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table.
12. Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
13. Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
14. Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
15. Create a stored procedure to manage the status of books in a library system. Description: Write a stored procedure that updates the status of a book in the 
    library based on its issuance. 
    The procedure should function as follows: 
    The stored procedure should take the book_id as an input parameter.
    The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books
    table should be updated to 'no'. 
    If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
