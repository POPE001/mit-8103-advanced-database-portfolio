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

## Planned evidence

- Screenshots or command output showing the schema and sample data
- Query output demonstrating the main relationships
- Output from the rollback-only edge-case check

## Working design questions

- The first version supports multiple lecturers per section through `section_lecturer`.
- Only `enrolled` registrations count toward capacity; `dropped` and `completed` rows do not.
- Assessment marks are percentages, and a final mark is calculated from assessment weights rather than stored separately.

These are draft design choices. Review and be ready to explain them before submission.
