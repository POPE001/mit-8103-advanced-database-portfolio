-- Restore section 901 to two active enrolments and one remaining seat.
-- Student 1003 is removed from the seed's dropped row so both 1003 and 1004
-- can compete for the same last seat in the demonstrations.

BEGIN;

UPDATE enrolment
   SET status = 'enrolled'
 WHERE section_id = 901
   AND student_id IN (1003, 1004);

DELETE FROM mark
 WHERE section_id = 901
   AND student_id IN (1003, 1004);

DELETE FROM enrolment
 WHERE section_id = 901
   AND student_id IN (1003, 1004);

UPDATE course_section
   SET capacity = 3
 WHERE section_id = 901;

COMMIT;
