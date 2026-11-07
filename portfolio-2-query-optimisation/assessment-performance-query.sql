-- Compare this section-level workload before and after indexes.sql.
EXPLAIN (ANALYZE, BUFFERS, TIMING OFF)
SELECT cs.section_code,
       a.assessment_no,
       a.title,
       count(m.student_id) AS marked_students,
       round(avg(m.score_percent), 2) AS average_score_percent
FROM course AS c
JOIN course_section AS cs USING (course_id)
JOIN academic_term AS t USING (term_id)
JOIN assessment AS a USING (section_id)
JOIN mark AS m USING (section_id, assessment_no)
WHERE c.course_code = 'SYN-0040'
  AND t.academic_year = '2026/2027'
  AND t.term_name = 'First Semester'
GROUP BY cs.section_code, a.assessment_no, a.title
ORDER BY cs.section_code, a.assessment_no;
