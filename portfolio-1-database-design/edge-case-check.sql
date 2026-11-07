-- Rollback-only check for marks when a student drops a section.
-- Run after schema.sql and seed-data.sql in a disposable database.

BEGIN;

-- Student 1003 is initially dropped and has no marks in the sample data.
-- Enrol the student, record one mark, then drop the enrolment.
UPDATE enrolment
   SET status = 'enrolled'
 WHERE student_id = 1003
   AND section_id = 901;

INSERT INTO mark (student_id, section_id, assessment_no, score_percent)
VALUES (1003, 901, 1, 88.00);

UPDATE enrolment
   SET status = 'dropped'
 WHERE student_id = 1003
   AND section_id = 901;

DO $$
DECLARE
    retained_mark_count INTEGER;
BEGIN
    SELECT COUNT(*)
      INTO retained_mark_count
      FROM mark
     WHERE student_id = 1003
       AND section_id = 901;

    IF retained_mark_count <> 1 THEN
        RAISE EXCEPTION 'Expected one retained mark after dropping; found %', retained_mark_count;
    END IF;

    BEGIN
        INSERT INTO mark (student_id, section_id, assessment_no, score_percent)
        VALUES (1003, 901, 2, 90.00);
        RAISE EXCEPTION 'Expected a new mark for a dropped enrolment to be rejected';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'PASS: new mark rejected for dropped enrolment';
    END;

    BEGIN
        UPDATE mark
           SET score_percent = 89.00
         WHERE student_id = 1003
           AND section_id = 901
           AND assessment_no = 1;
        RAISE EXCEPTION 'Expected a mark correction for a dropped enrolment to be rejected';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'PASS: mark correction rejected for dropped enrolment';
    END;

    BEGIN
        DELETE FROM mark
         WHERE student_id = 1003
           AND section_id = 901
           AND assessment_no = 1;
        RAISE EXCEPTION 'Expected deletion of a retained mark for a dropped enrolment to be rejected';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'PASS: retained mark deletion rejected for dropped enrolment';
    END;
END;
$$;

SELECT e.status, COUNT(m.assessment_no) AS retained_marks
  FROM enrolment AS e
  LEFT JOIN mark AS m USING (student_id, section_id)
 WHERE e.student_id = 1003
   AND e.section_id = 901
 GROUP BY e.status;

ROLLBACK;
