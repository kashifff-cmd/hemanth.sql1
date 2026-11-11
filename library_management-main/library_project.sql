USE librarydb;

-- C2: Record counts
SELECT COUNT(*) AS total_members FROM members;
SELECT COUNT(*) AS total_books FROM books;
SELECT COUNT(*) AS total_issues FROM issues;

-- C3: Category-wise titles and available copies
SELECT category, COUNT(*) AS total_titles, SUM(copies_available) AS total_available_copies
FROM books GROUP BY category ORDER BY category;

-- C4: Top 5 borrowed books
SELECT b.book_id,b.title,b.author,COUNT(i.issue_id) AS total_borrowed
FROM books b JOIN issues i ON b.book_id=i.book_id
GROUP BY b.book_id,b.title,b.author
ORDER BY total_borrowed DESC,b.title LIMIT 5;

-- C5: Members who never borrowed
SELECT m.member_id,m.member_name,m.member_type
FROM members m LEFT JOIN issues i ON m.member_id=i.member_id
WHERE i.issue_id IS NULL;

-- C6: Currently issued books
SELECT i.issue_id,m.member_name,b.title,i.due_date
FROM issues i JOIN members m ON i.member_id=m.member_id
JOIN books b ON i.book_id=b.book_id
WHERE i.return_date IS NULL ORDER BY i.due_date;

-- C7: Late return fines at Rs. 2 per day
SELECT i.issue_id,m.member_name,b.title,i.due_date,i.return_date,
DATEDIFF(i.return_date,i.due_date) AS late_days,
DATEDIFF(i.return_date,i.due_date)*2 AS fine_amount
FROM issues i JOIN members m ON i.member_id=m.member_id
JOIN books b ON i.book_id=b.book_id
WHERE i.return_date>i.due_date ORDER BY late_days DESC;

-- C8: Total fine per member
SELECT m.member_id,m.member_name,
SUM(DATEDIFF(i.return_date,i.due_date)*2) AS total_fine
FROM members m JOIN issues i ON m.member_id=i.member_id
WHERE i.return_date>i.due_date
GROUP BY m.member_id,m.member_name
HAVING total_fine>0 ORDER BY total_fine DESC;

-- C9: Student vs Faculty usage
SELECT m.member_type,COUNT(i.issue_id) AS total_books_borrowed
FROM members m JOIN issues i ON m.member_id=i.member_id
GROUP BY m.member_type;

-- C10: Rank members by borrowing activity
SELECT m.member_id,m.member_name,COUNT(i.issue_id) AS total_borrowed,
RANK() OVER (ORDER BY COUNT(i.issue_id) DESC) AS member_rank
FROM members m LEFT JOIN issues i ON m.member_id=i.member_id
GROUP BY m.member_id,m.member_name ORDER BY member_rank,m.member_name;

-- C11: Category popularity
SELECT b.category,COUNT(i.issue_id) AS total_issues
FROM books b JOIN issues i ON b.book_id=i.book_id
GROUP BY b.category ORDER BY total_issues DESC;

-- C12: Zero copies with pending issues
SELECT book_id,title,category,copies_available FROM books
WHERE copies_available=0 AND book_id IN
(SELECT book_id FROM issues WHERE return_date IS NULL);

-- C13: Create member history procedure (run as a complete script in a client supporting DELIMITER)
DROP PROCEDURE IF EXISTS member_history;
DELIMITER $$
CREATE PROCEDURE member_history(IN p_member_id INT)
BEGIN
    SELECT m.member_id,m.member_name,b.title,b.author,
           i.issue_date,i.due_date,i.return_date
    FROM members m
    JOIN issues i ON m.member_id=i.member_id
    JOIN books b ON i.book_id=b.book_id
    WHERE m.member_id=p_member_id
    ORDER BY i.issue_date;
END$$
DELIMITER ;

-- C13 test after procedure creation
CALL member_history(1);

-- C14: Trigger demonstration on copies of the original tables
DROP TRIGGER IF EXISTS update_book_copies;
DROP TABLE IF EXISTS issues_copy;
DROP TABLE IF EXISTS books_copy;
CREATE TABLE books_copy LIKE books;
CREATE TABLE issues_copy LIKE issues;
INSERT INTO books_copy SELECT * FROM books;
INSERT INTO issues_copy SELECT * FROM issues;

-- Single-statement trigger; no custom delimiter is required
CREATE TRIGGER update_book_copies
AFTER INSERT ON issues_copy
FOR EACH ROW
UPDATE books_copy
SET copies_available=copies_available-1
WHERE book_id=NEW.book_id;

-- C14 test: book 3 starts with 2 copies; insert makes it 1
SELECT book_id,title,copies_available FROM books_copy WHERE book_id=3;
INSERT INTO issues_copy (issue_id,member_id,book_id,issue_date,due_date,return_date)
VALUES (26,13,3,'2026-11-10','2026-11-24',NULL);
SELECT book_id,title,copies_available FROM books_copy WHERE book_id=3;
SHOW TRIGGERS FROM librarydb;
