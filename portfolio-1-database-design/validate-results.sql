-- Report sections whose assessment weights are not ready for final results,
-- and active/completed enrolments with incomplete assessment marks.
-- Run after schema.sql and seed-data.sql (and after loading any test data).

\echo 'Sections with no assessments or assessment weights that do not total 100:'
SELECT cs.section_id,
       c.course_code,
       cs.section_code,
       COUNT(a.assessment_no) AS assessment_count,
       COALESCE(SUM(a.weight_percent), 0.00) AS total_weight_percent
FROM course_section AS cs
JOIN course AS c USING (course_id)
LEFT JOIN assessment AS a USING (section_id)
GROUP BY cs.section_id, c.course_code, cs.section_code
HAVING COUNT(a.assessment_no) = 0
    OR COALESCE(SUM(a.weight_percent), 0.00) <> 100.00
ORDER BY c.course_code, cs.section_code;

\echo 'Enrolments without a complete mark set for a 100-percent assessment set:'
WITH assessment_totals AS (
    SELECT section_id,
           COUNT(*) AS assessment_count,
           SUM(weight_percent) AS total_weight_percent
    FROM assessment
    GROUP BY section_id
)
SELECT e.student_id,
       e.section_id,
       COALESCE(at.assessment_count, 0) AS expected_assessments,
       COUNT(m.assessment_no) AS recorded_marks,
       COALESCE(at.total_weight_percent, 0.00) AS total_weight_percent
FROM enrolment AS e
LEFT JOIN assessment_totals AS at USING (section_id)
LEFT JOIN mark AS m USING (student_id, section_id)
WHERE e.status IN ('enrolled', 'completed')
GROUP BY e.student_id, e.section_id, at.assessment_count, at.total_weight_percent
HAVING COALESCE(at.assessment_count, 0) = 0
    OR COALESCE(at.total_weight_percent, 0.00) <> 100.00
    OR COUNT(m.assessment_no) <> COALESCE(at.assessment_count, 0)
ORDER BY e.section_id, e.student_id;
