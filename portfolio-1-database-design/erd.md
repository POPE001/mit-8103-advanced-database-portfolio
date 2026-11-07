# Entity Relationship Diagram

```mermaid
erDiagram
    DEPARTMENT ||--o{ PROGRAMME : contains
    DEPARTMENT ||--o{ COURSE : offers
    DEPARTMENT ||--o{ LECTURER : employs
    PROGRAMME ||--o{ STUDENT : includes
    COURSE ||--o{ COURSE_SECTION : scheduled_as
    ACADEMIC_TERM ||--o{ COURSE_SECTION : contains
    COURSE_SECTION ||--o{ SECTION_LECTURER : staffed_by
    LECTURER ||--o{ SECTION_LECTURER : teaches
    STUDENT ||--o{ ENROLMENT : makes
    COURSE_SECTION ||--o{ ENROLMENT : receives
    COURSE_SECTION ||--o{ ASSESSMENT : defines
    ENROLMENT ||--o{ MARK : earns
    ASSESSMENT ||--o{ MARK : scored_in

    DEPARTMENT {
        bigint department_id PK
        varchar code UK
        varchar name UK
    }
    PROGRAMME {
        bigint programme_id PK
        bigint department_id FK
        varchar code UK
        varchar name
    }
    STUDENT {
        bigint student_id PK
        bigint programme_id FK
        varchar matric_number UK
        varchar email UK
    }
    LECTURER {
        bigint lecturer_id PK
        bigint department_id FK
        varchar staff_number UK
        varchar email UK
    }
    COURSE {
        bigint course_id PK
        bigint department_id FK
        varchar course_code UK
        smallint credit_units
    }
    ACADEMIC_TERM {
        bigint term_id PK
        varchar academic_year
        varchar term_name
        date starts_on
        date ends_on
    }
    COURSE_SECTION {
        bigint section_id PK
        bigint course_id FK
        bigint term_id FK
        varchar section_code
        integer capacity
    }
    SECTION_LECTURER {
        bigint section_id PK, FK
        bigint lecturer_id PK, FK
    }
    ENROLMENT {
        bigint student_id PK, FK
        bigint section_id PK, FK
        varchar status
    }
    ASSESSMENT {
        bigint section_id PK, FK
        smallint assessment_no PK
        numeric weight_percent
    }
    MARK {
        bigint student_id PK, FK
        bigint section_id PK, FK
        smallint assessment_no PK, FK
        numeric score_percent
    }
```

`MARK` references both the student's enrolment and the section's assessment using composite foreign keys. This prevents recording a mark for an assessment in a different section from the student's enrolment.
