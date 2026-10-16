-- ============================================================
-- PART 29: SQL CHEAT SHEET, RUNNABLE
-- Every block runs as written. Use it as a quick reference
-- and as a test bench for trying syntax.
-- ============================================================

USE humanresource;

-- QUERY SKELETON: clauses in this order
SELECT   d.DeptName, COUNT(e.EmpNo) AS Staff
FROM     departments d
LEFT JOIN employees e ON e.DeptNo = d.DeptNo
WHERE    d.DeptNo <> 0
GROUP BY d.DeptName
HAVING   COUNT(e.EmpNo) >= 0
ORDER BY Staff DESC, d.DeptName
LIMIT    10;

-- FILTERING
SELECT Ename FROM employees WHERE Salary >= 2500 AND Salary <= 4000;
SELECT Ename FROM employees WHERE Job IN ('Clerk', 'Analyst');
SELECT Ename FROM employees WHERE Salary BETWEEN 2000 AND 3000;
SELECT Ename FROM employees WHERE Ename LIKE 'A%';
SELECT Ename FROM employees WHERE DeptNo IS NULL;

-- FUNCTIONS
SELECT UPPER(Ename), CONCAT(Ename, '-', Job), LENGTH(Ename) FROM employees;
SELECT ROUND(Salary / 12, 2), COALESCE(DeptNo, 0) FROM employees;
SELECT YEAR(HireDate), TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) FROM employees;
SELECT CASE WHEN Salary >= 3500 THEN 'High' ELSE 'Other' END AS Band FROM employees;

-- AGGREGATES
SELECT COUNT(*), COUNT(DeptNo), COUNT(DISTINCT Job), SUM(Salary), AVG(Salary), MIN(Salary), MAX(Salary)
FROM employees;

-- JOINS
SELECT e.Ename, d.DeptName FROM employees e JOIN departments d ON e.DeptNo = d.DeptNo;
SELECT e.Ename, d.DeptName FROM employees e LEFT JOIN departments d ON e.DeptNo = d.DeptNo;
SELECT e.Ename, d.DeptName FROM employees e RIGHT JOIN departments d ON e.DeptNo = d.DeptNo;
SELECT a.Ename, b.Ename FROM employees a JOIN employees b ON a.DeptNo = b.DeptNo AND a.EmpNo < b.EmpNo;

-- SUBQUERIES AND CTEs
SELECT Ename FROM employees WHERE Salary > (SELECT AVG(Salary) FROM employees);
SELECT Ename FROM employees WHERE DeptNo IN (SELECT DeptNo FROM departments WHERE Location = 'Kampala');
SELECT DeptName FROM departments d WHERE EXISTS (SELECT 1 FROM employees e WHERE e.DeptNo = d.DeptNo);
WITH dept_avg AS (SELECT DeptNo, AVG(Salary) AS AvgPay FROM employees GROUP BY DeptNo)
SELECT DeptNo, AvgPay FROM dept_avg;
WITH RECURSIVE n AS (SELECT 1 AS v UNION ALL SELECT v + 1 FROM n WHERE v < 5) SELECT v FROM n;

-- SET OPERATIONS (INTERSECT and EXCEPT need MySQL 8.0.31 or later)
SELECT DeptNo FROM employees UNION SELECT DeptNo FROM departments;
SELECT DeptNo FROM employees UNION ALL SELECT DeptNo FROM departments;
SELECT DeptNo FROM employees INTERSECT SELECT DeptNo FROM departments;
SELECT DeptNo FROM departments EXCEPT SELECT DeptNo FROM employees;

-- WINDOW FUNCTIONS
SELECT Ename,
       ROW_NUMBER() OVER (PARTITION BY DeptNo ORDER BY Salary DESC) AS RowNum,
       RANK()       OVER (ORDER BY Salary DESC)                     AS Ranked,
       DENSE_RANK() OVER (ORDER BY Salary DESC)                     AS DenseRanked,
       SUM(Salary)  OVER (ORDER BY EmpNo)                           AS RunningTotal
FROM employees;

-- CHANGING DATA AND STRUCTURE, using a scratch table
DROP TABLE IF EXISTS cheat_demo;

CREATE TABLE cheat_demo (
    ID    INT PRIMARY KEY,
    Name  VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price >= 0),
    Ref   INT,
    FOREIGN KEY (Ref) REFERENCES departments (DeptNo)
);

INSERT INTO cheat_demo (ID, Name, Price, Ref) VALUES (1, 'Pen', 1.50, 10), (2, 'Book', 12.00, 20);
INSERT INTO cheat_demo (ID, Name, Price) VALUES (3, 'Bag', 25.00);

UPDATE cheat_demo SET Price = Price + 1 WHERE Name = 'Pen';
DELETE FROM cheat_demo WHERE ID = 3;

ALTER TABLE cheat_demo ADD COLUMN Note VARCHAR(100);
ALTER TABLE cheat_demo DROP COLUMN Note;

CREATE INDEX idx_cheat_name ON cheat_demo (Name);

SELECT * FROM cheat_demo;

-- TRANSACTIONS
START TRANSACTION;
UPDATE cheat_demo SET Price = 0;
ROLLBACK;

SELECT * FROM cheat_demo;   -- prices unchanged

-- Remove the scratch table (this also removes its index)
DROP TABLE cheat_demo;

-- TRAPS
-- Returns no rows, because = NULL is never true
SELECT Ename FROM employees WHERE DeptNo = NULL;

-- Returns no rows, because the list contains NULL
SELECT DeptName FROM departments WHERE DeptNo NOT IN (SELECT DeptNo FROM employees);

-- Error in MySQL 8: Ename is neither grouped nor aggregated (uncomment to see the error)
-- SELECT Ename, COUNT(*) FROM employees GROUP BY DeptNo;

-- DANGER: this would delete every employee, because there is no WHERE clause. Never run it.
-- DELETE FROM employees;

