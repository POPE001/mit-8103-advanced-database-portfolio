# Case Study: University Course Registration and Results Portal

## Scenario

This portfolio uses a simulated course registration and results portal for a mid-sized university. Students use it to select courses and review results; lecturers use it to submit assessment marks; departmental administrators and the registrar maintain course offerings and academic records.

## Users

- Students: register for or drop course sections and view their results.
- Lecturers: view assigned sections and enter assessment marks.
- Department administrators: maintain courses, sections, and lecturer assignments.
- Registrar: manage academic terms, oversee registration, and produce official records.

## Data in scope

The relational design will cover students, programmes, departments, courses, academic terms, course sections, lecturer assignments, enrolments, assessments, and student marks/results.

## Core operations

1. Create an academic term and offer course sections with a lecturer and seat capacity.
2. Register a student in a section or drop an existing enrolment.
3. Prevent duplicate enrolments and prevent confirmed enrolments from exceeding section capacity.
4. Record marks for a student's required assessments and determine the final course result.
5. Show a student's current registrations and completed results.

## Initial business rules

- A course section belongs to one course and one academic term.
- A student can have at most one enrolment in a particular section.
- A section's confirmed enrolment count cannot exceed its capacity.
- Each assessment belongs to a section; a student can receive at most one mark for that assessment.
- Results are associated with the student, section, and academic term so they can be retrieved as a transcript.

These are working assumptions for the portfolio. Confirm or revise them while building the ER diagram and relational schema, and document any changes.
