-- Add deterministic synthetic workload data to a fresh database containing
-- the Portfolio 1 schema and seed data. Run this script once per database.

BEGIN;

INSERT INTO course (department_id, course_code, title, credit_units)
SELECT
    1,
    'SYN-' || lpad(g.n::text, 4, '0'),
    'Synthetic Database Course ' || lpad(g.n::text, 4, '0'),
    3
FROM generate_series(1, 80) AS g(n);

INSERT INTO student (programme_id, matric_number, first_name, last_name, email)
SELECT
    2,
    'SYN-2026-' || lpad(g.n::text, 6, '0'),
    'Student' || g.n,
    'Synthetic',
    'student' || g.n || '@example.edu'
FROM generate_series(1, 10000) AS g(n);

INSERT INTO course_section (course_id, term_id, section_code, capacity)
SELECT c.course_id, 201, section.section_code, 500
FROM course AS c
CROSS JOIN (VALUES ('A'), ('B')) AS section(section_code)
WHERE c.course_code LIKE 'SYN-%';

INSERT INTO section_lecturer (section_id, lecturer_id)
SELECT cs.section_id,
       CASE cs.section_code WHEN 'A' THEN 501 ELSE 502 END
FROM course_section AS cs
JOIN course AS c USING (course_id)
WHERE c.course_code LIKE 'SYN-%';

WITH synthetic_students AS (
    SELECT student_id,
           row_number() OVER (ORDER BY matric_number)::INTEGER AS student_no
    FROM student
    WHERE matric_number LIKE 'SYN-2026-%'
),
section_pool AS (
    SELECT cs.section_id,
           row_number() OVER (ORDER BY c.course_code, cs.section_code)::INTEGER AS section_no,
           count(*) OVER ()::INTEGER AS pool_size
    FROM course_section AS cs
    JOIN course AS c USING (course_id)
    WHERE c.course_code LIKE 'SYN-%'
)
INSERT INTO enrolment (student_id, section_id, status, enrolled_at)
SELECT ss.student_id,
       sp.section_id,
       CASE
           WHEN (ss.student_no + slot.slot_no) % 31 = 0 THEN 'dropped'
           WHEN (ss.student_no + slot.slot_no) % 7 = 0 THEN 'completed'
           ELSE 'enrolled'
       END,
       TIMESTAMPTZ '2026-09-01 08:00:00+00'
           + ((ss.student_no + slot.slot_no) % 90) * INTERVAL '1 day'
FROM synthetic_students AS ss
CROSS JOIN generate_series(1, 5) AS slot(slot_no)
JOIN section_pool AS sp
  ON sp.section_no = 1 + ((ss.student_no + (slot.slot_no - 1) * 23 - 1) % sp.pool_size);

WITH synthetic_sections AS (
    SELECT cs.section_id
    FROM course_section AS cs
    JOIN course AS c USING (course_id)
    WHERE c.course_code LIKE 'SYN-%'
)
INSERT INTO assessment (section_id, assessment_no, title, weight_percent)
SELECT section_id, 1, 'Coursework', 40.00
FROM synthetic_sections
UNION ALL
SELECT section_id, 2, 'Final Examination', 60.00
FROM synthetic_sections;

INSERT INTO mark (student_id, section_id, assessment_no, score_percent)
SELECT e.student_id,
       e.section_id,
       a.assessment_no,
       (50.00 + mod(e.student_id * 17 + a.assessment_no * 23, 5001)::NUMERIC / 100)::NUMERIC(5, 2)
FROM enrolment AS e
JOIN course_section AS cs USING (section_id)
JOIN course AS c USING (course_id)
JOIN assessment AS a USING (section_id)
WHERE c.course_code LIKE 'SYN-%'
  AND e.status IN ('enrolled', 'completed');

COMMIT;

-- Refresh planner statistics before capturing the baseline query plan.
ANALYZE student;
ANALYZE course;
ANALYZE course_section;
ANALYZE academic_term;
ANALYZE enrolment;
ANALYZE assessment;
ANALYZE mark;
VACUUM (ANALYZE) enrolment;
VACUUM (ANALYZE) mark;
