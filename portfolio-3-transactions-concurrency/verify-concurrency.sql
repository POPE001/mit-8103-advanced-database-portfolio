SELECT cs.section_id,
       cs.capacity,
       count(e.student_id) FILTER (WHERE e.status = 'enrolled') AS active_enrolments,
       cs.capacity - count(e.student_id) FILTER (WHERE e.status = 'enrolled') AS seats_available
FROM course_section AS cs
LEFT JOIN enrolment AS e USING (section_id)
WHERE cs.section_id = 901
GROUP BY cs.section_id, cs.capacity;

SELECT student_id, status
FROM enrolment
WHERE section_id = 901
ORDER BY student_id;
