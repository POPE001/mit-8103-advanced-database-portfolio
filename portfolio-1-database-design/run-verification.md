# PostgreSQL Run Verification

## Environment and commands

The scripts were run against a fresh, disposable PostgreSQL 16.14 database in a temporary local container. The version and captured setup output are in [postgres-version.txt](postgres-version.txt), [schema-run-output.txt](schema-run-output.txt), and [seed-run-output.txt](seed-run-output.txt).

1. `schema.sql` created all 11 tables, the mark-protection function, and its trigger.
2. `seed-data.sql` loaded the sample departments, programmes, students, lecturers, courses, term, sections, assignments, enrolments, assessments, and marks. The insert and sequence-reset statements completed successfully.
3. `edge-case-check.sql` ran in a transaction and rolled back its sample changes after verification. Its captured output is in [edge-case-output.txt](edge-case-output.txt).
4. `validate-results.sql` checked section weight totals and mark completeness. Its captured output is in [validation-output.txt](validation-output.txt).

## Observed results

- The dropped student’s mark recorded before the status change remained stored afterward: `status = dropped`, `retained_marks = 1`.
- The trigger rejected adding a new mark, correcting an existing mark, deleting the retained mark, or reassigning it to another section while the original enrolment was dropped.
- Section 901 had capacity 3 and 2 active enrolments. The dropped enrolment did not consume a seat.
- The readiness query identified section 902 (`CSC8101`, section `A`) as having no assessment configuration and identified student 1001's enrolment in that section as not result-ready. This is the expected outcome for the ungraded sample section.
- The weighted-result queries require every configured assessment to have a mark and the section's assessment weights to total 100 before returning a result. The refreshed Portfolio 2 query output and plans are in [Portfolio 2](../portfolio-2-query-optimisation/run-results.md).

## Edge-case decision

Marks earned before a student drops a section are retained. While the enrolment is dropped, marks for that enrolment cannot be added, changed, deleted, or moved to another enrolment. The edge-case script rolls back its test data, leaving the seeded records unchanged.
