# Requirements and Business Rules

## System scope

The system supports course and section setup, student enrolment, assessment mark entry, and access to course results. The overall scenario and user roles are described in the [case study](../CASE_STUDY.md).

## Functional requirements

1. Department administrators maintain departments, programmes, courses, academic terms, and course sections.
2. A section is offered for one course in one academic term and has a positive seat capacity.
3. Students can enrol in or drop a section. A student cannot have duplicate enrolment rows for the same section.
4. Lecturers assigned to a section can enter one mark per assessment for each student whose enrolment is not dropped.
5. Students and the registrar can retrieve registrations and course results.

## Initial business rules

- Each student belongs to one programme; each programme belongs to one department.
- Each course belongs to one department.
- A course section belongs to one course and one academic term. Its section code is unique for that course and term.
- A section may have multiple lecturers, and a lecturer may teach multiple sections.
- An enrolment is uniquely identified by `(student_id, section_id)` and has one of these statuses: `enrolled`, `dropped`, or `completed`.
- Only `enrolled` rows count toward section capacity. A dropped or completed enrolment does not consume a seat.
- An assessment belongs to one section. Its weight is a percentage greater than 0 and at most 100.
- Marks are percentages from 0 through 100. A student can receive at most one mark for an assessment in a section.
- Assessment weights for a section must total 100 before its final result is treated as complete.
- The final percentage is derived as `SUM(score_percent * weight_percent) / 100`; it is not stored as a second copy of the marks.
- If an enrolment is changed to `dropped`, marks already recorded are retained. While it is dropped, new marks, mark corrections, and mark deletions are rejected. A dropped enrolment is not eligible for a final result.

## Rules enforced outside a row-level `CHECK`

PostgreSQL `CHECK` constraints validate one row at a time. The following rules span multiple rows and need transaction logic, a trigger, or an explicit validation step:

- Section capacity: Portfolio 3 will demonstrate checking the active enrolment count while locking the section row in the same transaction.
- Assessment weights totaling 100: validate the section's assessment set before publishing final results.

The dropped-enrolment mark rule is enforced by a PostgreSQL trigger. The rollback-only script in [edge-case-check.sql](edge-case-check.sql) demonstrates mark retention and rejection of later changes.

## Out of scope for this version

Prerequisite checking, timetable conflict detection, tuition payments, attendance, admissions, and full change-history auditing are omitted to keep the portfolio focused.
