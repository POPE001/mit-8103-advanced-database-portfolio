# MIT 8103 Advanced Database Systems Portfolio Summary

> **Draft for personal audit.** Review the technical claims against the linked evidence, add any personal details to the reflection, and confirm the AI-use statement before submitting.

**Student:** [Add name and student ID]  
**Repository:** [mit-8103-advanced-database-portfolio](https://github.com/POPE001/mit-8103-advanced-database-portfolio)

## Case study

This portfolio develops a database design for a fictional university course registration and results portal. Students register for or drop course sections and view results; lecturers submit assessment marks; administrators manage courses and offerings; and the registrar oversees terms and academic records. The core requirements include preventing duplicate enrolments and over-capacity sections, recording assessment marks, calculating final results, and retrieving a student's registration and transcript history. The case-study assumptions are documented in [CASE_STUDY.md](../CASE_STUDY.md).

## Portfolio activities and evidence

### 1. Relational database design and modelling

I designed a normalized PostgreSQL schema with 11 tables for departments, programmes, students, courses, terms, sections, lecturer assignments, enrolments, assessments, and marks. Primary and foreign keys and other constraints represent the main relationships and protect row-level integrity. Assessment weights and marks are stored separately, with final percentages calculated from them. The mark-lifecycle rule preserves marks earned before a student drops a section while rejecting later inserts, edits, or deletions for that dropped enrolment. The ER diagram, schema, normalization notes, and verification are in [Portfolio 1](../portfolio-1-database-design/README.md). In a disposable PostgreSQL 16 database, the edge-case check confirmed the retained mark, rejected all three prohibited operations, and confirmed that a dropped enrolment did not consume a seat; the sample weighted results were 80.40 and 70.40.

### 2. Query processing and optimisation

I generated a synthetic workload in PostgreSQL 16.14 containing 10,004 students, 82 courses, 162 sections, 50,004 enrolments, 322 assessments, and 96,784 marks. I compared `EXPLAIN (ANALYZE, BUFFERS)` plans for a weighted course-performance query and a section assessment-summary query before and after adding indexes. The first query changed from a primary-key enrolment scan to a partial index-only scan and ran in 10.536 ms before versus 7.019 ms after indexing. The second used a section-assessment index-only scan and ran in 10.270 ms before versus 1.307 ms after. These are single-run measurements from one temporary container, so they show the observed plan and timing changes but are indicative rather than a general performance guarantee. Plans and caveats are recorded in [Portfolio 2](../portfolio-2-query-optimisation/run-results.md).

### 3. Transactions and concurrency control

I demonstrated a committed change and a rolled-back change, then tested two students attempting to take the final seat in a section with capacity three. Without locking, both sessions read two active enrolments and inserted, leaving four enrolments for three seats. With a `SELECT ... FOR UPDATE` lock on the section row, one session registered and the other waited about 1.58 seconds before finding no seat; the final count remained three. This demonstrates why checking capacity and inserting must be protected as one serialized operation. Session output and explanations are in [Portfolio 3](../portfolio-3-transactions-concurrency/run-results.md).

### 4. NoSQL data modelling

For MongoDB 7.0.45, I modelled student transcripts as embedded documents in the `studentTranscripts` collection. This supports a student-centred transcript read in one document, with course results and assessment breakdowns embedded in each term. A unique `_id` lookup and a multikey index on course codes support the demonstrated access patterns. The sample queries returned Ada Okafor's two results, course results for Ada Okafor and Tunde Bello, and a 75.4 average across the two sample students. PostgreSQL remains the normalized source model; the MongoDB transcript is a read model whose copied course details would need synchronization. See the [document model](../portfolio-4-nosql/model.md) and [run results](../portfolio-4-nosql/run-results.md).

### 5. Distributed and cloud database exercise

I configured PostgreSQL 16.14 logical replication between publisher and subscriber containers using Docker Compose. The subscription streamed changes asynchronously. When replication was paused, the publisher's section capacity changed from three to four while the subscriber still returned three; after replication resumed, the subscriber caught up to four. This demonstrates eventual consistency and the possibility of stale reads. The exercise ran locally and did not deploy to a public cloud provider. The subscriber is not an automatic failover target; schema changes and sequence state also require separate handling. The [architecture](../portfolio-5-distributed-cloud/architecture.md) and [captured results](../portfolio-5-distributed-cloud/run-results.md) document the setup and its limits.

## Individual reflection — draft

One design choice across the portfolio was to keep PostgreSQL as the normalized source for registration and marks, while using MongoDB as a transcript-oriented read model. That distinction made the trade-offs visible: normalization supports shared facts and integrity, while embedding makes a student's transcript convenient to retrieve but duplicates some descriptive data. The capacity test also showed that a correct rule in application logic is not enough by itself; concurrent transactions need database locking around the check-and-insert operation. The replication test made the consistency trade-off observable by showing an old subscriber value during a pause and the later catch-up.

**Personalize before submission:** add one or two sentences about which part you found most challenging, what you changed after testing it, and what you would improve next. Keep only statements that match your own experience and that you can explain from the linked work.

## References and AI-use declaration

- PostgreSQL, [Explicit Locking](https://www.postgresql.org/docs/16/explicit-locking.html), [Using `EXPLAIN`](https://www.postgresql.org/docs/16/using-explain.html), and [Logical Replication](https://www.postgresql.org/docs/16/logical-replication.html).
- MongoDB, [Embedded Data](https://www.mongodb.com/docs/v7.0/data-modeling/embedding/) and [Multikey Indexes](https://www.mongodb.com/docs/v7.0/core/indexes/index-types/index-multikey/).

**AI-use declaration — draft for verification:** OpenAI Codex assisted with planning the portfolio, drafting and troubleshooting SQL and NoSQL materials, interpreting captured outputs, and preparing this summary. The database demonstrations were run in disposable local PostgreSQL 16.14 and MongoDB 7.0.45 containers. Before submission, I will verify the evidence, ensure I can explain the submitted work, and adjust this disclosure to match the course policy and the assistance actually used.
