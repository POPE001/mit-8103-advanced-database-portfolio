# PostgreSQL Run Verification

## Environment and commands

The scripts were run against a fresh, disposable PostgreSQL 16 database in a temporary local container.

1. `schema.sql` created all 11 tables, the mark-protection function, and its trigger.
2. `seed-data.sql` loaded the sample departments, programmes, students, lecturers, courses, term, sections, assignments, enrolments, assessments, and marks. The insert and sequence-reset statements completed successfully.
3. `edge-case-check.sql` ran in a transaction and rolled back its sample changes after verification.

## Observed results

- The dropped student’s mark recorded before the status change remained stored afterward: `status = dropped`, `retained_marks = 1`.
- The trigger rejected adding a new mark, correcting an existing mark, or deleting the retained mark while the enrolment was dropped.
- Section 901 had capacity 3 and 2 active enrolments. The dropped enrolment did not consume a seat.
- The weighted result query returned 80.40 for student 1001 and 70.40 for student 1002.

## Edge-case decision

Marks earned before a student drops a section are retained. While the enrolment is dropped, marks for that enrolment cannot be added, changed, or deleted. The edge-case script rolls back its test data, leaving the seeded records unchanged.
