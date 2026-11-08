# Normalisation Notes

The design separates facts about departments, programmes, students, courses, lecturers, terms, and sections into their own relations. The notes below explain the intended normal form and the main dependencies.

## First normal form (1NF)

Each column stores one value of its declared type. Lists of lecturers are not stored in a section row; the many-to-many relationship is represented by `section_lecturer`. Assessment marks are stored as separate rows rather than as repeating columns such as `coursework_mark` and `exam_mark`.

## Second normal form (2NF)

Tables with composite keys store attributes that depend on the whole key:

- `section_lecturer` has no non-key attributes; its pair of IDs identifies one assignment.
- `enrolment.status` depends on the full `(student_id, section_id)` key.
- An assessment's title and weight depend on `(section_id, assessment_no)`.
- A mark's score depends on `(student_id, section_id, assessment_no)`.

## Third normal form (3NF)

Non-key facts are kept with the entity they describe. For example, a programme's department is stored in `programme`, not repeated for every student; a course's title is stored in `course`, not copied into each section; and lecturer contact details are stored in `lecturer`, not repeated in `section_lecturer`.

The final weighted result is derived from the marks and assessment weights instead of duplicating those facts in a separate result column. This avoids update anomalies when a mark is corrected. A published transcript could later use a view or a deliberate snapshot if the system needs to preserve grades as they stood at a particular time.

## Integrity rules that need more than normalisation

The schema uses primary keys, foreign keys, `UNIQUE`, and row-level `CHECK` constraints for local integrity. The active-seat count and the total assessment weight are aggregate rules across multiple rows. The active-seat count is checked while locking the section row in Portfolio 3. [validate-results.sql](validate-results.sql) reports sections whose assessment weights are not 100 and enrolments without a complete mark set. Weighted-result queries also return a result only when every configured assessment has a mark and the weights total 100.

The mark lifecycle rule is enforced by a PostgreSQL trigger: if an enrolment is dropped, marks already present remain, but inserts, updates, and deletes for that dropped enrolment are rejected. The mark's student, section, and assessment identity cannot be reassigned by an update. This preserves the historical marks without copying enrolment status into the mark rows.
