# Portfolio 1: Database Design and Modelling

Design a relational database for the [university portal case study](../CASE_STUDY.md).

The current working design uses PostgreSQL. Review the assumptions in [requirements.md](requirements.md) before treating the model as final.

## Design files

- [Requirements and business rules](requirements.md)
- [ER diagram](erd.md)
- [PostgreSQL schema](schema.sql)
- [Sample data](seed-data.sql)
- [Drop-after-marks edge-case check](edge-case-check.sql)
- [Final-result readiness validation](validate-results.sql)
- [PostgreSQL run summary](run-verification.md)
- [Normalisation explanation](normalisation.md)
- Captured [schema output](schema-run-output.txt), [seed output](seed-run-output.txt), [edge-case output](edge-case-output.txt), [validation output](validation-output.txt), and [PostgreSQL version](postgres-version.txt)

## Evidence included

- Entity-relationship diagram, requirements, schema, sample data, and normalization explanation
- Rollback-only output covering retained marks, blocked edits/deletes, and blocked mark reassignment
- Result-readiness output identifying sections with invalid assessment totals and enrolments without complete marks
- PostgreSQL run summary with the observed edge-case outcomes

## Design decisions to review

- The first version supports multiple lecturers per section through `section_lecturer`.
- Only `enrolled` registrations count toward capacity; `dropped` and `completed` rows do not.
- Assessment marks are percentages, and a final mark is calculated from assessment weights rather than stored separately.

These are the current model assumptions. Review them and be ready to explain the reasons for each choice before submission.
