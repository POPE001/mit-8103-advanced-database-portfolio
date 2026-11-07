BEGIN;

UPDATE course_section
   SET capacity = 4
 WHERE section_id = 901
   AND capacity = 3;

COMMIT;

SELECT section_id, capacity
FROM course_section
WHERE section_id = 901;
