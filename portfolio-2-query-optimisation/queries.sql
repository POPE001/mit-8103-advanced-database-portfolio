-- Representative portal queries over the Portfolio 1 schema.

-- 1. A student's transcript for an academic term.
SELECT s.matric_number,
       t.academic_year,
       t.term_name,
       c.course_code,
       c.title AS course_title,
       cs.section_code,
       round(sum(m.score_percent * a.weight_percent) / 100, 2) AS final_percent
FROM student AS s
JOIN enrolment AS e USING (student_id)
JOIN course_section AS cs USING (section_id)
JOIN course AS c USING (course_id)
JOIN academic_term AS t USING (term_id)
JOIN mark AS m USING (student_id, section_id)
JOIN assessment AS a USING (section_id, assessment_no)
WHERE s.matric_number = 'SYN-2026-000001'
  AND t.academic_year = '2026/2027'
  AND t.term_name = 'First Semester'
  AND e.status IN ('enrolled', 'completed')
GROUP BY s.matric_number, t.academic_year, t.term_name,
         c.course_code, c.title, cs.section_code
ORDER BY c.course_code, cs.section_code;

-- 2. Current seat usage by course section for the academic term.
SELECT c.course_code,
       c.title AS course_title,
       cs.section_code,
       cs.capacity,
       count(e.student_id) FILTER (WHERE e.status = 'enrolled') AS active_enrolments,
       cs.capacity - count(e.student_id) FILTER (WHERE e.status = 'enrolled') AS seats_available
FROM course_section AS cs
JOIN course AS c USING (course_id)
JOIN academic_term AS t USING (term_id)
LEFT JOIN enrolment AS e USING (section_id)
WHERE t.academic_year = '2026/2027'
  AND t.term_name = 'First Semester'
GROUP BY c.course_code, c.title, cs.section_code, cs.capacity
ORDER BY c.course_code, cs.section_code;

-- 3. Average weighted result by section for one course. The measured form of
-- this query, with EXPLAIN ANALYZE, is in performance-query.sql.
WITH student_results AS (
    SELECT cs.section_id,
           cs.section_code,
           e.student_id,
           sum(m.score_percent * a.weight_percent) / 100 AS final_percent
    FROM course AS c
    JOIN course_section AS cs USING (course_id)
    JOIN academic_term AS t USING (term_id)
    JOIN enrolment AS e USING (section_id)
    JOIN mark AS m USING (student_id, section_id)
    JOIN assessment AS a USING (section_id, assessment_no)
    WHERE c.course_code = 'SYN-0040'
      AND t.academic_year = '2026/2027'
      AND t.term_name = 'First Semester'
      AND e.status IN ('enrolled', 'completed')
    GROUP BY cs.section_id, cs.section_code, e.student_id
)
SELECT section_code,
       count(*) AS students_with_results,
       round(avg(final_percent), 2) AS average_final_percent
FROM student_results
GROUP BY section_code
ORDER BY section_code;
