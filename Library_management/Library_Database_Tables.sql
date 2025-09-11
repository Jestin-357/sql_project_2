show databases;

create database `Library`;
use Library;

DROP TABLE IF EXISTS Books;

-- Remove old table if it exists
DROP TABLE IF EXISTS Books;

-- Create fresh table
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

INSERT INTO Books VALUES
(1, 'Data Science 101', 'Technology', 50.00),
(2, 'SQL Mastery', 'Technology', 40.00),
(3, 'History of Rome', 'History', 35.00),
(4, 'World War II', 'History', 45.00),
(5, 'Modern Art', 'Arts', 30.00),
(6, 'Shakespeare Complete Works', 'Literature', 60.00),
(7, 'AI for Beginners', 'Technology',70.00);

drop table Members;

CREATE TABLE Members (
  member_id INT PRIMARY KEY,
  name VARCHAR(100)
);

INSERT INTO Members VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana'),
(5, 'Ethan');


CREATE TABLE Borrowings (
  borrow_id INT PRIMARY KEY,
  member_id INT,
  book_id INT,
  borrow_date DATE,
  return_date DATE,
  fine DECIMAL(10,2)
);

INSERT INTO Borrowings VALUES
(101, 1, 1, '2023-01-05', '2023-01-20', 0.00),   -- Alice borrowed Data Science
(102, 1, 2, '2023-02-10', NULL, 5.00),           -- Alice borrowed SQL (not returned, fine)
(103, 2, 3, '2023-01-15', '2023-01-25', 0.00),   -- Bob borrowed History
(104, 2, 4, '2023-03-01', '2023-03-20', 10.00),  -- Bob borrowed WWII (fine)
(105, 3, 5, '2023-02-05', NULL, 0.00),           -- Charlie borrowed Modern Art (not returned)
(106, 4, 6, '2023-01-25', '2023-02-15', 20.00),  -- Diana borrowed Shakespeare (fine)
(107, 5, 7, '2023-03-10', NULL, 0.00);           -- Ethan borrowed AI (not returned)

select * from `Borrowings`;


SELECT * FROM Books WHERE category = 'Technology';

### 1. Get all books in the **Technology** category.


SELECT * FROM Books WHERE category = 'Technology';

### 2. Find the most expensive book**.

SELECT * 
FROM Books 
WHERE price = (SELECT MAX(price) FROM Books);

select * from books from 
### 3. Get the **total number of books** in the library.
SELECT COUNT(*) AS total_books FROM Books;

### 4. Find members who never borrowed a book.

select * from borrowings;
SELECT m.* 
FROM Members m
LEFT JOIN Borrowings b ON m.member_id = b.member_id
WHERE b.borrow_id IS NULL;

### 5. Show all books that are currently borrowed (not returned).

select * from `Books`;
select * from `Borrowings`;
select * from `Borrowings`
where return_date is null;

### 6. Get the total borrow count per member.
select m.name, count(br.borrow_id) AS borrow_count
from `Members` m
join `Borrowings` br on m.member_id = br.member_id
group by m.name;

### 7. Find the member who borrowed the most books.

select m.name, count(br.borrow_id) as borrow_count
from Members m
join Borrowings br on m.member_id = br.member_id
group by m.name
order by borrow_count DESC limit 1;

### 8. Get the average borrow duration (in days)

SELECT AVG(DATEDIFF(return_date, borrow_date)) AS avg_duration
FROM Borrowings
WHERE return_date IS NOT NULL;

### 9. Find all books borrowed by Alice.

SELECT b.title
FROM Books b
JOIN Borrowings br ON b.book_id = br.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE m.name = 'Alice';

select b.title
from books b
join


### 10. Find members who borrowed at least **2 different books.

SELECT m.name
FROM Members m
JOIN Borrowings br ON m.member_id = br.member_id
GROUP BY m.name
HAVING COUNT(DISTINCT br.book_id) >= 2;

### 11.Show borrowings where **return\_date IS NULL
SELECT * FROM Borrowings WHERE return_date IS NULL;

### 12. Get the latest borrowed book**.

```sql
SELECT b.title, br.borrow_date
FROM Borrowings br
JOIN Books b ON br.book_id = b.book_id
ORDER BY br.borrow_date DESC
LIMIT 1;
```

---

### 13. Find members who have **paid fines**.

```sql
SELECT DISTINCT m.name
FROM Members m
JOIN Borrowings br ON m.member_id = br.member_id
WHERE br.fine > 0;
```

---

### 14. Get the **total fine amount per member**.

```sql
SELECT m.name, SUM(br.fine) AS total_fine
FROM Members m
JOIN Borrowings br ON m.member_id = br.member_id
GROUP BY m.name;
```

---

### 15. Find the **member with the highest total fine**.

```sql
SELECT m.name, SUM(br.fine) AS total_fine
FROM Members m
JOIN Borrowings br ON m.member_id = br.member_id
GROUP BY m.name
ORDER BY total_fine DESC
LIMIT 1;
```

---

### 16. Show borrowings with fines **above \$15**.

```sql
SELECT * FROM Borrowings WHERE fine > 15;
```

---

### 17. List members who have **no fines**.

```sql
SELECT DISTINCT m.name
FROM Members m
LEFT JOIN Borrowings br ON m.member_id = br.member_id
WHERE br.fine IS NULL OR br.fine = 0;
```

---

### 18. Find members along with the **titles of books they borrowed**.

```sql
SELECT m.name, b.title
FROM Members m
JOIN Borrowings br ON m.member_id = br.member_id
JOIN Books b ON br.book_id = b.book_id;
```

---

### 19. Get the **most borrowed book**.

```sql
SELECT b.title, COUNT(br.borrow_id) AS borrow_count
FROM Books b
JOIN Borrowings br ON b.book_id = br.book_id
GROUP BY b.title
ORDER BY borrow_count DESC
LIMIT 1;
```

---

### 20. Count how many books are borrowed per **category**.

```sql
SELECT b.category, COUNT(br.borrow_id) AS borrow_count
FROM Books b
JOIN Borrowings br ON b.book_id = br.book_id
GROUP BY b.category;
```

---

### 21. Get members and their **total amount spent on fines**.

```sql
SELECT m.name, SUM(br.fine) AS total_fines
FROM Members m
JOIN Borrowings br ON m.member_id = br.member_id
GROUP BY m.name;
```

---

### 22. Show members who borrowed books in **more than one category**.

```sql
SELECT m.name
FROM Members m
JOIN Borrowings br ON m.member_id = br.member_id
JOIN Books b ON br.book_id = b.book_id
GROUP BY m.name
HAVING COUNT(DISTINCT b.category) > 1;
```

---

### 23. Rank members by **total fines paid**.

```sql
SELECT m.name, SUM(br.fine) AS total_fines,
       RANK() OVER (ORDER BY SUM(br.fine) DESC) AS fine_rank
FROM Members m
JOIN Borrowings br ON m.member_id = br.member_id
GROUP BY m.name;
```

---

### 24. Show the **running total of fines** ordered by borrow\_id.

```sql
SELECT borrow_id, fine,
       SUM(fine) OVER (ORDER BY borrow_id) AS running_total
FROM Borrowings;
```ST_Disjoint
sd

---

### 25. Get the **top 2 most expensive borrowed books**.

```sql
SELECT DISTINCT b.title, b.price
FROM Books b
JOIN Borrowings br ON b.book_id = br.book_id
ORDER BY b.price DESC
LIMIT 2;
```

---

### 26. Find the **oldest borrowed book still not returned**.

```sql
SELECT b.title, br.borrow_date
FROM Borrowings br
JOIN Books b ON br.book_id = b.book_id
WHERE br.return_date IS NULL
ORDER BY br.borrow_date ASC
LIMIT 1;
```

---

### 27. Use **ROW\_NUMBER()** to find duplicate borrowings.

```sql
SELECT *
FROM (
    SELECT br.*,
           ROW_NUMBER() OVER (PARTITION BY member_id, book_id, borrow_date ORDER BY borrow_id) AS rn
    FROM Borrowings br
) t
WHERE rn > 1;
```

---

### 28. Find the **most expensive book borrowed by Bob**.

```sql
SELECT b.title, b.price
FROM Books b
JOIN Borrowings br ON b.book_id = br.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE m.name = 'Bob'
ORDER BY b.price DESC
LIMIT 1;
```

---

### 29. Find how many **books each member has not returned yet**.

```sql
SELECT m.name, COUNT(*) AS not_returned
FROM Members m
JOIN Borrowings br ON m.member_id = br.member_id
WHERE br.return_date IS NULL
GROUP BY m.name;
```

---

### 30. Get the **average fine per category**.

```sql
SELECT b.category, AVG(br.fine) AS avg_fine
FROM Books b
JOIN Borrowings br ON b.book_id = br.book_id
GROUP BY b.category;
```

---





