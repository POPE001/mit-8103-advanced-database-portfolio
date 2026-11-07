# Portfolio 2: Query Processing and Optimisation

Apply query processing and optimisation to the [university portal](../CASE_STUDY.md), using the relational schema from Portfolio 1.

The workload uses a reproducible synthetic dataset and compares the same course-performance query before and after adding indexes.

## Working files

- [Synthetic data generator](generate-data.sql)
- [Representative queries](queries.sql)
- [Performance query](performance-query.sql)
- [Section assessment summary query](assessment-performance-query.sql)
- [Indexes under evaluation](indexes.sql)
- [Run results](run-results.md)
- [Representative query output](query-results.txt)
- [Weighted query plans before and after indexes](explain-before.txt), [after](explain-after.txt)
- [Section assessment plans before and after indexes](assessment-explain-before.txt), [after](assessment-explain-after.txt)

## Planned evidence

- SQL queries and their results
- Execution plans for selected queries
- Indexing or query rewrites, with before-and-after plan evidence
- Brief analysis of the measured results and test data size

Run Portfolio 1's `schema.sql` and `seed-data.sql` in a fresh database first, then run `generate-data.sql`. Capture both performance queries before applying `indexes.sql` and again afterward.
