-- Intentionally unsafe READ COMMITTED example.
-- Run in two sessions at the same time with different student_id values.
\set ON_ERROR_STOP on
\timing on

BEGIN;

-- Both sessions can read the same available-seat count because this read
-- does not lock the section row.
SELECT cs.capacity,
       count(e.student_id) FILTER (WHERE e.status = 'enrolled') AS active_count
FROM course_section AS cs
LEFT JOIN enrolment AS e USING (section_id)
WHERE cs.section_id = :section_id
GROUP BY cs.capacity
\gset

\echo 'Snapshot saw active=' :active_count ' capacity=' :capacity ' section=' :section_id
SELECT pg_sleep(2);

-- This uses the earlier count stored by psql, so two concurrent sessions can
-- both decide that the last seat is free and insert distinct students.
INSERT INTO enrolment (student_id, section_id, status)
SELECT :student_id, :section_id, 'enrolled'
WHERE :active_count < :capacity
ON CONFLICT (student_id, section_id) DO NOTHING;

COMMIT;
