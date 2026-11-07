-- Protected READ COMMITTED example.
-- Run in two sessions at the same time with different student_id values.
\set ON_ERROR_STOP on
\timing on

BEGIN;

-- Serialise seat allocation for this section. The count and insert happen
-- after the lock is acquired; the later statement gets a fresh READ COMMITTED
-- snapshot after any session that held the lock first has committed.
SELECT capacity
FROM course_section
WHERE section_id = :section_id
FOR UPDATE;

SELECT pg_sleep(2);

INSERT INTO enrolment (student_id, section_id, status)
SELECT :student_id, :section_id, 'enrolled'
WHERE (SELECT count(*)
       FROM enrolment
       WHERE section_id = :section_id
         AND status = 'enrolled')
    < (SELECT capacity
       FROM course_section
       WHERE section_id = :section_id)
ON CONFLICT (student_id, section_id) DO NOTHING;

COMMIT;
