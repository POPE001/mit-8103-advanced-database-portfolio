# Portfolio 4: NoSQL and Advanced Data Models

Create a NoSQL representation of data from the same [university portal](../CASE_STUDY.md).

This activity uses a MongoDB document read model for student transcripts. Assessment marks and course results are embedded with the student so a transcript can be read as one document.

## Working files

- [Document model and trade-offs](model.md)
- [Sample transcript documents and indexes](load-data.js)
- [MongoDB queries](queries.js)
- [Run results](run-results.md)
- [Load output](load-output.txt)
- [Query output](query-results.txt)

## Evidence

- Embedded student transcript document model and trade-off explanation
- Sample documents, a student transcript lookup, course query, and aggregate result
- MongoDB load and query output
- Explanation of the connection to the PostgreSQL relational source model

Run the JavaScript files with `mongosh` against a disposable MongoDB database. The current run results are recorded in [run-results.md](run-results.md).
