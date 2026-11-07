-- Compare this exact query before and after indexes.sql.
EXPLAIN (ANALYZE, BUFFERS, TIMING OFF)
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
