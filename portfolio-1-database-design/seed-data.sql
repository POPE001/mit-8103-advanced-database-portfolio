-- Small sample dataset for schema.sql. Load once after creating a fresh schema.
-- Explicit IDs are used so the examples are easy to read. Reset each identity
-- sequence after loading the sample rows before inserting generated IDs.

BEGIN;

INSERT INTO department (department_id, code, name) VALUES
    (1, 'COMP', 'School of Computing'),
    (2, 'BUS', 'School of Business');

INSERT INTO programme (programme_id, department_id, code, name) VALUES
    (1, 1, 'MIT', 'Master of Information Technology'),
    (2, 1, 'BSC-CS', 'BSc Computer Science'),
    (3, 2, 'MBA', 'Master of Business Administration');

INSERT INTO student (student_id, programme_id, matric_number, first_name, last_name, email) VALUES
    (1001, 1, 'MIT-2026-001', 'Ada', 'Okafor', 'ada.okafor@example.edu'),
    (1002, 1, 'MIT-2026-002', 'Tunde', 'Bello', 'tunde.bello@example.edu'),
    (1003, 2, 'CSC-2026-001', 'Zainab', 'Musa', 'zainab.musa@example.edu'),
    (1004, 2, 'CSC-2026-002', 'Chidi', 'Eze', 'chidi.eze@example.edu');

INSERT INTO lecturer (lecturer_id, department_id, staff_number, first_name, last_name, email) VALUES
    (501, 1, 'COMP-501', 'Mariam', 'Adebayo', 'mariam.adebayo@example.edu'),
    (502, 1, 'COMP-502', 'David', 'Nwosu', 'david.nwosu@example.edu');

INSERT INTO course (course_id, department_id, course_code, title, credit_units) VALUES
    (101, 1, 'MIT8103', 'Advanced Database Systems', 3),
    (102, 1, 'CSC8101', 'Database Design', 3);

INSERT INTO academic_term (term_id, academic_year, term_name, starts_on, ends_on) VALUES
    (201, '2026/2027', 'First Semester', DATE '2026-09-01', DATE '2026-12-20');

INSERT INTO course_section (section_id, course_id, term_id, section_code, capacity) VALUES
    (901, 101, 201, 'A', 3),
    (902, 102, 201, 'A', 30);

INSERT INTO section_lecturer (section_id, lecturer_id) VALUES
    (901, 501),
    (901, 502),
    (902, 502);

INSERT INTO enrolment (student_id, section_id, status) VALUES
    (1001, 901, 'enrolled'),
    (1002, 901, 'enrolled'),
    (1003, 901, 'dropped'),
    (1001, 902, 'enrolled');

INSERT INTO assessment (section_id, assessment_no, title, weight_percent) VALUES
    (901, 1, 'Coursework', 40.00),
    (901, 2, 'Final Examination', 60.00);

INSERT INTO mark (student_id, section_id, assessment_no, score_percent) VALUES
    (1001, 901, 1, 78.00),
    (1001, 901, 2, 82.00),
    (1002, 901, 1, 65.00),
    (1002, 901, 2, 74.00);

SELECT setval(pg_get_serial_sequence('department', 'department_id'), (SELECT MAX(department_id) FROM department));
SELECT setval(pg_get_serial_sequence('programme', 'programme_id'), (SELECT MAX(programme_id) FROM programme));
SELECT setval(pg_get_serial_sequence('student', 'student_id'), (SELECT MAX(student_id) FROM student));
SELECT setval(pg_get_serial_sequence('lecturer', 'lecturer_id'), (SELECT MAX(lecturer_id) FROM lecturer));
SELECT setval(pg_get_serial_sequence('course', 'course_id'), (SELECT MAX(course_id) FROM course));
SELECT setval(pg_get_serial_sequence('academic_term', 'term_id'), (SELECT MAX(term_id) FROM academic_term));
SELECT setval(pg_get_serial_sequence('course_section', 'section_id'), (SELECT MAX(section_id) FROM course_section));

COMMIT;
