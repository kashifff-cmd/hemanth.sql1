# Library Management System

**Project Type:** DBMS Mini Project  
**Course:** Database Management Systems  
**Database:** MySQL (`librarydb`)  
**Software:** MySQL Workbench 26.10 / MySQL Server 9.5

## 1. Introduction
The Library Management System is a mini project developed using MySQL. It maintains records of library members, available books and book borrowing activities.

The main objective is to understand relational database management and use SQL queries to retrieve, manage and analyse library information. The system helps identify popular books, track currently issued books, calculate late return fines and analyse borrowing patterns.

## 2. Database Tables
**members** (students and faculty)

| Column | Description |
|---|---|
| member_id | Primary key |
| member_name | Name of the member |
| member_type | Student or Faculty |
| joined_date | Date of joining |

**books**

| Column | Description |
|---|---|
| book_id | Primary key |
| title | Book name |
| author | Author name |
| category | Book category |
| price | Price of the book |
| copies_available | Number of available copies |

**issues**

| Column | Description |
|---|---|
| issue_id | Primary key |
| member_id | Foreign key referencing members |
| book_id | Foreign key referencing books |
| issue_date | Date when the book was issued |
| due_date | Expected return date |
| return_date | Actual return date (NULL means not returned) |

## 3. Database Relationships
- One member can have multiple issue records (1:N).
- One book can have multiple issue records (1:N).
- The issues table connects members and books using foreign keys.

![ERD](ERD.jpg)

## 4. Sample Data

| Table | Total Records |
|---|---:|
| Members | 15 |
| Books | 15 |
| Issues | 25 |

Categories: Database, Programming, Computer Science, AI, Fiction, Biography, Self Help, Finance and Data Science.

## 5. Fine Calculation
**Fine = Late Days × Rs. 2**
- Rs. 2 is charged for each day returned after the due date.
- Books returned on or before the due date do not incur a fine.
- A NULL return date means the book is currently issued.

## 6. SQL Concepts Used
Database and table creation, primary and foreign keys, SELECT, WHERE, COUNT, SUM, GROUP BY, HAVING, ORDER BY, LIMIT, INNER JOIN, LEFT JOIN, subqueries, NULL handling, DATEDIFF, RANK() window function, stored procedures and triggers.

## 7. Project Questions
**Phase 1 - Database Basics:** C1 ERD, C2 total counts.

**Phase 2 - SQL Queries:** C3 category-wise title count and copies, C4 top 5 borrowed books, C5 members who never borrowed, C6 currently issued books, C7 late-return fines, C8 total fine per member, C9 Student vs Faculty usage, C10 member ranking, C11 category popularity, C12 zero-copy books with pending issues.

**Phase 3 - Automation:** C13 member-history stored procedure, C14 trigger to reduce available copies.

**Phase 4 - Conclusion:** C15 recommendations.

## 8. Files Included

| File | Description |
|---|---|
| schema.sql | Creates database and tables |
| insert_data.sql | Inserts sample records |
| library_project.sql | SQL queries C2-C14 |
| README.md | Project description and run instructions |
| ERD.jpg | Entity Relationship Diagram |

## 9. How to Run
1. Open MySQL Workbench and connect to the server.
2. Run `schema.sql` to create the database and tables.
3. Run `insert_data.sql` to insert sample records.
4. Run `library_project.sql` to execute C2-C14.
5. For C13, run the complete procedure definition using a MySQL client that supports `DELIMITER`, then run `CALL member_history(1);`.
6. Review the output of each query.

Verify original records:
```sql
USE librarydb;
SELECT COUNT(*) FROM members; -- Expected: 15
SELECT COUNT(*) FROM books;   -- Expected: 15
SELECT COUNT(*) FROM issues;  -- Expected: 25

```
## 10. Learning Outcomes
Through this project, I learned how to create and manage relational databases using MySQL. I gained practical experience in SQL queries, joins, aggregate functions, subqueries and window functions. I also learned how stored procedures and triggers automate database operations.

## 11. Conclusion
The College Library Management System demonstrates how MySQL can maintain and analyse library records. The project provides information about borrowing patterns, popular books, pending returns and late return fines. Stored procedures and triggers demonstrate database automation

