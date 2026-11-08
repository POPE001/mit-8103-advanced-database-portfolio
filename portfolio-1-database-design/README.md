# Portfolio 1: Database Design and Modelling

Design a relational database for the [university portal case study](../CASE_STUDY.md).

The current working design uses PostgreSQL. Review the assumptions in [requirements.md](requirements.md) before treating the model as final.

## Design files

- [Requirements and business rules](requirements.md)
- [ER diagram](erd.md)
- [PostgreSQL schema](schema.sql)
- [Sample data](seed-data.sql)
- [Drop-after-marks edge-case check](edge-case-check.sql)
- [PostgreSQL run summary](run-verification.md)
- [Normalisation explanation](normalisation.md)

## Evidence included

- Entity-relationship diagram, requirements, schema, sample data, and normalization explanation
- Rollback-only SQL check for marks after an enrolment is dropped
- PostgreSQL run summary with the observed edge-case and weighted-result outcomes

## Design decisions to review

- The first version supports multiple lecturers per section through `section_lecturer`.
- Only `enrolled` registrations count toward capacity; `dropped` and `completed` rows do not.
- Assessment marks are percentages, and a final mark is calculated from assessment weights rather than stored separately.

These are the current model assumptions. Review them and be ready to explain the reasons for each choice before submission.
