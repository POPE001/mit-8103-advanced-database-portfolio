# Query Optimisation Run Results

This run used a temporary local PostgreSQL container. The plan files contain the full `EXPLAIN (ANALYZE, BUFFERS)` output.

## Dataset size

| Relation | Rows |
| --- | ---: |
| `student` | 10,004 |
| `course` | 82 |
| `course_section` | 162 |
| `enrolment` | 50,004 |
| `assessment` | 322 |
| `mark` | 96,784 |

The run used PostgreSQL 16.14. The generated records are synthetic; the generator creates 10,000 students, 80 courses, 160 sections, and 50,000 enrolments on top of the Portfolio 1 seed rows.

The section-capacity check returned 0 violations; the smallest remaining capacity across all sections was 1 seat (the Portfolio 1 sample section).

The weighted-result queries now include only student-section results with a mark for every configured assessment and an assessment-weight total of 100. The result-readiness check is [validate-results.sql](../portfolio-1-database-design/validate-results.sql); captured output is in [result-validation-output.txt](result-validation-output.txt). It correctly flags the ungraded seed section 902 and its enrolment as not result-ready.

## Weighted course-performance query

Run [performance-query.sql](performance-query.sql) after loading the data and collecting planner statistics. Apply [indexes.sql](indexes.sql), then run the same query again.

The captured plans are [before](explain-before.txt) and [after](explain-after.txt).

| Measurement | Before indexes | After indexes |
| --- | --- | --- |
| Execution time | 5.302 ms | 4.173 ms |
| Shared buffer hits / reads | 11,326 / 0 | 10,197 / 6 |
| Main scan and join choices | enrolment primary-key index scan | partial enrolment index-only scan; 0 heap fetches |

The first comparison used a partial enrolment index; PostgreSQL used it for an index-only scan. The mark index was not selected for this student-level workload, so its value is evaluated separately below.

## Section assessment-summary query

Run [assessment-performance-query.sql](assessment-performance-query.sql) before and after the candidate indexes. This workload filters marks by section and assessment, which is the access path targeted by `mark_section_assessment_student_idx`.

The captured plans are [before](assessment-explain-before.txt) and [after](assessment-explain-after.txt). Query results for the representative workloads are in [query-results.txt](query-results.txt).

| Measurement | Before indexes | After indexes |
| --- | --- | --- |
| Execution time | 3.248 ms | 0.558 ms |
| Shared buffer hits / reads | 2,470 / 0 | 30 / 9 |
| Mark-table access path | primary-key index scan by section | section-assessment index-only scan; 0 heap fetches |

For these single-run comparisons, the section-assessment index reduced execution time by about 83% and buffer accesses from 2,470 to 39. The weighted course-performance query ran about 21% faster in its indexed run. Planner choices and timings depend on data and cache state, so treat the timings as indicative and repeat the comparison before making a general performance claim.

The weighted course-performance query returned 304 students with results in each section; the average final percentages were 74.49 for section A and 74.84 for section B. Representative query output is in [query-results.txt](query-results.txt).

Both comparisons are single executions in the same temporary PostgreSQL 16.14 container using the completeness-guarded query text. The plans and buffer counts are useful evidence of the access-path changes; repeat runs and report a median if making a broad timing claim.
