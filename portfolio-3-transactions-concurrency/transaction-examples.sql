-- Demonstrate COMMIT and ROLLBACK in a disposable database seeded with P1.
\set ON_ERROR_STOP on
\timing on

\echo 'COMMIT example: persist a student email update.'
BEGIN;
UPDATE student
   SET email = 'ada.okafor.tx-committed@example.edu'
 WHERE student_id = 1001;
COMMIT;
SELECT student_id, email
FROM student
WHERE student_id = 1001;

\echo 'ROLLBACK example: discard a student email update.'
BEGIN;
UPDATE student
   SET email = 'tunde.bello.tx-rolledback@example.edu'
 WHERE student_id = 1002;
ROLLBACK;
SELECT student_id, email
FROM student
WHERE student_id = 1002;
