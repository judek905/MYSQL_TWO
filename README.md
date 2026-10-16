# SQL Cheat Sheet (Part 29)

A runnable SQL reference for MySQL. Every block in `29-cheat-sheet.sql` is written to run as-is, so you can read it as a quick reference or use it as a test bench for trying out syntax.

## Contents

| Section | What it covers |
|---|---|
| Query skeleton | The order of clauses in a `SELECT` |
| Filtering | Comparisons, `IN`, `BETWEEN`, `LIKE`, `IS NULL` |
| Functions | String, numeric, date and `CASE` expressions |
| Aggregates | `COUNT`, `SUM`, `AVG`, `MIN`, `MAX` |
| Joins | Inner, left, right and self joins |
| Subqueries and CTEs | Scalar, `IN`, `EXISTS`, `WITH` and `WITH RECURSIVE` |
| Set operations | `UNION`, `UNION ALL`, `INTERSECT`, `EXCEPT` |
| Window functions | `ROW_NUMBER`, `RANK`, `DENSE_RANK`, running totals |
| Changing data and structure | Create, insert, update, delete, alter and index |
| Transactions | `START TRANSACTION` and `ROLLBACK` |
| Traps | Common mistakes and what they return |

## Requirements

- MySQL 8.0 or later. The file uses MySQL-specific syntax such as `LIMIT`, `TIMESTAMPDIFF` and `CURDATE`, so it will not run unchanged on other databases.
- `INTERSECT` and `EXCEPT` need MySQL 8.0.31 or later.
- `CHECK` constraints are enforced from MySQL 8.0.16 onward.
- A database named `humanresource` with at least these tables:
  - `departments` with columns `DeptNo`, `DeptName` and `Location`
  - `employees` with columns `EmpNo`, `Ename`, `Job`, `Salary`, `DeptNo` and `HireDate`
- The sample inserts reference `DeptNo` values 10 and 20. Those rows must exist in `departments`, or the foreign key will reject the inserts.

## Running it

Run the whole file from the command line:

```bash
mysql -u your_user -p < 29-cheat-sheet.sql
```

Or open it in a MySQL client and run it one block at a time. The file starts with `USE humanresource;`, so it switches to that database automatically.

The scratch table `cheat_demo` is created, changed and dropped within the file. If you stop partway through, remove it manually:

```sql
DROP TABLE IF EXISTS cheat_demo;
```

## Traps

The Traps section shows mistakes that run without an obvious error but give the wrong result, or that fail in MySQL 8's default strict mode.

- `WHERE DeptNo = NULL` returns no rows, because a comparison with `NULL` is never true. Use `IS NULL` instead.
- `NOT IN` against a subquery returns no rows if that subquery produces any `NULL`. Filter out the `NULL` values or use `NOT EXISTS`.
- Selecting a column that is neither grouped nor aggregated fails under `ONLY_FULL_GROUP_BY`, which is on by default in MySQL 8. The example is commented out so the file runs cleanly. Uncomment it to see the error.

## Warning

The last statement in the file is `DELETE FROM employees;` and it is commented out on purpose. It has no `WHERE` clause, so it would delete every employee row. Do not uncomment it unless you intend to empty the table.
