-- Candidate indexes for the course-performance workload.
-- Compare performance-query.sql before and after applying these indexes.

CREATE INDEX enrolment_section_result_student_idx
    ON enrolment (section_id, status, student_id)
    WHERE status IN ('enrolled', 'completed');

CREATE INDEX mark_section_assessment_student_idx
    ON mark (section_id, assessment_no, student_id)
    INCLUDE (score_percent);

ANALYZE enrolment;
ANALYZE mark;
